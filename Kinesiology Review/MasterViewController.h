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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *insertURL; //insert the URL

- (IBAction)refresh:(UIBarButtonItem *)sender;	//Refresh button

- (IBAction)insertURL:(UIBarButtonItem *)sender; //inserts URL

- (BOOL)refreshActivities;

@end
