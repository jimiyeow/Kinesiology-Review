//
//  Activity.m
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import "Activity.h"

@implementation Activity

@synthesize title = _title;
@synthesize description = _description;


//These methods were added for use in storing activities lists.  They're part of the NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_title forKey:@"title"];
	[aCoder encodeObject:_description forKey:@"description"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	_title = [aDecoder decodeObjectForKey:@"title"];
	_description = [aDecoder decodeObjectForKey:@"description"];
	return self;
}

@end
