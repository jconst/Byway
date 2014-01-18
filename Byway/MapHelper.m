//
//  MapHelper.m
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import "MapHelper.h"
#import "InitialViewController.h"
#import "AppDelegate.h"
#import "Venue.h"
#import "SBJson.h"

@implementation MapHelper

@synthesize pins;

- (id)init {
    if ((self = [super init])) {
        mapView = [(InitialViewController *)[[APPDELEGATE window] rootViewController] mapView];
        pins = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)waypointsFromEncodedString:(NSString *)encodedPolyline {
    
    NSUInteger length = [encodedPolyline length];
    NSInteger index = 0;
    NSMutableArray *points = [NSMutableArray array];
    CGFloat lat = 0.0f;
    CGFloat lng = 0.0f;
    
    while (index < length) {
        
        // Temorary variable to hold each ASCII byte.
        int b = 0;
        
        // The encoded polyline consists of a latitude value followed by a
        // longitude value. They should always come in pair. Read the
        // latitude value first.
        int shift = 0;
        int result = 0;
        
        do {
            
            // If index exceded lenght of encoding, finish 'chunk'
            if (index >= length) {
                
                b = 0;
                
            } else {
                
                // The '[encodedPolyline characterAtIndex:index++]' statement resturns the ASCII
                // code for the characted at index. Subtract 63 to get the original
                // value. (63 was added to ensure proper ASCII characters are displayed
                // in the encoded plyline string, wich id 'human' readable)
                b = [encodedPolyline characterAtIndex:index++] - 63;
            }
            
            // AND the bits of the byte with 0x1f to get the original 5-bit 'chunk'.
            // Then left shift the bits by the required amount, wich increases
            // by 5 bits each time.
            // OR the value into results, wich sums up the individual 5-bit chunks
            // into the original value. Since the 5-bit chunks were reserved in
            // order during encoding, reading them in this way ensures proper
            // summation.
            result |= (b & 0x1f) << shift;
            shift += 5;
            
        } while (b >= 0x20); // Continue while the read byte is >= 0x20 since the last 'chunk'
        // was nor OR'd with 0x20 during the conversion process. (Signals the end).
        
        // check if negative, and convert. (All negative values have the last bit set)
        CGFloat dlat = (result & 1) ? ~(result >> 1) : (result >> 1);
        
        //Compute actual latitude since value is offset from previous value.
        lat += dlat;
        
        // The next value will correspond to the longitude for this point.
        shift = 0;
        result = 0;
        
        do {
            
            // If index exceded lenght of encoding, finish 'chunk'
            if (index >= length) {
                
                b = 0;
                
            } else {
                
                b = [encodedPolyline characterAtIndex:index++] - 63;
                
            }
            result |= (b & 0x1f) << shift;
            shift += 5;
            
        } while (b >= 0x20);
        
        CGFloat dlng = (result & 1) ? ~(result >> 1) : (result >> 1);
        lng += dlng;
        
        // The actual latitude and longitude values were multiplied by
        // 1e5 before encoding so that they could be converted to a 32-bit
        //integer representation. (With a decimal accuracy of 5 places)
        // Convert back to original value.
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:(lat * 1e-5) longitude:(lng * 1e-5)];
        
        [points addObject:loc];
    }
    
    return points;
    
}

- (void)requestDirectionsFrom:(MKPlacemark *)src to:(MKPlacemark *)dest withWaypoints:(NSArray *)wpList withCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    
    NSError *error;
    
    if (wpList.count <= 0) {
        [self requestDirectionsFrom:src to:dest withCompletionHandler:completionHandler];
        return;
    }
    
    Venue *start = [wpList objectAtIndex:0];
    NSMutableString *wpString = [NSMutableString stringWithFormat:@"%f,%f",
                                 start.location.coordinate.latitude,
                                 start.location.coordinate.longitude];
    
    for (int i = 1; i < wpList.count; i++) {
        Venue *venue = [wpList objectAtIndex:i];
        [wpString appendFormat:@"|%f,%f", venue.location.coordinate.latitude, venue.location.coordinate.longitude];
    }
    
    //Find Route
    
    NSString *url = [[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&waypoints=optimize:true|%@&sensor=false",
                     src.location.coordinate.latitude,
                     src.location.coordinate.longitude,
                     dest.location.coordinate.latitude,
                     dest.location.coordinate.longitude,
                     wpString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url: %@", url);
    
    NSMutableString *routeString = [NSMutableString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dict = [parser objectWithString:routeString];
    
    routeString.string = [[[[dict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"overview_polyline"] objectForKey:@"points"];
    
    NSArray *waypts = [self waypointsFromEncodedString:routeString];
        
    completionHandler(waypts, error);
}

- (void)requestDirectionsFrom:(MKPlacemark *)src to:(MKPlacemark *)dest withCompletionHandler:(void (^)(NSArray *waypts, NSError *error))completionHandler {
    
    NSError *error;
    
    //Find Route
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false",
                     src.location.coordinate.latitude,
                     src.location.coordinate.longitude,
                     dest.location.coordinate.latitude,
                     dest.location.coordinate.longitude];

    NSLog(@"url: %@", url);
    
    NSMutableString *routeString = [NSMutableString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dict = [parser objectWithString:routeString];
    
    routeString.string = [[[[dict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"overview_polyline"] objectForKey:@"points"];
    
    NSArray *waypts = [self waypointsFromEncodedString:routeString];
        
    completionHandler(waypts, error);
}

- (void)dropPinOnLocation:(CLLocation *)location {
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = location.coordinate;
    [mapView addAnnotation:annot];
    [pins addObject:annot];
}

@end
