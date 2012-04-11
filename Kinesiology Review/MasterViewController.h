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

@end
