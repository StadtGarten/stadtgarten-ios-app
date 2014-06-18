//
//  TreeDetailViewController.h
//  StadtgartenApp
//
//  Created by Tobias Keinath on 17.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeDetailViewController : UIViewController

- (IBAction)tapEdit:(id)sender;
- (IBAction)doneEditing:(id)sender;


@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;


@end
