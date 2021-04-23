//
//  AppDelegate.m
//  FollyPhoneTest
//
//  Created by WS Build on 4/19/21.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIViewController *vc = [[ViewController alloc] init];
    UIWindow *window = [[UIWindow alloc] initWithFrame: UIScreen.mainScreen.bounds];
    window.rootViewController = vc;
    [self setWindow:window];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
