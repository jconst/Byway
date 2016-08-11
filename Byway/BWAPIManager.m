//
//  APIManager.m
//  Byway
//
//  Created by Joseph Constantakis on 1/27/14.
//  Copyright (c) 2014 Joseph Constan. All rights reserved.
//

#import "BWAPIManager.h"
#import <ObjectiveSugar.h>
#import <ReactiveCocoa.h>

#define kAPIBaseURL @"http://localhost:5000/1.0/"

@implementation BWAPIManager

+ (instancetype)apiManager
{
    static BWAPIManager *apiManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        apiManager = [[BWAPIManager alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]];
        apiManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    });
    
    return apiManager;
}

+ (void)geocodeSearchString:(NSString *)search completion:(void (^)(CLLocation *loc, NSString *address, NSError *error))comp
{
    [[self apiManager] GET:@"geocode" parameters:@{@"q": search}
    success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
       
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[response[@"coords"][@"lat"] doubleValue]
                                                     longitude:[response[@"coords"][@"lng"] doubleValue]];
        
        if (comp) comp(loc, response[@"address"], nil);
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (comp) comp(nil, nil, error);
    }];
}

+ (RACSignal *)routeThroughLocations:(RACSignal *)locationsSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block AFHTTPRequestOperation *op;
        [locationsSignal subscribeNext:^(NSArray *locations) {
            
            NSArray *locStrings = [locations map:^(CLLocation *location) {
                return [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
            }];
            
            NSDictionary *params = @{@"waypoints": [locStrings join:@"|"]};
            op = [[self apiManager] GET:@"route" parameters:params
            success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
               
               NSArray *waypoints = [response[@"polyline"] map:^id(NSDictionary *coord) {
                   return [[CLLocation alloc] initWithLatitude:[coord[@"lat"] doubleValue]
                                                     longitude:[coord[@"lng"] doubleValue]];
               }];
               [subscriber sendNext:RACTuplePack(waypoints, response[@"encoded"])];
               [subscriber sendCompleted];
               
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               [subscriber sendError:error];
            }];
        }];
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

+ (RACSignal *)venuesAlongPolyline:(NSString *)encoded
                      inCategories:(NSArray *)categories
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *params = @{@"category": categories[0],
                                 @"polyline": encoded};
        
        AFHTTPRequestOperation *op = [[self apiManager] GET:@"venues" parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"resp: %@", responseObject);
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

@end
