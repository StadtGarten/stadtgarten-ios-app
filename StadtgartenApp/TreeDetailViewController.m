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
#import <FacebookSDK/FacebookSDK.h>
#import "Database.h"
#import "MapViewController.h"


@interface TreeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookmarkButton;

@end

@implementation TreeDetailViewController

Database *db;
CLLocationCoordinate2D treeLocation;
NSString* userid;
BOOL test;


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
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"star-full.png"];
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    // Do any additional setup after loading the view.

    [self registerForKeyboardNotifications];
    
    db = [[Database alloc] init];
    ////////////////FIXME treeid +userid übergeben!!
    userid = self.treeObject.userid;
    NSString* treeid = self.treeObject.id;
    CLLocation* myLocation = [[CLLocation alloc] initWithLatitude:47.1 longitude:11.0];;
    //[db getTreeRating:^(NSArray *trees, NSError *error);
    __block NSNumber* treeRating;
    [db getTreeInfo:treeid callback:^(SGTree* tree, NSError *error){
        treeRating = tree.rating;
        self.statusLabel.text = [NSString stringWithFormat:@"%.01f", [treeRating floatValue]];
        self.treeName.text = tree.name;
        self.treeTag.text = tree.tag;
        self.description.text = tree.description;
        UIImage *img = tree.picture;
        self.treePicture.image = img;
        treeLocation.latitude = tree.latitude;
        treeLocation.longitude = tree.longitude;
        
    }];
    [db getRaterCount:treeid callback:^(int number, NSError *error){
        self.raterCount.text = [NSString stringWithFormat:@"%i insgesamt", number];
    }];
    [db getUserRating:userid treeid:treeid callback:^(int rating, NSError *error){
        self.rateView.rating = rating;
    }];
    [db getDistance:treeid location:myLocation callback:^(NSNumber *distance, NSError *error){
        self.treeDistance.text = [NSString stringWithFormat:@"%.02fm", [distance floatValue]/1000];
    }];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *fbUser, NSError *error) {
         
         NSString* fbid = [fbUser objectForKey:@"id"];
         if (![fbid isEqual: userid]) {
             
             UIImage *img = [UIImage imageNamed:@"edit.png"];
             UIImage* imageForRendering = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
             self.editButton.image = imageForRendering;
             self.editButton.tintColor = [UIColor grayColor];
             self.editButton.enabled = NO;
             
         }
     }];
    
    
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
    
    
    [self updateBookmarkStatus];
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

- (IBAction)goToMap:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    MapViewController *mapView = self.navigationController.viewControllers[0];
    
    [mapView centerOn:treeLocation];
    
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

-(IBAction)bookmarkTree:(id)sender{
    
    if (![FBSession activeSession].isOpen) {
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                           message:@"Sie müssen eingeloggt sein um den Baum zu bookmarken."
                                                          delegate:self
                                                 cancelButtonTitle:@"Abbrechen"
                                                 otherButtonTitles:@"zum Login", nil];
        [theAlert show];
        
    }else{
        // get FacebookUserID
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *aUser, NSError *error) {
             if (!error) {
                 NSLog(@"Bookmark tree %@ for %@",self.treeObject.id, [aUser objectForKey:@"id"]);
                 
                 [db bookmarkTree:self.treeObject.id user:[aUser objectForKey:@"id"] callback:^(BOOL succeeded, NSError *error) {
                     
                     [self updateBookmarkStatus];
                 }];
                 
             }
         }];
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

-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    if (![FBSession activeSession].isOpen) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Rating"
                                                           message:@"Sie müssen eingeloggt sein um den Baum zu bewerten."
                                                          delegate:self
                                                 cancelButtonTitle:@"Abbrechen"
                                                 otherButtonTitles:@"zum Login", nil];
        [theAlert show];
    }
    else{
        db = [[Database alloc ]  init ];
        __block NSString* userid;
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *fbUser, NSError *error) {
             userid = [fbUser objectForKey:@"id"];
             //userid = @"testuser2";
             NSString* treeid = self.treeObject.id;
             NSNumber* newRating = [NSNumber numberWithFloat:rating];
             [db rateTree:userid treeid:treeid rating:newRating];
             [self reloadView:treeid];
             test = true;
        }];
    }
}

-(void)reloadView:(NSString*)treeid{

    db = [[Database alloc] init];
    [db getRaterCount:treeid callback:^(int number, NSError *error){
    self.raterCount.text = [NSString stringWithFormat:@"%i insgesamt", number];
    
        [db getTreeInfo:treeid callback:^(SGTree* tree, NSError *error){
            self.statusLabel.text = [NSString stringWithFormat:@"%.01f", [tree.rating floatValue]];
            //fixme besserer fix fürs nachladen von neuen werten? 
            if (test) {
                [self reloadView:treeid];
                test = false;
                [self reloadView:treeid];
        }
        }];
    }];

}

#pragma mark - UIAlert method implementation

- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"The %@ button was tapped.", [theAlert buttonTitleAtIndex:buttonIndex]);
    if(buttonIndex == 1){
        [self connectWithFacebook];
    }
    
}


- (void)updateBookmarkStatus {
    
    if ([FBSession activeSession].isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *aUser, NSError * error) {
             
             [db getUserFavourites:[aUser objectForKey:@"id"] with:^(NSArray *objects, NSError *error) {
                 self.bookmarkButton.tintColor = [UIColor darkGrayColor];
                 for (int x = 0; x < objects.count; x++) {
                     SGTree *tree = objects[x];
                     
                     if ([tree.id isEqualToString:self.treeObject.id]) {
                         self.bookmarkButton.tintColor = [UIColor colorWithRed:4.0/255.0 green:147.0/255.0 blue:114.0/255.0 alpha:0.7];
                         return;
                     }
                 }
                 
             }];
             
         }];
    }
    
    self.bookmarkButton.tintColor = [UIColor darkGrayColor];
   
}


@end
