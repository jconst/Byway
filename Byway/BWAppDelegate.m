//
//  AppDelegate.m
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import "BWAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation BWAppDelegate

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *secretsPath = [[NSBundle mainBundle] pathForResource:@"secrets" ofType:@"plist"];
    NSDictionary *secrets = [NSDictionary dictionaryWithContentsOfFile:secretsPath];
    [GMSServices provideAPIKey:secrets[@"GoogleAPIKey"]];
    
    return YES;
}

@end
