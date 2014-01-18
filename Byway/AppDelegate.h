//
//  AppDelegate.h
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define LOGMETHOD NSLog(@"Logged Method: %@", NSStringFromSelector(_cmd))

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)showError:(NSError *)error;

@end
