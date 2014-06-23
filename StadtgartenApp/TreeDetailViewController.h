//
//  TreeDetailViewController.h
//  StadtgartenApp
//
//  Created by Tobias Keinath on 17.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "SGTree.h"


@interface TreeDetailViewController : UIViewController <UIActionSheetDelegate, RateViewDelegate,UIAlertViewDelegate>

- (IBAction)tapEdit:(id)sender;
- (IBAction)doneEditing:(id)sender;

- (IBAction)bookmarkTree:(id)sender;

- (IBAction)showRatingActionSheet:(id)sender;
- (void) connectWithFacebook;


@property (weak, nonatomic) IBOutlet RateView *rateView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *raterCount;

@property (strong, nonatomic) IBOutlet SGTree *treeObject;
@property (strong, nonatomic) IBOutlet UITextField *treeName;
@property (strong, nonatomic) IBOutlet UITextField *treeTag;
@property (strong, nonatomic) IBOutlet UILabel *treeDistance;
@property (strong, nonatomic) IBOutlet UIView *locationBGView;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *treePicture;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;



@end
