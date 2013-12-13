//
//  DetailViewController.m
//  iWordQuiz
//

/************************************************************************

Copyright 2012-2013 Peter Hedlund peter.hedlund@me.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*************************************************************************/

#import "DetailViewController.h"
#import "HomeViewController.h"
#import "FCViewController.h"
#import "MCViewController.h"
#import "QAViewController.h"
#import "AboutViewController.h"
#import "TransparentToolbar.h"
#import "WQUtils.h"
#import "UIColor+PHColor.h"
#import "UIImage+PHColor.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize masterPopoverController = _masterPopoverController;
@synthesize modePicker = _modePicker;
@synthesize modePickerPopover;
@synthesize doc = _doc;
@synthesize detailItem = _detailItem;
@synthesize modeBarButtonItem, editBarButtonItem, infoBarButtonItem;

- (void)documentContentsDidChange:(WQDocument *)document {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (m_quiz != nil) {
            m_quiz = nil;
        }
        
        m_quiz = [[WQQuiz alloc] init];
        [m_quiz setEntries:[document quizEntries]];
        [m_quiz setFrontIdentifier:[document frontIdentifier]];
        [m_quiz setBackIdentifier:[document backIdentifier]];
        [m_quiz setFileName:[[document.fileURL lastPathComponent] stringByDeletingPathExtension]];
        
        [self activateTab:self.selectedIndex];
        self.navigationItem.title = [[document.fileURL lastPathComponent] stringByDeletingPathExtension];
    });
}

#pragma mark -
#pragma mark Managing the detail item


// When setting the detail item, update the view and dismiss the popover controller if it's showing.

- (void)setDetailItem:(NSURL*)newDetailItem {
    //if (_detailItem != newDetailItem) {
        
        _detailItem = newDetailItem;
        
        // Update the view.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (_detailItem == nil) {
                if (_doc != nil) {
                    [_doc closeWithCompletionHandler:nil];
                    _doc = nil;
                }
                if (m_quiz != nil) {
                    m_quiz = nil;
                }
                [self setSelectedIndex:0];
                [self activateTab:0];
                [[(HomeViewController*)[self.viewControllers objectAtIndex:0] spreadView] reloadData];
            } else {
                [self configureView];
            }
            self.editBarButtonItem.enabled = (_doc != nil);
        }
    //}
	if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}


- (void)configureView {
    if (_doc != nil) {
        [_doc closeWithCompletionHandler:nil];
        _doc = nil;
    }

    _doc = [[WQDocument alloc] initWithFileURL:_detailItem];
    _doc.delegate = self;

    [_doc openWithCompletionHandler:^(BOOL success) {
        
        if (m_quiz != nil) {
            m_quiz = nil;
        }
        
        m_quiz = [[WQQuiz alloc] init];
        [m_quiz setEntries:[_doc quizEntries]];
        [m_quiz setFrontIdentifier:[_doc frontIdentifier]];
        [m_quiz setBackIdentifier:[_doc backIdentifier]];
        [m_quiz setFileName:[[_detailItem lastPathComponent] stringByDeletingPathExtension]];
        
        if (![self hasEnoughEntries:self.selectedIndex]) {
            [self setSelectedIndex:0];
            [self activateTab:0];
        }
        //[self activateTab:self.selectedIndex];
        self.navigationItem.title = [[_detailItem lastPathComponent] stringByDeletingPathExtension];
     }];
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    barButtonItem.title = @"Vocabularies";
	[self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	[self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	for (UIViewController *myView in self.viewControllers) {
		[myView willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
}



#pragma mark -
#pragma mark View lifecycle


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.editBarButtonItem.enabled = (_doc != nil);
        self.navigationItem.rightBarButtonItems = @[self.infoBarButtonItem, self.editBarButtonItem, self.modeBarButtonItem];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.navigationItem.rightBarButtonItems = @[self.editBarButtonItem, self.modeBarButtonItem];
    }
    self.navigationController.navigationBar.tintColor = [UIColor iconColor];
    self.navigationController.navigationBar.barTintColor = [UIColor backgroundColor];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowBlurRadius = 0.0;
    shadow.shadowOffset = CGSizeMake(0.0, 0.0);

    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor iconColor], NSForegroundColorAttributeName,
      shadow, NSShadowAttributeName, nil]];

    self.tabBar.tintColor = [UIColor iconColor];
    self.tabBar.barTintColor = [UIColor backgroundColor];
    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor iconColor], NSForegroundColorAttributeName, nil]
                                             forState: UIControlStateSelected];

    UIColor *unselectedColor = [UIColor colorWithRed:0.70 green:0.60 blue:0.42 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: unselectedColor, NSForegroundColorAttributeName, nil]
                                             forState: UIControlStateNormal];
    
    // set selected and unselected icons
    UIImage *img;
    UITabBarItem *item;
    
    item = [self.tabBar.items objectAtIndex:0];
    img = [UIImage changeImage:[UIImage imageNamed:@"homeTab"] toColor:unselectedColor];
    item.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [UIImage imageNamed:@"homeTab"];

    item = [self.tabBar.items objectAtIndex:1];
    img = [UIImage changeImage:[UIImage imageNamed:@"flashTab"] toColor:unselectedColor];
    item.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [UIImage imageNamed:@"flashTab"];

    item = [self.tabBar.items objectAtIndex:2];
    img = [UIImage changeImage:[UIImage imageNamed:@"multipleTab"] toColor:unselectedColor];
    item.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [UIImage imageNamed:@"multipleTab"];

    item = [self.tabBar.items objectAtIndex:3];
    img = [UIImage changeImage:[UIImage imageNamed:@"qaTab"] toColor:unselectedColor];
    item.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [UIImage imageNamed:@"qaTab"];

    //remove bottom line/shadow
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:[UIImageView class]]) {
                if (![view2.superview isKindOfClass:[UIButton class]]) {
                    [view2 removeFromSuperview];
                }
                
            }
        }
    }

    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    m_currentRow = 0;
	[self activateTab:1];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selectedViewController willRotateToInterfaceOrientation:[[UIDevice currentDevice] orientation ] duration:0];
    // Update the view.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self configureView];
    }
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.masterPopoverController = nil;
    [_doc closeWithCompletionHandler:nil];
}


