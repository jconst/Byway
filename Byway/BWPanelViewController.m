//
//  MasterViewController.m
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import "BWPanelViewController.h"
#import "BWVenueListViewController.h"
#import "BWMainViewController.h"
#import "BWAppDelegate.h"
#import "BWAPIManager.h"
#import "BWDataStore.h"
#import "BWVenue.h"

@interface BWPanelViewController ()
{
    NSArray *waypoints;
    NSMutableArray *venues;
    NSMutableDictionary *venuesDict;
    
    NSString *category;
}
@property (assign, nonatomic) BWMainViewController *mainViewController;

@property (strong, nonatomic) IBOutlet UITextField *startField;
@property (strong, nonatomic) IBOutlet UITextField *endField;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation BWPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mainViewController = (BWMainViewController *)[[APPDELEGATE window] rootViewController];
    venues = [NSMutableArray array];
    category = @"topPicks";
}

- (IBAction)showCategories:(id)sender
{
    self.picker.hidden = NO;

    [UIView animateWithDuration:0.3 animations:^{
        self.picker.alpha = 1;
    }];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    static NSArray *categories = nil;
    if (!categories)
        categories = @[@"food", @"drinks", @"coffee", @"shops", @"arts", @"outdoors",
                       @"sights", @"trending", @"specials", @"top picks"];
    
    return categories[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    category = [self pickerView:pickerView titleForRow:row forComponent:0];
    
    if ([category isEqualToString:@"top picks"]) {
        category = @"topPicks";
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.picker.alpha = 0;
    } completion:^(BOOL finished) {
        self.picker.hidden = YES;
    }];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (IBAction) thumbButtonDragged:(id)sender withEvent:(UIEvent *) event
{
    CGPoint oldPoint = [[[event allTouches] anyObject] previousLocationInView:self.view];
    CGPoint newPoint = [[[event allTouches] anyObject] locationInView:self.view];
    
    //if (!CGRectContainsPoint(sender.frame, newPoint))
    //    return;
    
    float dist = newPoint.y - oldPoint.y;
    
    [self.mainViewController movePanelViewByDistance:dist];
}

- (IBAction) thumbButtonReleased:(id) sender withEvent:(UIEvent *) event
{
    [self.mainViewController didUntouchPanelViewThumbButton];
}
   
- (IBAction)touchedAnywhere
{
    [self hideKeyboard];
}

- (IBAction)hideKeyboard
{
    for (UIView *subview in [self.view subviews]) {
        [subview resignFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!textField.text.length)
        return;
        
    [venues removeAllObjects];
    
    [[BWAPIManager apiManager] geocodeSearchString:textField.text
    completion:^(CLLocation *loc, NSString *address, NSError *error) {
        
        textField.text = address;
        if (textField == self.startField)
            DATASTORE.startLoc = loc;
        else
            DATASTORE.endLoc = loc;
    }];
}

//- (void)routeBywayWithVenues:(NSArray *)venueList
//{
//    if (venueList) {
//        [self.mainViewController.mapView removeAnnotations:self.mainViewController.mapView.annotations];
//        [mapHelper.pins removeAllObjects];
//        [mapHelper dropPinOnLocation:startLoc.location];
//        for (int i = 0; i < venueList.count; i++) {
//            BWVenue *venue = [venueList objectAtIndex:i];
//            CLLocation *location = venue.location;
//            [mapHelper dropPinOnLocation:location];
//        }
//        [mapHelper dropPinOnLocation:endLoc.location];
//        
//        [mapHelper requestDirectionsFrom:startLoc to:endLoc withWaypoints:venues withCompletionHandler:^(NSArray *waypts, NSError *error) {
//            
//            NSLog(@"waypts: %@", waypts);
//            
//            if (error)
//                [APPDELEGATE showError:error];
//            else {
//                waypoints = waypts;
//                
//                [self.mainViewController drawRouteWithWaypoints:waypts];
//            }
//        }];
//    }
//}

- (IBAction)didTapGo:(id)sender
{
    [self hideKeyboard];

    [self.mainViewController hidePanelView:YES];
//    if (!startLoc) {
//        [self textFieldDidEndEditing:(UITextField *)[self.view viewWithTag:1]];
//    }
//    if (!endLoc) {
//        [self textFieldDidEndEditing:(UITextField *)[self.view viewWithTag:2]];
//    }
//    
//    if (!startLoc || !endLoc) {
//        return;
//    }
//    
//     
//    if (venues.count <= 0) {
//        [self routeMain];
//        [self findFoursquareVenues];
//    }
//    [self trimToBestVenues];
//    
//    //Build venue list
//    BWVenue *start = [[BWVenue alloc] init];
//    start.name = [(UITextField *)[self.view viewWithTag:1] text];
//    start.category = @"";
//    start.location = startLoc.location;
//    start.index = 0;
//    
//    NSMutableArray *venueList = [NSMutableArray arrayWithObject:start];
//    [venueList addObjectsFromArray:venues];
//    
//    BWVenue *end = [[BWVenue alloc] init];
//    end.name = [(UITextField *)[self.view viewWithTag:2] text];
//    end.category = @"";
//    end.location = endLoc.location;
//    end.index = venuesDict.count + 2;
//    
//    [venueList addObject:end];
//    
//    [self.mainViewController loadVenueList:venueList];
//    
//    NSLog(@"venues second count: %d", venues.count);
//    [self routeBywayWithVenues:venues];
}

//- (void)findFoursquareVenues {
//    
//    if (!waypoints || [geocoder isGeocoding])
//        [self performSelector:@selector(findFoursquareVenues) withObject:nil afterDelay:1.0];
//    
//    venuesDict = [NSMutableDictionary dictionary];
//    
//    //double limit = pow(((double) waypoints.count), 2/3);
//    
//    int counter = 1;
//    for (CLLocation *loc in waypoints) {
//        counter--;
//        if (counter > 0)
//            continue;
//        counter = 10;
//        
//        NSError *error;
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&oauth_token=WYGMHZUP0XT0YBVTQW5N30UHQX1W433RXDEYOLYODPPNTL41&v=20120930&count=4&section=%@", loc.coordinate.latitude, loc.coordinate.longitude, category]];
//        NSString *JSONstring = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
//        if (error) {
//            [APPDELEGATE showError:error];
//        } else {
//            
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[JSONstring dataUsingEncoding:NSUTF8StringEncoding]
//                                                                 options:0
//                                                                   error:nil];
//            maxDistance = 0;
//            maxLikes = 0;
//            NSUInteger index = 1;
//            
//            for (NSDictionary *group in [[dict objectForKey:@"response"] objectForKey:@"groups"]) {
//                for (NSDictionary *item in [group objectForKey:@"items"]) {
//                    
//                    NSDictionary *venueDict = [item objectForKey:@"venue"];
//                    NSLog(@"venueDict: %@", venueDict);
//                    //determine properties
//                    NSInteger distance = 0;
//                    NSString *name = @"NAME";
//                    NSString *cat = @"CATEGORY";
//                    double value = 0.1;
//                    int likes = 0;
//                    CLLocationDegrees latitude;
//                    CLLocationDegrees longitude;
//
//                    distance = [(NSString *)[[venueDict objectForKey:@"location"] objectForKey:@"distance"] integerValue];
//                    name = [venueDict objectForKey:@"name"];
//                    latitude = [(NSString *)[[venueDict objectForKey:@"location"] objectForKey:@"lat"] floatValue];
//                    longitude = [(NSString *)[[venueDict objectForKey:@"location"] objectForKey:@"lng"] floatValue];
//                    cat = [[[venueDict objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"name"];
//                    likes = [[[venueDict objectForKey:@"likes"] objectForKey:@"count"] integerValue];
//                    
//                    if (distance > maxDistance) {
//                        maxDistance = distance;
//                    }
//                    
//                    if (likes > maxLikes)
//                        maxLikes = likes;
//                    
//                    //set properties
//                    BWVenue *venue = [[BWVenue alloc] init];
//                    venue.minDistance = distance;
//                    venue.name = name;
//                    venue.value = value;
//                    venue.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//                    venue.category = cat;
//                    venue.index = index;
//                    index++;
//                    
//                    //save venue in dictionary
//                    if (![venuesDict objectForKey:venue.name]) {
//                        [venuesDict setObject:venue forKey:venue.name];
//                    } else {
//                        venue = [venuesDict objectForKey:venue.name];
//                        if (distance < venue.minDistance) {
//                            venue.minDistance = distance;
//                            [venuesDict setObject:venue forKey:venue.name];
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//- (void)trimToBestVenues {
//    
//    [venues removeAllObjects];
//    
//    for (NSString *key in venuesDict) {
//        BWVenue *venue = [venuesDict objectForKey:key];
//        
//        double dist = (double)venue.minDistance / (double)maxDistance;
//        
//        if (venue.likes > 0 && maxLikes > 0) {
//            venue.value = (double)venue.likes / (double)maxLikes;
//        }
//        
//        venue.value /= dist;
//        
//        [venues addObject:venue];
//    }
//    
//    NSLog(@"venue count: %d", venues.count);
//    NSInteger idealCount = slider.value*8;
//    if (venues.count > idealCount) {
//        [venues sortUsingComparator:^NSComparisonResult(BWVenue *obj1, BWVenue *obj2) {
//            if ([obj1 value] < [obj2 value]) {
//                return (NSComparisonResult)NSOrderedDescending;
//            }
//            
//            if ([obj1 value] > [obj2 value]) {
//                return (NSComparisonResult)NSOrderedAscending;
//            }
//            return (NSComparisonResult)NSOrderedSame;
//        }];
//        
//        [venues removeObjectsInRange:NSMakeRange(idealCount, venues.count-idealCount)];
//    }
//    
//    [venues sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        if ([obj1 index] > [obj2 index]) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }
//        
//        if ([obj1 index] < [obj2 index]) {
//            return (NSComparisonResult)NSOrderedAscending;
//        }
//        return (NSComparisonResult)NSOrderedSame;
//    }];
//}

@end
