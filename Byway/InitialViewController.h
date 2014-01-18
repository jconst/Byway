//
//  InitialViewController.h
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class DetailViewController, MasterViewController;

@interface InitialViewController : UIViewController <MKMapViewDelegate> {
    MKPolyline *routeLine;
    MKPolylineView *routeLineView;
    
    DetailViewController *detailViewController;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *masterContainer;
@property (strong, nonatomic) IBOutlet UIView *tableContainer;
@property (nonatomic) MasterViewController *mvc;

- (void)drawRouteWithWaypoints:(NSArray *)waypoints;
- (void)loadVenueList:(NSArray *)list;
- (void)hideMasterView:(BOOL)shouldHide;
- (void)moveMasterViewByDistance:(float)dist;
- (void)masterViewReleased;

@end
