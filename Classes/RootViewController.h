//
//  RootViewController.h
//  iWordQuiz
//
//  Created by Peter Hedlund on 8/13/10.
//  Copyright 2010-2011 Peter Hedlund.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "WQNewFileViewController.h"
#import "MSDynamicsDrawerViewController.h"

@class DetailViewController;
@class CHDropboxSync;

@interface RootViewController : UITableViewController <UITabBarControllerDelegate, UIActionSheetDelegate, WQNewFileViewControllerDelegate>
{
    int m_currentRow;
}

- (void) enumerateVocabularies;

@property (strong, nonatomic) MSDynamicsDrawerViewController *dynamicsDrawerViewController;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray *vocabularies;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property(strong) CHDropboxSync* syncer;

- (IBAction) doDBSync:(id)sender;
- (IBAction) doActions:(id)sender;

@end