- (void)activateTab:(int)index {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSInteger
	NSInteger myMode = [prefs integerForKey:@"Mode"];
	if (myMode == 0) {
		myMode = 1;
	}
	if (m_quiz != nil) {
		m_quiz.quizMode = myMode;
        HomeViewController *homeViewController;
        switch (index) {
            case 0:
                homeViewController = (HomeViewController*)[self.viewControllers objectAtIndex:0];
                [homeViewController restart];
                break;
            case 1:
                m_quiz.quizType = WQQuizTypeFC;
                [(FCViewController *) self.selectedViewController setQuiz:m_quiz];
                [(FCViewController *) self.selectedViewController restart];
                break;
            case 2:
                m_quiz.quizType = WQQuizTypeMC;
                [(MCViewController *) self.selectedViewController setQuiz:m_quiz];
                [(MCViewController *) self.selectedViewController restart];
                break;
            case 3:
                m_quiz.quizType = WQQuizTypeQA;
                [(QAViewController *) self.selectedViewController setQuiz:m_quiz];
                [(QAViewController *) self.selectedViewController restart];
                break;
            default:
                break;
        }
	}
}


- (void)modeSelected:(NSUInteger)mode {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	// saving an NSInteger
	[prefs setInteger:mode + 1 forKey:@"Mode"];
	[prefs synchronize];
	
	m_quiz.quizMode = mode + 1;
    [self.modePickerPopover dismissPopoverAnimated:YES];
	[self activateTab:self.selectedIndex];
}

- (NSUInteger)selectedMode {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSInteger
	NSInteger myMode = [prefs integerForKey:@"Mode"];
	if (myMode == 0) {
		myMode = 1;
	}
	
	return myMode;
}

- (IBAction)doMenu:(id)sender {
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:nil];
}

- (IBAction) doMode:(id)sender {
    [self.modePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:(UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown) animated:YES options:WYPopoverAnimationOptionFadeWithScale];
}

- (IBAction) doAbout:(id)sender {
    UINavigationController *navController =  [self.storyboard instantiateViewControllerWithIdentifier:@"about"];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void) doEdit:(id)sender {
    UINavigationController *navController =  [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];

    WQEditViewController *editViewController = (WQEditViewController*)navController.topViewController;
    [self presentViewController:navController animated:YES completion:nil];
    editViewController.delegate = self;
    editViewController.nextButton.enabled = (m_currentRow < (_doc.entries.count - 1));
    editViewController.previousButton.enabled = (m_currentRow > 0);
    editViewController.frontIdentifierLabel.text = _doc.frontIdentifier;
    editViewController.backIdentifierLabel.text = _doc.backIdentifier;
    editViewController.frontTextField.text = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:0];
    editViewController.backTextField.text = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:1];
}

