//
//  InitialViewController.m
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import "BWMainViewController.h"
#import "BWAppDelegate.h"
#import "BWVenueListViewController.h"
#import "BWPanelViewController.h"

#define kMasterViewCenterHidden CGPointMake(160, -55)
#define kMasterViewCenterVisible CGPointMake(160, 115)

@implementation BWMainViewController

@synthesize mapView, masterContainer, tableContainer, mvc;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadVenueList:(NSArray *)list {
    
    detailViewController.venueList = [list mutableCopy];
    
    [self hideMasterView:YES];
    [detailViewController.tableView reloadData];
}

- (void)hideMasterView:(BOOL)shouldHide {
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        masterContainer.center = shouldHide ? kMasterViewCenterHidden : kMasterViewCenterVisible;
    }];
    mvc.isHidden = shouldHide;
}

- (void)moveMasterViewByDistance:(float)dist {
    
    if (masterContainer.center.y + dist > kMasterViewCenterVisible.y) {
        dist = kMasterViewCenterVisible.y - masterContainer.center.y;
    }
    
    [UIView animateWithDuration:0.05 animations:^{
        masterContainer.center = CGPointMake(masterContainer.center.x, masterContainer.center.y + dist);
    }];
}

- (void)masterViewReleased {
    
    NSInteger threshold = (kMasterViewCenterHidden.y + kMasterViewCenterVisible.y)/2;
    
    BOOL shouldHide = (masterContainer.center.y <= threshold);
    
    [self hideMasterView:shouldHide];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    MKOverlayView* overlayView = nil;
    
    if(overlay == routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
            routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
            routeLineView.fillColor = [UIColor redColor];
            routeLineView.strokeColor = [UIColor redColor];
            routeLineView.lineWidth = 3;
        
        overlayView = routeLineView;
    }
    return overlayView;
}

- (void)drawRouteWithWaypoints:(NSArray *)waypoints {
        
    [self.mapView removeOverlays:mapView.overlays];
    
    //Zoom
    [self.mapView setRegion:[self regionFromLocations:waypoints] animated:YES];
    
    MKMapPoint *pointArr = malloc(sizeof(MKMapPoint) * waypoints.count);
    
    //Draw polyline    
    for (int i = 0; i < waypoints.count; i++) {
        CLLocation *loc = [waypoints objectAtIndex:i];
        CLLocationCoordinate2D coord = loc.coordinate;
        
        MKMapPoint point = MKMapPointForCoordinate(coord);
        
        pointArr[i] = point;
    }
    
    routeLine = [MKPolyline polylineWithPoints:pointArr count:waypoints.count];
    
    [self.mapView addOverlay:routeLine];
    
    free(pointArr);
}

- (MKCoordinateRegion)regionFromLocations:(NSArray *)locations {
    CLLocationCoordinate2D upper = [[locations objectAtIndex:0] coordinate];
    CLLocationCoordinate2D lower = [[locations objectAtIndex:0] coordinate];
    
    // FIND LIMITS
    for(CLLocation *eachLocation in locations) {
        if([eachLocation coordinate].latitude > upper.latitude) upper.latitude = [eachLocation coordinate].latitude;
        if([eachLocation coordinate].latitude < lower.latitude) lower.latitude = [eachLocation coordinate].latitude;
        if([eachLocation coordinate].longitude > upper.longitude) upper.longitude = [eachLocation coordinate].longitude;
        if([eachLocation coordinate].longitude < lower.longitude) lower.longitude = [eachLocation coordinate].longitude;
    }
    
    // FIND REGION
    MKCoordinateSpan locationSpan;
    locationSpan.latitudeDelta = upper.latitude - lower.latitude;
    locationSpan.longitudeDelta = upper.longitude - lower.longitude;
    CLLocationCoordinate2D locationCenter;
    locationCenter.latitude = (upper.latitude + lower.latitude) / 2;
    locationCenter.longitude = (upper.longitude + lower.longitude) / 2;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(locationCenter, locationSpan);
    return region;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedDetail"]) {
        detailViewController = (BWVenueListViewController *)segue.destinationViewController;
        detailViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"embedMaster"]) {
        mvc = (BWPanelViewController *)segue.destinationViewController;
    }
}

@end
