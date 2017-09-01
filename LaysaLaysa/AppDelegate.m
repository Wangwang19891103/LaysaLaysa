//
//  AppDelegate.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "PDKClient.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "JSONManager.h"

static NSString * const kPDKAppId = @"4835344925941843902";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [PDKClient configureSharedInstanceWithAppId:kPDKAppId];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //For Push Notifications
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7){//for ios 8 and higth
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
////        [self registerForNotification];
//    }
    
    return YES;
}

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
//    NSString* token = [NSString stringWithFormat:@"%@", deviceToken];
//    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    [JSONManager sendDeviceTokenToServer:token];
//    
//    NSLog(@"Token is: %@", token);
//}

//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"Failed to get token, error: %@", error);
//}
//
//- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    if ( application.applicationState == UIApplicationStateActive ){
//        // app was already in the foreground and we show custom push notifications view
//    } else {
//        // app was just brought from background to foreground and we wait when user click or slide on push notification
//    }
//    NSLog(@"Received notification: %@", userInfo);
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[PDKClient sharedInstance] handleCallbackURL:url] || [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
