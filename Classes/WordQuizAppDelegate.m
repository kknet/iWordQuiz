//
//  WordQuizAppDelegate.m
//  iWordQuiz
//

/************************************************************************

Copyright 2012 Peter Hedlund peter.hedlund@me.com

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

#import "CHDropboxSync.h"

#import "WordQuizAppDelegate.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "MSDynamicsDrawerStyler.h"
#import "DBDefines.h"
#import "UIColor+PHColor.h"

@interface iWordQuizAppDelegate ()

@end

@implementation iWordQuizAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	// Dropbox
    NSString* appKey = DB_APP_KEY;
	NSString* appSecret = DB_APP_SECRET;
	NSString *root = kDBRootAppFolder;
	DBSession* session = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
	session.delegate = self;
	[DBSession setSharedSession:session];

    self.dynamicsDrawerViewController = (MSDynamicsDrawerViewController *)self.window.rootViewController;
    self.dynamicsDrawerViewController.shouldAlignStatusBarToPaneView = NO;
    [self.dynamicsDrawerViewController setRevealWidth:320.0f forDirection:MSDynamicsDrawerDirectionLeft];
    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerParallaxStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];

    RootViewController *rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Drawer"];
    rootViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    [self.dynamicsDrawerViewController setDrawerViewController:rootViewController forDirection:MSDynamicsDrawerDirectionLeft];
    
    UINavigationController *detailNavController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Pane"];
    [self.dynamicsDrawerViewController setPaneViewController:detailNavController];
    DetailViewController *detailViewController = (DetailViewController*)detailNavController.topViewController;
    detailViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    rootViewController.detailViewController = detailViewController;

    [self.window setBackgroundColor:[UIColor backgroundColor]];

    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	//Application launch with attachment
	if ([url isFileURL]) {
		//todo test this code[self.rootViewController enumerateVocabularies];
        RootViewController *rootController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
            UINavigationController *navController = [splitViewController.viewControllers objectAtIndex:0];
            rootController = (RootViewController*)navController.topViewController;
        } else {
            UINavigationController *navController = (UINavigationController*)self.window.rootViewController;
            rootController = (RootViewController*)navController.topViewController;
        }
        [rootController enumerateVocabularies];
        
	}
	else
	{
		// Handle custom URL scheme
        if ([[DBSession sharedSession] handleOpenURL:url]) {
            if ([[DBSession sharedSession] isLinked]) {
                NSLog(@"We have Dropbox link");
                [CHDropboxSync forgetStatus];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Linked" object:nil];
            }
            //return YES;
        }
	}	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}




#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId {
	relinkUserId = userId;
	[[[UIAlertView alloc] 
	   initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self 
	   cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil]
	 show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
	if (index != alertView.cancelButtonIndex) {
		[[DBSession sharedSession] linkUserId:relinkUserId fromController:self.window.rootViewController];
	}
	relinkUserId = nil;
}

@end
