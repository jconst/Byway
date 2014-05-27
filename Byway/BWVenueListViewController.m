//
//  DetailViewController.m
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import "BWVenueListViewController.h"
#import "BWVenue.h"
#import "BWMainViewController.h"
#import "BWPanelViewController.h"
#import "BWAppDelegate.h"

@implementation BWVenueListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:0.729 green:0.596 blue:0.0509 alpha:1.0]];
}

- (void)setVenueList:(NSMutableArray *)venueList
{
    _venueList = venueList;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.venueList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    BWVenue *venue = [self.venueList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", indexPath.row+1, [venue name]];
    cell.detailTextLabel.text = [venue category];
    
//    if (indexPath.row < delegate.mvc.mapHelper.pins.count) {
//        MKPointAnnotation *pin = [delegate.mvc.mapHelper.pins objectAtIndex:indexPath.row];
//        pin.title = cell.textLabel.text;
//        pin.subtitle = cell.detailTextLabel.text;
//    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"index path: %@", indexPath);
        
        [self.venueList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
//        [delegate.mapView removeAnnotation:[delegate.mvc.mapHelper.pins objectAtIndex:indexPath.row]];
//        [delegate.mvc.mapHelper.pins removeObjectAtIndex:indexPath.row];
//        NSLog(@"pins: %@", delegate.mvc.mapHelper.pins);
//        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MKPointAnnotation *pin = [delegate.mvc.mapHelper.pins objectAtIndex:indexPath.row];
//    
//    [[delegate.mapView viewForAnnotation:pin] setCanShowCallout:YES];
//    
//    [delegate.mapView selectAnnotation:pin animated:YES];
}

@end
