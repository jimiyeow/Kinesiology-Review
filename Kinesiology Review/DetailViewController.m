//
//  DetailViewController.m
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import "DetailViewController.h"

#import "Activity.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize activityTitle = _activityTitle;
@synthesize activitiesList = _activitiesList;
@synthesize description = _description;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize selectedActivities, selectedListTitle;

#pragma mark - Managing the detail item

//The activity being displayed onscreen
Activity *displayedActivity;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
	
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
	
	if (self.detailItem) {
	    self.detailDescriptionLabel.text = [self.detailItem description];
	}
	
	//If there is a current activity, display it
	if (displayedActivity) {
		_activityTitle.text = displayedActivity.title;
		_activitiesList.text = selectedListTitle;
		_description.text = displayedActivity.description;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
}

- (void)viewDidUnload
{
	[self setActivityTitle:nil];
	[self setActivitiesList:nil];
	[self setDescription:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

//When user hits "Next!" button, load and display the next activity
- (IBAction)nextActivity:(UIBarButtonItem *)sender {
	if (selectedActivities != nil) {
		displayedActivity = [selectedActivities objectAtIndex:(arc4random() % selectedActivities.count)];
		[self configureView];
	} else {
		UIAlertView *alert = [[UIAlertView new] initWithTitle:@"Hold your horses!" message:@"First choose the level and domain of activities to see!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}

@end
