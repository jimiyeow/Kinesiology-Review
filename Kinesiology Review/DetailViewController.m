//
//  DetailViewController.m
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController
@synthesize currentCard = _currentCard;
@synthesize largeView = _largeView;
@synthesize nextButton = _nextButton;
@synthesize previousButton = _previousButton;

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize activityTitle = _activityTitle;
@synthesize activitiesList = _activitiesList;
@synthesize description = _description;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize selectedActivities = _selectedActivities;
@synthesize selectedListTitle = _selectedListTitle;



//LOCAL VARIABLES

//List of previous activities, including current one
NSMutableArray *previousActivities;

//Holds previous list titles, including current one
NSMutableArray *previousListTitles;

//A limited list of previous activities, which should not be repeated yet
NSMutableArray *recentActivities;

//The center of the display area
CGPoint displayCenter;

//The center of the card after it's thrown off-screen
CGPoint leftCenter;

//The center of the card before it's thrown on-screen
CGPoint rightCenter;

//The amount of time for an animation to take
NSTimeInterval animationTime = .5;



#pragma mark - Managing the detail item

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_activitiesList.text = @"";
	previousActivities = [NSMutableArray new];
	recentActivities = [NSMutableArray new];
	previousListTitles = [NSMutableArray new];
	
	[self configureView];
}

- (void)viewDidUnload
{
	[self setActivityTitle:nil];
	[self setActivitiesList:nil];
	[self setDescription:nil];
	[self setPreviousButton:nil];
	[self setNextButton:nil];
    [self setCurrentCard:nil];
	[self setLargeView:nil];
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
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    self.masterPopoverController = nil;
}

//When user hits "Next!" button, load and display the next activity
- (IBAction)nextActivity:(UIBarButtonItem *)sender {
	
	if (displayCenter.y == 0) {
		displayCenter = _currentCard.center;
		leftCenter = CGPointMake(_largeView.bounds.origin.x - _currentCard.bounds.size.width, displayCenter.y);
		rightCenter = CGPointMake(_largeView.bounds.origin.x + _largeView.bounds.size.width + _currentCard.bounds.size.width, displayCenter.y);
	}
	
	if (_selectedActivities.count != 0) {
		
		//If only activity in the selected list is already showing, display an alert
		if (_selectedActivities.count == 1 && [_selectedListTitle isEqualToString:[previousListTitles lastObject]]) {
			UIAlertView *alert = [[UIAlertView new] initWithTitle:@"Dead end!" message:@"There's only one activity for this list and domain." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			
		} else {
			
			[UIView animateWithDuration:animationTime animations:^{
				_currentCard.center = leftCenter;
			} completion:^(BOOL finished){
				if (finished) {
					
					//The activity to be displayed
					Activity *nextActivity = [_selectedActivities objectAtIndex:(arc4random() % _selectedActivities.count)];
					
					//Make sure next activity hasn't been displayed recently
					while ([recentActivities containsObject:nextActivity] && _selectedActivities.count != 1) {
						nextActivity = [_selectedActivities objectAtIndex:(arc4random() % _selectedActivities.count)];
					}
					
					[previousActivities addObject:nextActivity];
					[previousListTitles addObject:_selectedListTitle];
					[self displayActivity:nextActivity];
					
					_currentCard.center = rightCenter;
					
					[UIView animateWithDuration:animationTime animations:^{
						_currentCard.center = displayCenter;
					}];
					
				}
			}];
		}
		
	} else {
		UIAlertView *alert = [[UIAlertView new] initWithTitle:@"Nothing there!" message:@"There aren't any activities of both the level and domain chosen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}

//Displays the passed in activity
- (void)displayActivity:(Activity *)activity
{	
	_activityTitle.text = activity.title;
	_activitiesList.text = [previousListTitles lastObject];
	_description.text = activity.description;
	
	//Add activity to end of list of recent activities (first removing it from earlier in the list
	[recentActivities removeObject:activity];
	[recentActivities addObject:activity];
	
	//Only show previous button if there are any previous activities
	if (previousActivities.count < 2) {
		[_previousButton setEnabled:NO];
	} else {
		[_previousButton setEnabled:YES];
	}
	
	//The max number of recent items to keep track of (for avoiding repetition)
	NSInteger maxRecentItems = 10;
	
	if (_selectedActivities.count * 3 / 4 > maxRecentItems) {
		maxRecentItems = _selectedActivities.count * 3 / 4;
	}
	if (maxRecentItems >= _selectedActivities.count) {
		maxRecentItems = _selectedActivities.count - 1;
	}
	
	//Remove oldest activities from recent activities list if it's full
	if (recentActivities.count > maxRecentItems) {
		[recentActivities removeObjectAtIndex:0];
	}
}

//Displays the previous activity when button is pressed
- (IBAction)backToPrevious:(UIBarButtonItem *)sender {
	[previousActivities removeLastObject];
	[previousListTitles removeLastObject];
	
	[UIView animateWithDuration:animationTime animations:^{
		_currentCard.center = rightCenter;
	} completion:^(BOOL finished){
		if (finished) {
			[self displayActivity:[previousActivities lastObject]];
			
			_currentCard.center = leftCenter;
			
			[UIView animateWithDuration:animationTime animations:^{
				_currentCard.center = displayCenter;
			}];
		}
	}];
}
@end
