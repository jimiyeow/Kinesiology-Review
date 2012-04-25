//
//  DetailViewController.h
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import <UIKit/UIKit.h>

#import "Activity.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate> {
	NSMutableArray *selectedActivities;
	NSString *selectedListTitle;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) IBOutlet UILabel *activityTitle;	//Displays the title of the current activity

@property (strong, nonatomic) IBOutlet UILabel *activitiesList;	//Displays which list the current activity is from

@property (strong, nonatomic) IBOutlet UITextView *description;	//Displays the description of the current activity

@property (strong) NSMutableArray *selectedActivities;	//Holds the selected list of activities

@property (strong) NSString *selectedListTitle;	//Holds the title of the selected list of activities

@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;	//The next button

@property (strong, nonatomic) IBOutlet UIBarButtonItem *previousButton;	//The previous button

- (IBAction)nextActivity:(UIBarButtonItem *)sender;	//Called when user pushes "Next!" button

- (IBAction)backToPrevious:(UIBarButtonItem *)sender;	//Goes back to previous activity

- (void)displayActivity:(Activity *)activity;	//Displays activity


@end
