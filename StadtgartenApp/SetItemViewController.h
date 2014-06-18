//
//  SetItemViewController.h
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/17/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetItemViewController : UIViewController{


IBOutlet UITextField *nameTextField;
IBOutlet UITextView *descriptionTextArea;

}

@property (nonatomic, strong) IBOutlet UILabel *ddText;
@property (nonatomic, strong) IBOutlet UIView *ddMenu;
@property (nonatomic, strong) IBOutlet UIButton *ddMenuShowButton;

@property (nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) IBOutlet UITextView *descriptionTextArea;

@property UIImage *image;


- (IBAction)ddMenuShow:(UIButton *)sender;
- (IBAction)ddMenuSelectionMade:(UIButton *)sender;
- (IBAction)requireTextInput:(id)sender;

-(void)dismissKeyboard;




@end
