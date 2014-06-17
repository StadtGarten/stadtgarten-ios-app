//
//  OverviewItemViewController.m
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/3/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "OverviewItemViewController.h"
#import "SetLocationViewController.h"

@interface OverviewItemViewController ()

@end



@implementation OverviewItemViewController

@synthesize nameLabel;
@synthesize descriptionLabel;
@synthesize tagsLabel;
@synthesize imageView;



-(IBAction)storeData:(id)sender{
    // get FacebookUserID
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *aUser, NSError *error) {
         if (!error) {
             NSLog(@"User id %@",[aUser objectForKey:@"id"]);
         }
     }];
    
    Database *newDatabase = [[Database alloc] init];
    //newDatabase writeTree:<#(NSString *)#> tag:<#(NSString *)#> beschreibung:<#(NSString *)#> bild:<#(UIImage *)#>;
    
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
    // Do any additional setup after loading the view.
    NSLog(@"%@", _name);
    nameLabel.text = _name;
    descriptionLabel.text = _description;
    tagsLabel.text = _tags;
    imageView.image = _image;
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

- (IBAction)doneSettingUpNewTree:(id)sender {
    
    [self performSegueWithIdentifier:@"showMap" sender:sender];
    
}
@end
