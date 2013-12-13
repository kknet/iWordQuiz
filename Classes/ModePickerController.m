//
//  ModePickerController.m
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

#import "ModePickerController.h"
#import "UIColor+PHColor.h"

@interface ModePickerController () {
    int _currentMode;
}

@end

@implementation ModePickerController

@synthesize modes;
@synthesize delegate = m_delegate;

- (NSArray *)modes {
    if (!modes) {
        modes = [NSArray arrayWithObjects:@"Front to Back In Order",
                  @"Back To Front In Order",
                  @"Front To Back Randomly",
                  @"Back To Front Randomly",
                  @"Back <-> Front Randomly", nil];
    }
    return modes;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    self.preferredContentSize = CGSizeMake(290.0, 220.0);
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor popoverBorderColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [self.modes count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	cell.textLabel.text = [self.modes objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor popoverBackgroundColor];
    cell.textLabel.textColor = [UIColor popoverIconColor];
    cell.tintColor = [UIColor iconColor];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	int r = [m_delegate selectedMode] - 1;
	if (r == indexPath.row) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _currentMode = r;
	}
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_currentMode == indexPath.row) {
        return;
    }
    _currentMode = indexPath.row;
    [self.tableView reloadData];
    if (m_delegate != nil) {
		[m_delegate modeSelected:_currentMode];
	}
}

@end
