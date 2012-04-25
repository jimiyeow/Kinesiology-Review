//
//  Activity.h
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject <NSCoding> {
	NSString *title;
	NSString *description;
}

@property (strong) NSString *title;
@property (strong) NSString *description;

@end
