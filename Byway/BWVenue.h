//
//  Venue.h
//  Byway
//
//  Created by Joseph Constan on 9/30/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JCModel.h"

@interface BWVenue : JCModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *category;
@property (nonatomic) double minDistance;
@property (nonatomic) double value;
@property (nonatomic) int likes;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) NSUInteger index;

@end
