//
//  MasterViewController.h
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class BWMainViewController, BWMapHelper;

@interface BWPanelViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

- (IBAction)thumbButtonDragged:(id)sender withEvent:(UIEvent *) event;
- (IBAction)touchedAnywhere;
- (IBAction)didTapGo:(id)sender;

- (IBAction)showCategories:(id)sender;

@property (nonatomic, getter = isOffscreen) BOOL offscreen;

@end
