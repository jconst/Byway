//
//  APIManager.m
//  Byway
//
//  Created by Joseph Constantakis on 1/27/14.
//  Copyright (c) 2014 Joseph Constan. All rights reserved.
//

#import "BWAPIManager.h"

#define kAPIBaseURL @"http://localhost:5000"

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

@end
