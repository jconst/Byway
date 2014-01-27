//
//  InitialViewController.h
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class BWVenueListViewController, BWPanelViewController;

@interface BWMainViewController : UIViewController <MKMapViewDelegate> {
    MKPolyline *routeLine;
    MKPolylineView *routeLineView;
    
    BWVenueListViewController *detailViewController;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *masterContainer;
@property (strong, nonatomic) IBOutlet UIView *tableContainer;
@property (nonatomic) BWPanelViewController *mvc;

- (void)drawRouteWithWaypoints:(NSArray *)waypoints;
- (void)loadVenueList:(NSArray *)list;
- (void)hideMasterView:(BOOL)shouldHide;
- (void)moveMasterViewByDistance:(float)dist;
- (void)masterViewReleased;

@end
