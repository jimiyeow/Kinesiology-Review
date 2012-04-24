//
//  MasterViewController.h
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSXMLParserDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) IBOutlet UILabel *selectInstructions;	//The label above the table view

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *refreshingIndicator;	//Refreshing animation

- (IBAction)refresh:(UIBarButtonItem *)sender;	//Refresh button

- (BOOL)refreshActivities;

@end