- (void) quizDidFinish {
	//self.repeatErrors.enabled = [m_quiz hasErrors];
}

- (BOOL) hasEnoughEntries:(int)index {
    BOOL result = true;
    switch (index) {
        case 0:
            result = true;
            break;
        case 1:
            result = ((m_quiz != nil) && (m_quiz.entries.count > 0));
            break;
        case 2:
            result = ((m_quiz != nil) && (m_quiz.entries.count > 2));
            break;
        case 3:
            result = ((m_quiz != nil) && (m_quiz.entries.count > 0));
            break;
        default:
            result = true;
            break;
    }
    return result;
}

#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/




#pragma mark - Spread View Datasource

- (NSInteger)spreadView:(MDSpreadView *)aSpreadView numberOfColumnsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)spreadView:(MDSpreadView *)aSpreadView numberOfRowsInSection:(NSInteger)section
{
    if ([self.doc.entries count] == 0)
        return 30;
    else
        return [self.doc.entries count];
}

- (NSInteger)numberOfColumnSectionsInSpreadView:(MDSpreadView *)aSpreadView
{
    return 1;
}

- (NSInteger)numberOfRowSectionsInSpreadView:(MDSpreadView *)aSpreadView
{
    return 1;
}

#pragma Cells
- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    static NSString *cellIdentifier = @"Cell";
    
    MDSpreadViewCell *cell = [aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MDSpreadViewCell alloc] initWithStyle:MDSpreadViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.doc.entries.count > 0) {
        cell.textLabel.text = [[self.doc.entries objectAtIndex:rowPath.row ] objectAtIndex:columnPath.column];
    }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    return cell;
}

- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForHeaderInRowSection:(NSInteger)section forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    static NSString *cellIdentifier = @"RowHeaderCell";
    
    MDSpreadViewHeaderCell *cell = (MDSpreadViewHeaderCell *)[aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MDSpreadViewHeaderCell alloc] initWithStyle:MDSpreadViewHeaderCellStyleRow reuseIdentifier:cellIdentifier];
    }
    
    if (columnPath.column == 0) {
        cell.textLabel.text = [self.doc frontIdentifier];
    } else {
        cell.textLabel.text = [self.doc backIdentifier];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    return cell;
}

- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForHeaderInColumnSection:(NSInteger)section forRowAtIndexPath:(MDIndexPath *)rowPath
{
    static NSString *cellIdentifier = @"ColumnHeaderCell";
    
    MDSpreadViewHeaderCell *cell = (MDSpreadViewHeaderCell *)[aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MDSpreadViewHeaderCell alloc] initWithStyle:MDSpreadViewHeaderCellStyleColumn reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", rowPath.row + 1];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    
    return cell;
}


#pragma mark Heights
// Comment these out to use normal values (see MDSpreadView.h)
- (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowAtIndexPath:(MDIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 25;
    } else {
        return 35;
    }
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowHeaderInSection:(NSInteger)rowSection
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 25;
    } else {
        return 35;
    }
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnAtIndexPath:(MDIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            return (CGRectGetHeight([UIScreen mainScreen].applicationFrame) - 54) / 2;
        } else {
            return (CGRectGetWidth([UIScreen mainScreen].applicationFrame) - 54) / 2;
        }
    } else { //iPad
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            return (CGRectGetHeight([UIScreen mainScreen].applicationFrame) - 70) / 2;
        } else {
            return (CGRectGetWidth([UIScreen mainScreen].applicationFrame) - 70) / 2;
        }
    }
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnHeaderInSection:(NSInteger)columnSection
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 44;
    } else {
        return 60;
    }
}

- (void)spreadView:(MDSpreadView *)aSpreadView didSelectCellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    m_currentRow = rowPath.row;
    m_currentColumn = columnPath.column;
    [aSpreadView reloadData];
}

#pragma mark WQEditViewControllerDelegate

