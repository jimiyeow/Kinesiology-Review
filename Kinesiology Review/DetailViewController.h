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

@property (strong, nonatomic) IBOutlet UILabel *activityTitle;	//Displays the title of the current activity

@property (strong, nonatomic) IBOutlet UILabel *activitiesList;	//Displays which list the current activity is from

@property (strong, nonatomic) IBOutlet UITextView *description;	//Displays the description of the current activity

@property NSMutableArray *selectedActivities;	//Holds the selected list of activities

@property NSString *selectedListTitle;	//Holds the title of the selected list of activities

- (IBAction)nextActivity:(UIBarButtonItem *)sender;	//Called when user pushes "Next!" button

@end
