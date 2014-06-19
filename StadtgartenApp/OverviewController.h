//
//  OverviewController.h
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/18/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Database.h"

@interface OverviewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(IBAction)storeData:(id)sender;

-(IBAction)discardData:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property NSString *name;
@property NSString *description;
@property NSString *tags;
@property UIImage *image;

@end
