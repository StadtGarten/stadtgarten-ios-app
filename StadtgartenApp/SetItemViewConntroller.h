//
//  SetItemViewConntroller.h
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/3/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetItemViewConntroller : UIViewController{
    
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextView *descriptionTextArea;
    
}

@property (nonatomic, strong) IBOutlet UILabel *ddText;
@property (nonatomic, strong) IBOutlet UIView *ddMenu;
@property (nonatomic, strong) IBOutlet UIButton *ddMenuShowButton;

@property (nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) IBOutlet UITextView *descriptionTextArea;



- (IBAction)ddMenuShow:(UIButton *)sender;
- (IBAction)ddMenuSelectionMade:(UIButton *)sender;

- (IBAction)ddTextFieldClicked:(id)sender;
- (IBAction)ddTextViewClicked:(id)sender;

-(void)dismissKeyboard;
-(IBAction) requireTextInput:(id)sender;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;





@end

