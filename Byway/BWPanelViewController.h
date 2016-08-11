//
//  MasterViewController.h
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JCButtonBar.h"

@class BWMainViewController, BWMapHelper;

@interface BWPanelViewController : UIViewController <UITextFieldDelegate>

- (IBAction)thumbButtonDragged:(id)sender withEvent:(UIEvent *) event;
- (IBAction)touchedAnywhere;
- (IBAction)didTapGo:(id)sender;

@property (nonatomic, getter = isOffscreen) BOOL offscreen;
@property (weak, nonatomic) IBOutlet JCButtonBar *categoryBar;

@end
