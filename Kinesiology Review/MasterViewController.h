//
//  MasterViewController.h
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSXMLParserDelegate> {
	NSMutableArray *selectedActivities;	//Pretty self-explanatory
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property NSMutableArray *selectedActivities;

@end
