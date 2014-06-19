//
//  TreeDetailViewController.m
//  StadtgartenApp
//
//  Created by Tobias Keinath on 17.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "TreeDetailViewController.h"
#import "SGAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Database.h"

@interface TreeDetailViewController ()

@end

@implementation TreeDetailViewController

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
    self.rateView.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"star.png"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    // Do any additional setup after loading the view.

    [self registerForKeyboardNotifications];
    
    self.treeName.delegate = self;
    self.treeTag.delegate = self;
    // graphical tweaks
    _description.clipsToBounds = YES;
    _description.layer.cornerRadius = 4.0f;
    
    _treeName.clipsToBounds = YES;
    _treeName.layer.cornerRadius = 4.0f;

    _treeTag.clipsToBounds = YES;
    _treeTag.layer.cornerRadius = 4.0f;
    
    _locationBGView.clipsToBounds = YES;
    _locationBGView.layer.cornerRadius = 4.0f;
    
    
    // Register taps on tree pricture and location
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTreePicture)];
    singleTap.numberOfTapsRequired = 1;
    [_treePicture addGestureRecognizer:singleTap];
    
     UITapGestureRecognizer *singleTapLocation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLaction)];
    singleTapLocation.numberOfTapsRequired = 1;
    [_treeDistance addGestureRecognizer:singleTapLocation];
    
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapOnTreePicture{
    NSLog(@"Tap on TreePicture");
    [self performSegueWithIdentifier:@"showSetPicture" sender:self];
}

-(void)tapOnLaction{
    NSLog(@"Tap on Location");
    [self performSegueWithIdentifier:@"showSetLocation" sender:self];
}

//Change background when editing and make the elements editable
- (IBAction)tapEdit:(id)sender {
    
    if (![FBSession activeSession].isOpen) {
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                           message:@"Sie müssen eingeloggt sein um den Baum zu bearbeiten."
                                                          delegate:self
                                                 cancelButtonTitle:@"Abbrechen"
                                                 otherButtonTitles:@"zum Login", nil];
        [theAlert show];
        
    }else{
    
    self.description.editable = YES;
    _treePicture.userInteractionEnabled = YES;
    _treeTag.enabled = YES;
    _treeName.enabled=YES;
    _treeDistance.userInteractionEnabled = YES;
   
    
    [_backgroundView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]];
    [_doneButton setHidden:NO];
        
    }
    
}

- (IBAction)doneEditing:(id)sender {
    [self.view endEditing:YES];
    self.description.editable = NO;
    _treePicture.userInteractionEnabled = NO;
    _treeTag.enabled = YES;
    _treeName.enabled=YES;
    _treeDistance.userInteractionEnabled = YES;
    [_backgroundView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    [_doneButton setHidden:YES];
    
    //Save Changes in DB
}

-(void)bookmarkTree:(id)sender{
    
    if (![FBSession activeSession].isOpen) {
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                           message:@"Sie müssen eingeloggt sein um den Baum zu bookmarken."
                                                          delegate:self
                                                 cancelButtonTitle:@"Abbrechen"
                                                 otherButtonTitles:@"zum Login", nil];
        [theAlert show];
        
    }else{
        
    }
}

/*
-(void)tapBackground:(id)sender{
    [self.view endEditing:YES];
}
*/

- (void) connectWithFacebook {
    // The user has initiated a login, so call the openSession method
    // and show the login UI if necessary << Only if user has never
    // logged in or ir requesting new permissions.
    SGAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
}


#pragma Mark - Keyboard behavior setup

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
    if (!CGRectContainsPoint(aRect, _description.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_description.frame animated:YES];
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

- (IBAction)showRatingActionSheet:(id)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Bewerten Sie diesen Baum:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Abbrechen"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"1 Stern", @"2 Sterne", @"3 Sterne", @"4 Sterne", @"5 Sterne", nil];
    
    [actionSheet showInView:self.view];
    actionSheet.tag = 100;
}

#pragma mark - UIActionSheet method implementation

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    
    if (![FBSession activeSession].isOpen) {
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                           message:@"Sie müssen eingeloggt sein um den Baum zu bewerten."
                                                          delegate:self
                                                 cancelButtonTitle:@"Abbrechen"
                                                 otherButtonTitles:@"zum Login", nil];
        [theAlert show];
    }else{
    
    if (actionSheet.tag == 100) {
        NSLog(@"The Rating selection action sheet.");
    }
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"From didDismissWithButtonIndex - Selected Rating: %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
        
        //TODO POST Rating to Parse
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"From willDismissWithButtonIndex - Selected Rating: %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
    }
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    Database *db = [[Database alloc] init];
    NSString* treeid = @"tq0M0q5fC4";
    float treeRating = [[db getTreeRating:treeid] floatValue];
    self.statusLabel.text = [NSString stringWithFormat:@"%f", treeRating];
    self.raterCount.text = [NSString stringWithFormat:@"%i insgesamt", [db getRaterCount:treeid]];
}


#pragma mark - UIAlert method implementation

- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"The %@ button was tapped.", [theAlert buttonTitleAtIndex:buttonIndex]);
    if(buttonIndex == 1){
        [self connectWithFacebook];
    }
    
}



@end
