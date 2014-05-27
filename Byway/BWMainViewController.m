//
//  InitialViewController.m
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import "BWMainViewController.h"
#import <ReactiveCocoa.h>
#import <ObjectiveSugar.h>
#import "BWAppDelegate.h"
#import "BWVenueListViewController.h"
#import "BWPanelViewController.h"
#import "BWDataStore.h"
#import "BWAPIManager.h"

#define kMasterViewCenterHidden CGPointMake(160, -54)
#define kMasterViewCenterVisible CGPointMake(160, 115)

@interface BWMainViewController ()
@property (strong, nonatomic) GMSMarker *startMarker;
@property (strong, nonatomic) GMSMarker *endMarker;
@property (strong, nonatomic) NSArray *venueMarkers;

@property (strong, nonatomic) GMSPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView *routeLineView;

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *panelContainer;
@property (strong, nonatomic) IBOutlet UIView *tableContainer;

@property (strong, nonatomic) BWVenueListViewController *detailViewController;
@property (assign, nonatomic) BWPanelViewController *panelViewController;

@end

@implementation BWMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.myLocationEnabled = YES;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.mapView.myLocation.coordinate
                                                               zoom:15];
    [self.mapView animateToCameraPosition:camera];
    
    [self setupBindings];
}

- (void)setupBindings
{
    //Update map when start/end locations are set/changed:
    RACSignal *srcSignal = [[RACObserve(DATASTORE, startLoc) distinctUntilChanged] ignore:nil];
    RACSignal *dstSignal = [[RACObserve(DATASTORE, endLoc) distinctUntilChanged] ignore:nil];
    RACSignal *endpointSignal = [RACSignal merge:@[srcSignal, dstSignal]];
    [endpointSignal subscribeNext:^(CLLocation *newLoc) {
        //update pins
        [self updateRouteWithLocation:newLoc];
    }];
    
    RACSignal *midpointSignal = [RACSignal combineLatest:@[srcSignal, dstSignal]
    reduce:(id)^(CLLocation *src, CLLocation *dst){
        CLLocation *mid = [[CLLocation alloc] initWithLatitude:(src.coordinate.latitude + dst.coordinate.latitude)/2.0
                                                     longitude:(src.coordinate.longitude + dst.coordinate.longitude)/2.0];
        return mid;
    }];
    
    //Until a start/end is set, follow the current location:
    [[RACObserve(self.mapView, myLocation) takeUntilReplacement:midpointSignal]
     subscribeNext:^(CLLocation *newLocation) {
         GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:newLocation.coordinate
                                                                    zoom:1];
         [self.mapView animateToCameraPosition:camera];
     }];
    
    [RACSignal combineLatest:@[srcSignal, dstSignal]
    reduce:(id)^(CLLocation *src, CLLocation *dst) {
        //get route waypoints
        [[[BWAPIManager apiManager] routeThroughLocations:@[src, dst]]
         subscribeNext:^(RACTuple *tuple) {
             DATASTORE.routeWaypoints = [tuple first];
             DATASTORE.encoded = [tuple second];
        }];
    }];
    
    [[RACObserve(DATASTORE, routeWaypoints) ignore:nil] subscribeNext:^(NSArray *waypoints) {
        [self drawRouteWithWaypoints:waypoints];
    }];
}

- (void)updateRouteWithLocation:(CLLocation *)loc
{
    [self createMapMarkers];
    if (loc == DATASTORE.startLoc)
        self.startMarker.position = loc.coordinate;
    else
        self.endMarker.position = loc.coordinate;
}

- (void)createMapMarkers
{
    if (!self.startMarker || !self.endMarker) {
        self.startMarker = [[GMSMarker alloc] init];
        self.endMarker = [[GMSMarker alloc] init];
        [@[self.startMarker, self.endMarker] each:^(GMSMarker *marker) {
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.map = self.mapView;
        }];
    }
}

- (void)drawRouteWithWaypoints:(NSArray *)waypoints
{
    GMSMutablePath *path = [GMSMutablePath path];
    [waypoints each:^(CLLocation *waypoint) {
        [path addCoordinate:waypoint.coordinate];
    }];
    self.routeLine = [GMSPolyline polylineWithPath:path];
    self.routeLine.strokeColor = [UIColor blueColor];
    self.routeLine.strokeWidth = 5.f;
    self.routeLine.map = self.mapView;
}

- (void)loadVenueList:(NSArray *)list
{
    self.detailViewController.venueList = [list mutableCopy];
    
    [self hidePanelView:YES];
    [self.detailViewController.tableView reloadData];
}

- (void)hidePanelView:(BOOL)shouldHide
{
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.panelContainer.center = shouldHide ? kMasterViewCenterHidden : kMasterViewCenterVisible;
    }];
    self.panelViewController.offscreen = shouldHide;
}

- (void)movePanelViewByDistance:(float)dist
{
    if (self.panelContainer.center.y + dist > kMasterViewCenterVisible.y) {
        dist = kMasterViewCenterVisible.y - self.panelContainer.center.y;
    }
    
    [UIView animateWithDuration:0.05 animations:^{
        self.panelContainer.center = CGPointMake(self.panelContainer.center.x, self.panelContainer.center.y + dist);
    }];
}

- (void)didUntouchPanelViewThumbButton
{
    NSInteger threshold = (kMasterViewCenterHidden.y + kMasterViewCenterVisible.y)/2;
    
    BOOL shouldHide = (self.panelContainer.center.y <= threshold);
    
    [self hidePanelView:shouldHide];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedDetail"]) {
        self.detailViewController = (BWVenueListViewController *)segue.destinationViewController;
        self.detailViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"embedMaster"]) {
        self.panelViewController = (BWPanelViewController *)segue.destinationViewController;
    }
}

@end
