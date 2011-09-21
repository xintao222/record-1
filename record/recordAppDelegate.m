//
//  recordAppDelegate.m
//  record
//
//  Created by 振江 张 on 11-9-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "recordAppDelegate.h"

#import "recordViewController.h"

@implementation recordAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[application setStatusBarHidden:NO animated:NO]; 
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //圖片擴大淡出的效果开始;
    
    //设置一个图片;
    UIImageView *niceView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    niceView.image = [UIImage imageNamed:@"Default.png"];
    
    //添加到场景
    [self.window addSubview:niceView];
    
    //放到最顶层;
    [self.window bringSubviewToFront:niceView];
    
    //开始设置动画;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    //這裡還可以設置回調函數;
    
    //[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    
    niceView.alpha = 0.0;
    niceView.frame = CGRectMake(-60, -85, 440, 635);
    [UIView commitAnimations];
    [niceView release];
    
    //结束;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
