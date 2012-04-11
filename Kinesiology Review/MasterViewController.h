//
//  MasterViewController.h
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//  Copyright (c) 2012 Calling All Crows. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
