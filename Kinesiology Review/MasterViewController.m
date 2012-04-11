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

@synthesize detailViewController = _detailViewController;

NSMutableArray *activitiesLists;	//Array of arrays of activities (first dimension is level, second is domain)
NSMutableArray *domainTitles;	//Names of each domain
NSInteger level = -1, domain = -1;	//Indexes of selections in each section
NSInteger const levels = 0;	//Just for better readability below

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
	self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	
	//Load the activities list from the external XML file
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/2037194/sample-input.xml"]];
	domainTitles = [NSMutableArray new];
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

//2 sections, one for level, and one for domain
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

//Method is called when user selects one of the options
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Take note of which option was chosen
	if (indexPath.section == levels) {
		level = indexPath.row;
	} else {
		domain = indexPath.row;
	}
	
	//If both options have been chosen, update selected activities variable and list title
	if (level != -1 && domain != -1) {
		_detailViewController.selectedActivities = [[activitiesLists objectAtIndex:level] objectAtIndex:domain];
		_detailViewController.selectedListTitle = [NSString stringWithFormat:@"Level %d — %@", level + 1, [domainTitles objectAtIndex:domain]];
	}
	
	//And deselect other options in the section
	for (NSInteger i = 0; i < [tableView numberOfRowsInSection:indexPath.section]; i++) {
		if (i != indexPath.row) {
			NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
			[tableView deselectRowAtIndexPath:otherIndexPath animated:NO];
		}
	}
}



//XML Parsing

Activity *currentActivity;	//The activity being added
NSMutableString *currentString;	//The value of the current element being read

//The levels and domains that the activity will be added to.  These are arrays rather than just numbers in case it will be added to multiple levels and domains.
NSMutableArray *currentActivityLevels, *currentDomains;

//Method called when starting to read XML element
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"activities"]) {
		//Initialize activities lists
		activitiesLists = [NSMutableArray new];
	} else if ([elementName isEqualToString:@"activity"]) {
		//Create new activity and reset variable for which levels and domains it will go to
		currentActivity = [Activity new];
		currentActivityLevels = [NSMutableArray new];
		currentDomains = [NSMutableArray new];
	}
	
	//Restart the current string
	currentString = [NSMutableString new];
}

//Keep track of the value of the current XML element being read
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [currentString appendString:string];
}

//Method called when finishing reading an XML element
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if ([elementName isEqualToString:@"activity"]) {
		//Add activity to appropriate lists
		
		//This doesn't seem like it should be necessary, but retrieving titles from arrays keeps adding whitespace, so this object is used to trim them for accurate comparison
		NSCharacterSet *trimCharacters = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		
		for (NSInteger currentDomainIndex = 0; currentDomainIndex < currentDomains.count; currentDomainIndex++) {
			NSString *currentDomainTitle = [[currentDomains objectAtIndex:currentDomainIndex] stringByTrimmingCharactersInSet:trimCharacters];
			
			Boolean newDomain = YES;	//Whether the domain is new or already in the lists
			NSInteger domainIndex;	//The index in the activity lists of the domain
			
			//Check if domain is already in list
			for (NSInteger comparedDomainIndex = 0; comparedDomainIndex < domainTitles.count; comparedDomainIndex++) {
				NSString *comparedTitle = [[domainTitles objectAtIndex:comparedDomainIndex] stringByTrimmingCharactersInSet:trimCharacters];
				
				if ([comparedTitle isEqualToString:currentDomainTitle]) {
					newDomain = NO;
					domainIndex = comparedDomainIndex;
					break;
				}
			}
			
			//If it's not, add it
			if (newDomain) {
				domainIndex = domainTitles.count;
				[domainTitles addObject:currentDomainTitle];
				
				//And add it to each level
				for (NSInteger levelIndex = 0; levelIndex < activitiesLists.count; levelIndex++) {
					[[activitiesLists objectAtIndex:levelIndex] addObject:[NSMutableArray new]];
				}
			}
			
			//Then add activity into the lists, as long as it's not already there
			for (NSInteger i = 0; i < currentActivityLevels.count; i++) {
				
				//Level activity will be added to
				NSInteger activityLevel = [(NSNumber *)[currentActivityLevels objectAtIndex:i] integerValue];
				
				//Activities list activity will be added to
				NSMutableArray *domainActivities = [[activitiesLists objectAtIndex:activityLevel - 1] objectAtIndex:domainIndex];
				
				//Make sure it's not already in list, and then add it
				if (![domainActivities containsObject:currentActivity]) {
					[domainActivities addObject:currentActivity];
				}
			}
		}
	} else if ([elementName isEqualToString:@"title"]) {
		currentActivity.title = currentString;
	} else if ([elementName isEqualToString:@"description"]) {
		currentActivity.description = currentString;
	} else if ([elementName isEqualToString:@"level"]) {
		NSInteger levelValue = currentString.integerValue;
		
		//Make sure to add levels to array if it's not big enough already
		while (activitiesLists.count < levelValue) {
			//Array for new level to be added
			NSMutableArray *newLevel = [NSMutableArray new];
			
			//Fill levl array with arrays for each domain so far
			for (NSInteger i = 0; i < domainTitles.count; i++) {
				[newLevel addObject:[NSMutableArray new]];
			}
			
			[activitiesLists addObject:newLevel];
		}
		
		//And add the level to the list of levels the activity will belong to
		[currentActivityLevels addObject:[NSNumber numberWithInteger:levelValue]];
	} else if ([elementName isEqualToString:@"domain"]) {
		[currentDomains addObject:currentString];
	}
}

@end
