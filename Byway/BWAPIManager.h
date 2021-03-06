//
//  APIManager.h
//  Byway
//
//  Created by Joseph Constantakis on 1/27/14.
//  Copyright (c) 2014 Joseph Constan. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AFHTTPRequestOperationManager.h"

@interface BWAPIManager : AFHTTPRequestOperationManager

+ (instancetype)apiManager;

+ (void)geocodeSearchString:(NSString *)search
                 completion:(void (^)(CLLocation *loc, NSString *address, NSError *error))comp;
+ (RACSignal *)routeThroughLocations:(RACSignal *)locationsSignal;
+ (RACSignal *)venuesAlongPolyline:(NSString *)encoded
                      inCategories:(NSArray *)categories;
@end
