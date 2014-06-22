//
//  SetItemViewConntroller.m
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/3/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "SetItemViewController.h"
#import "OverviewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SGTree.h"

@interface SetItemViewController ()


@end

@implementation SetItemViewController


@synthesize descriptionTextArea;
@synthesize nameTextField;
@synthesize image;
@synthesize ddMenu;
@synthesize ddMenuShowButton;
@synthesize imageView;

// *newTree = [[StoreTreeData alloc] init];

-(IBAction)shouldContinue:(id)sender{
    if([nameTextField.text isEqualToString:@""] || [descriptionTextArea.text isEqualToString: @""] || [ddMenuShowButton.titleLabel.text isEqualToString:@"Baumart wählen"] ){
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler"
                                                       message:@"Bitte füllen Sie das Formular vollständig aus"
                                                      delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
       [alert show];
    }else{
            [self performSegueWithIdentifier:@"showOverview" sender:self];
        }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   if([segue.identifier isEqualToString:@"showOverview"]){
       OverviewController *overviewController = (OverviewController *)segue.destinationViewController ;
    //overviewController.name = nameTextField.text;
    //overviewController.description = descriptionTextArea.text;
    //overviewController.tags = ddMenuShowButton.titleLabel.text;
    //overviewController.image = image;
       
    overviewController.image = self.tree.picture;
    
    
    self.tree.name = nameTextField.text;
    self.tree.description = descriptionTextArea.text;
    self.tree.tag = ddMenuShowButton.titleLabel.text;
    overviewController.tree = self.tree;

    }

}

// remove keyboard in TextField when done button is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

// remove keyboard in TextView when done button is pressed
- (BOOL) textView: (UITextView*) textView
shouldChangeTextInRange: (NSRange) range
  replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

// remove keyboard if its klicked outside the textfield or textarea
-(void)dismissKeyboard {
    if(nameTextField){
        [nameTextField resignFirstResponder];
    }
    if(descriptionTextArea){
        [descriptionTextArea resignFirstResponder];
        
    }
}


// Drop Down List for selecting Tags


- (IBAction)ddMenuShow:(UIButton *)sender
{
    if (sender.tag == 0) {
        sender.tag = 1;
        self.ddMenu.hidden = NO;
        [sender setTitle:@"Baumart wählen" forState:UIControlStateNormal];
    } else {
        sender.tag = 0;
        self.ddMenu.hidden = YES;
        [sender setTitle:@"Baumart wählen" forState:UIControlStateNormal];
    }
}
- (IBAction)ddMenuSelectionMade:(UIButton *)sender
{
    [self.ddMenuShowButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    //[self.ddMenuShowButton setTitle:@"▼" forState:UIControlStateNormal];
    self.ddMenuShowButton.tag = 0;
    self.ddMenu.hidden = YES;
    //switch (sender.tag) {
    //    case 1:
            //self.view.backgroundColor = [UIColor redColor];
     //       break;
     //   case 2:
            //self.view.backgroundColor = [UIColor blueColor];
     //       break;
     //   case 3:
            //self.view.backgroundColor = [UIColor greenColor];
      //      break;
            
     //   default:
     //       break;
    //}
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // set nameTextField to self to remove keyboard when done button is pressed
    imageView.image = image;
    UIColor * borderColor = [UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:235.0/235.0 alpha:1];
    
    self.ddMenuShowButton.clipsToBounds = YES;
    self.ddMenuShowButton.layer.cornerRadius = 4.0f;
    self.ddMenuShowButton.layer.borderWidth = 1.0f;
    self.ddMenuShowButton.layer.borderColor = borderColor.CGColor;
    
    self.descriptionTextArea.clipsToBounds = YES;
    self.descriptionTextArea.layer.cornerRadius = 4.0f;
    self.descriptionTextArea.layer.borderWidth = 1.0f;
    self.descriptionTextArea.layer.borderColor = borderColor.CGColor;
    
    self.ddMenu.clipsToBounds = YES;
    self.ddMenu.layer.cornerRadius = 4.0f;
    self.ddMenu.layer.borderWidth = 1.0f;
    self.ddMenu.layer.borderColor = borderColor.CGColor;
    
    self.nameTextField.delegate = self;
    
    // set descriptionArea to self to remove keyboard when done button is pressed
    self.descriptionTextArea.delegate = self;
    
    // remove keyboard when user touches outside the textfield
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height , 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.descriptionTextArea.frame.origin) ) {
        [self.scrollView scrollRectToVisible:   self.descriptionTextArea.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(70, 0.0, 0.0, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    _scrollView.scrollsToTop = YES;
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
