//
//  InitialViewController.h
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class BWVenueListViewController, BWPanelViewController;

@interface BWMainViewController : UIViewController

- (void)loadVenueList:(NSArray *)list;
- (void)hidePanelView:(BOOL)shouldHide;
- (void)movePanelViewByDistance:(float)dist;
- (void)didUntouchPanelViewThumbButton;

@end
