//
//  MasterViewController.m
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "Activity.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController, selectedActivities;

NSMutableArray *activitiesLists;	//Array of arrays of activities
NSMutableArray *domainTitles;	//Names of each domain
NSInteger level, domain;	//Indexes of selections in each section
NSInteger const levels = 0;	//For better readability below

- (void)awakeFromNib
{
	self.clearsSelectionOnViewWillAppear = NO;
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	self.navigationItem.rightBarButtonItem = addButton;
	self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	
	domainTitles = [NSMutableArray new];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/2037194/sample-input.xml"]];
	[parser setDelegate:self];
	[parser parse];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == levels) {
		return activitiesLists.count;
	} else {
		return ((NSMutableArray *)[activitiesLists objectAtIndex:0]).count;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == levels) {
		return @"Select Level";
	} else {
		return @"Select Domain";
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	if (indexPath.section == levels) {
		cell.textLabel.text = [NSString stringWithFormat:@"Level %d", indexPath.row + 1];
    } else {
		cell.textLabel.text = [domainTitles objectAtIndex:indexPath.row];
	}
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == levels) {
		level = indexPath.row;
	} else {
		domain = indexPath.row;
	}
	
	selectedActivities = [[activitiesLists objectAtIndex:level] objectAtIndex:domain];
	
	for (NSInteger i = 0; i < [tableView numberOfRowsInSection:indexPath.section]; i++) {
		if (i != indexPath.row) {
			NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
			[tableView deselectRowAtIndexPath:otherIndexPath animated:NO];
		}
	}
}



//XML Parsing

Activity *currentActivity;	//The activity being added
NSMutableString *currentValue;	//The value of the current element being read
NSMutableArray *currentActivityLevels;	//The levels that the activity will be added to.  This is an array rather than just a number in case it will be added to multiple levels.

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"activities"]) {
		activitiesLists = [NSMutableArray new];
	} else if ([elementName isEqualToString:@"activity"]) {
		currentActivity = [Activity new];
	}
	
	currentValue = [NSMutableString new];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [currentValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if ([elementName isEqualToString:@"activity"]) {
		currentActivity = nil;
		currentActivityLevels = nil;
	} else if ([elementName isEqualToString:@"title"]) {
		currentActivity.title = currentValue;
	} else if ([elementName isEqualToString:@"description"]) {
		currentActivity.description = currentValue;
	} else if ([elementName isEqualToString:@"level"]) {
		NSInteger levelValue = currentValue.integerValue;
		
		//Make sure to add levels to array if it's not big enough already
		while (activitiesLists.count < levelValue) {
			//Array for new level to be added
			NSMutableArray *newLevel = [NSMutableArray new];
			
			//Fill array with arrays for each domain so far
			for (NSInteger i = 0; i < domainTitles.count; i++) {
				[newLevel addObject:[NSMutableArray new]];
			}
			
			[activitiesLists addObject:newLevel];
		}
		
		//And add the level to the list of levels the activity will belong to
		[currentActivityLevels addObject:[NSNumber numberWithInteger:levelValue]];
	} else if ([elementName isEqualToString:@"domain"]) {
		Boolean newDomain = YES;
		NSInteger domainIndex;
		
		//Check if domain is already in list
		for (NSInteger i = 0; i < domainTitles.count; i++) {
			
			//This shouldn't be necessary, but it seems that retrieving stored domain titles adds newline characters, so this needs to be trimmed before being compared
			NSString *trimmedTitle = [[domainTitles objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			if ([trimmedTitle isEqualToString:currentValue]) {
				newDomain = NO;
				domainIndex = i;
				break;
			}
		}
		
		//If it's not, add it
		if (newDomain) {
			domainIndex = domainTitles.count;
			[domainTitles addObject:currentValue];
			
			//And add it to each level
			for (NSInteger i = 0; i < activitiesLists.count; i++) {
				[[activitiesLists objectAtIndex:i] addObject:[NSMutableArray new]];
			}
		}
		
		//Then add activity into the lists, as long as it's not already there
		for (NSInteger i = 0; i < currentActivityLevels.count; i++) {
			
			NSInteger activityLevel = [(NSNumber *)[currentActivityLevels objectAtIndex:i] integerValue];
			
			NSMutableArray *domainActivities = [[activitiesLists objectAtIndex:activityLevel] objectAtIndex:domainIndex];
			
			if (![domainActivities containsObject:currentActivity]) {
				[domainActivities addObject:currentActivity];
			}
		}
	}
}

@end
