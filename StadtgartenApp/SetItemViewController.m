//
//  SetItemViewConntroller.m
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/3/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "SetItemViewController.h"
#import "OverviewController.h"

@interface SetItemViewController ()


@end

@implementation SetItemViewController


@synthesize descriptionTextArea;
@synthesize nameTextField;
@synthesize image;
@synthesize ddMenu, ddText;
@synthesize ddMenuShowButton;

// *newTree = [[StoreTreeData alloc] init];

-(IBAction)shouldContinue:(id)sender{
    if([nameTextField.text isEqualToString:@""] || [descriptionTextArea.text isEqualToString: @""] || [ddText.text isEqualToString:@" Baum wählen"] ){
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler"
                                                       message:@"Bitte fuellen Sie das Formular vollständig aus"
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
    overviewController.name = nameTextField.text;
    overviewController.description = descriptionTextArea.text;
    overviewController.tags = ddText.text;
    overviewController.image = image;
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
        [sender setTitle:@"▲" forState:UIControlStateNormal];
    } else {
        sender.tag = 0;
        self.ddMenu.hidden = YES;
        [sender setTitle:@"▼" forState:UIControlStateNormal];
    }
}
- (IBAction)ddMenuSelectionMade:(UIButton *)sender
{
    self.ddText.text = sender.titleLabel.text;
    [self.ddMenuShowButton setTitle:@"▼" forState:UIControlStateNormal];
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
