//
//  MapHelper.h
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapHelper : NSObject {
    MKMapView *mapView;
}

@property (strong, nonatomic) NSMutableArray *pins;

- (void)requestDirectionsFrom:(MKPlacemark *)src to:(MKPlacemark *)dest withWaypoints:(NSArray *)wpList withCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler;
- (void)requestDirectionsFrom:(MKPlacemark *)src to:(MKPlacemark *)dest withCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler;

- (NSArray *)waypointsFromEncodedString:(NSString *)encodedPolyline;

- (void)dropPinOnLocation:(CLLocation *)location;

@end
