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

@interface BWPanelViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    CLGeocoder *geocoder;
    
    MKPlacemark *startLoc;
    MKPlacemark *endLoc;
    
    
    NSArray *waypoints;
    BWMainViewController *initialViewController;
    NSMutableArray *venues;
    NSMutableDictionary *venuesDict;
    
    NSInteger maxDistance;
    NSInteger maxLikes;
    NSString *category;
}
- (IBAction) thumbButtonDragged:(id) sender withEvent:(UIEvent *) event;
- (IBAction)touchedAnywhere;
- (IBAction)hideKeyboard;
- (IBAction)goPressed:(id)sender;

- (IBAction)showCategories:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) BWMapHelper *mapHelper;

@property (nonatomic) BOOL isHidden;

@end
