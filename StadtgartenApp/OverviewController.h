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
#import "SGTree.h"

@interface OverviewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(IBAction)storeData:(id)sender;

-(IBAction)discardData:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (strong, readwrite) SGTree *tree;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property UIImage *image;

@end
