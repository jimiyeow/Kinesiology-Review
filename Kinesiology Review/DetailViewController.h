//
//  DetailViewController.h
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//  Copyright (c) 2012 Calling All Crows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