- (void)currentEntryDidChange:(WQEditViewController*)aEditViewController reason:(EditReason)aReason value:(NSString *)aValue {
    NSString *newFront = aEditViewController.frontTextField.text;
    NSString *newBack = aEditViewController.backTextField.text;
    NSString *oldFront = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:0];
    NSString *oldBack = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:1];
    int valueChanges = 0;
    if (![newFront isEqualToString:oldFront])
        ++valueChanges;
    if (![newBack isEqualToString:oldBack])
        ++valueChanges;
    
    if (valueChanges > 0) {
        [_doc.entries removeObjectAtIndex:m_currentRow];
        [_doc.entries insertObject:@[newFront, newBack] atIndex:m_currentRow];
        [_doc updateChangeCount:UIDocumentChangeDone];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
    }
    
    
    switch (aReason) {
        case kNext: {
            ++m_currentRow;
        }
            break;
        case kPrevious: {
            --m_currentRow;
        }
            break;
        case kAdd: {
            [_doc.entries insertObject:@[@"", @""] atIndex:++m_currentRow];
            [_doc updateChangeCount:UIDocumentChangeDone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
        }
            break;
        case kRemove: {
            [_doc.entries removeObjectAtIndex:m_currentRow];
            while (m_currentRow > (_doc.entries.count - 1)) {
                --m_currentRow;
            }
            [_doc updateChangeCount:UIDocumentChangeDone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
        }
            break;
        case kGetVocabInfo: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VocabInfo" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_doc.frontIdentifier, @"FrontIdentifier", _doc.backIdentifier, @"BackIdentifier", _doc.fileURL, @"URL", nil]];
        }
            break;
        case kSetVocabFrontIdentifier: {
            _doc.frontIdentifier = aValue;
            [_doc updateChangeCount:UIDocumentChangeDone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
        }
            break;
        case kSetVocabBackIdentifier: {
            _doc.backIdentifier = aValue;
            [_doc updateChangeCount:UIDocumentChangeDone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
        }
            break;
        case kDone: {
            if (![WQUtils isEmpty:aValue]) {
                NSString *oldFilename = [_doc.fileURL lastPathComponent];
                NSString* fileNameWithExtension = [NSString stringWithFormat:@"%@.kvtml", aValue];
                if (![oldFilename isEqualToString:fileNameWithExtension]) {
                    NSURL* parentDirectory = [_doc.fileURL URLByDeletingLastPathComponent];
                    NSURL* newURL = [parentDirectory URLByAppendingPathComponent:fileNameWithExtension];
                    NSFileManager *fm = [NSFileManager defaultManager];
                    if (![fm fileExistsAtPath:[newURL path]]) {
                        [fm moveItemAtURL:_doc.fileURL toURL:newURL error:nil];
                        [_doc presentedItemDidMoveToURL:newURL];
                        [_doc updateChangeCount:UIDocumentChangeDone];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"FileURL" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:newURL, @"URL", nil]];
                    } 
                }
            } 
            
            [_doc saveToURL:_doc.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                NSLog(@"Degree of success: %i", success);
                if (success) {
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                        [self setDetailItem:_doc.fileURL];
                    }
                    
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                        [self configureView];
                    }
                }
            }];
        }
            break;
        default:
            break;
    }

    aEditViewController.nextButton.enabled = (m_currentRow < (_doc.entries.count - 1));
    aEditViewController.previousButton.enabled = (m_currentRow > 0);
    aEditViewController.frontTextField.text = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:0];
    aEditViewController.backTextField.text = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:1];
}

#pragma mark - Toolbar buttons

- (UIBarButtonItem *)modeBarButtonItem {
    if (!modeBarButtonItem) {
        modeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mode"] style:UIBarButtonItemStylePlain target:self action:@selector(doMode:)];
        modeBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
    }
    return modeBarButtonItem;
}

- (UIBarButtonItem *)editBarButtonItem {
    if (!editBarButtonItem) {
        editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(doEdit:)];
    }
    return editBarButtonItem;
}

- (UIBarButtonItem *)infoBarButtonItem {
    if (!infoBarButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [button addTarget:self action:@selector(doAbout:) forControlEvents:UIControlEventTouchUpInside];
        infoBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return infoBarButtonItem;
}

#pragma mark - Mode Popover

- (WYPopoverController*)modePickerPopover {
    if (!modePickerPopover) {
        _modePicker = [[ModePickerController alloc] initWithStyle:UITableViewStylePlain];
        _modePicker.delegate = self;
        _modePicker.preferredContentSize = CGSizeMake(290.0, 220.0);
        modePickerPopover = [[WYPopoverController alloc] initWithContentViewController:_modePicker];
        WYPopoverBackgroundView* appearance = [WYPopoverBackgroundView appearance];
        [appearance setFillTopColor:[UIColor popoverBackgroundColor]];
    }
    return modePickerPopover;
}

@end
