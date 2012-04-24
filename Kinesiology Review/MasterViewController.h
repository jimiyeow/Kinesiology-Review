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
- (IBAction)refresh:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UILabel *selectInstructions;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *refreshingIndicator;

@end
