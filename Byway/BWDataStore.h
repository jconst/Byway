//
//  BWDataStore.h
//  Byway
//
//  Created by Joseph Constantakis on 1/28/14.
//  Copyright (c) 2014 Joseph Constan. All rights reserved.
//

#import "DOSingleton.h"
#import <CoreLocation/CoreLocation.h>

#define DATASTORE ((BWDataStore *)[BWDataStore sharedInstance])

@interface BWDataStore : DOSingleton

@property (strong, nonatomic) CLLocation *startLoc;
@property (strong, nonatomic) CLLocation *endLoc;
@property (strong, nonatomic) NSArray *suggestedVenues;
@property (strong, nonatomic) NSArray *selectedVenues;
@property (strong, nonatomic) NSArray *routeWaypoints;
@property (strong, nonatomic) NSString *encoded;

@end
