//
//  SetItemViewController.h
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/17/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGTree.h"

@interface SetItemViewController : UIViewController{


IBOutlet UITextField *nameTextField;
IBOutlet UITextView *descriptionTextArea;

}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, readwrite) SGTree *tree;

@property (nonatomic, strong) IBOutlet UIView *ddMenu;
@property (nonatomic, strong) IBOutlet UIButton *ddMenuShowButton;

@property (nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) IBOutlet UITextView *descriptionTextArea;


@property UIImage *image;

- (IBAction)shouldContinue:(id)sender;

- (IBAction)ddMenuShow:(UIButton *)sender;
- (IBAction)ddMenuSelectionMade:(UIButton *)sender;

-(void)dismissKeyboard;




@end
