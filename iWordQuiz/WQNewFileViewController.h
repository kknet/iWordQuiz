//
//  WQNewFileViewController.h
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

#import <UIKit/UIKit.h>

@protocol WQNewFileViewControllerDelegate;

@interface WQNewFileViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *frontTextField;
@property (strong, nonatomic) IBOutlet UITextField *backTextField;
@property (strong, nonatomic) id<WQNewFileViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isEditingVocabulary;

- (IBAction)doDismissView:(id)sender;
- (IBAction)doCreateNew:(id)sender;

- (void) vocabInfo:(NSNotification *)n;

@end

@protocol WQNewFileViewControllerDelegate <NSObject>
@required
- (BOOL)createNewDocument:(WQNewFileViewController*)aWQNewFileViewController;
@end
