//
//  DetailViewController.h
//  Byway
//
//  Created by Joseph Constan on 9/29/12.
//  Copyright (c) 2012 Joseph Constan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMainViewController;

@interface BWVenueListViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *venueList;
@property (nonatomic) BWMainViewController *delegate;

@end
