//
//  DetailViewController.h
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate> {
	NSMutableArray *selectedActivities;
	NSString *selectedListTitle;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityTitle;
@property (strong, nonatomic) IBOutlet UILabel *activitiesList;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property NSMutableArray *selectedActivities;
@property NSString *selectedListTitle;
- (IBAction)nextActivity:(UIBarButtonItem *)sender;

@end
