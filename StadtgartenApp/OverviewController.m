//
//  OverviewController.m
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/18/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "OverviewController.h"
#import "SetItemViewController.h"
#import "SGTree.h"

@interface OverviewController ()

@end

@implementation OverviewController

@synthesize nameLabel;
@synthesize descriptionLabel;
@synthesize tagsLabel;
@synthesize imageView;


// this method stores the data from the form into parse
-(IBAction)storeData:(id)sender{
    // get FacebookUserID
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *aUser, NSError *error) {
         if (!error) {
             NSLog(@"User id %@",[aUser objectForKey:@"id"]);

             
        // get data from treeObject
         Database *db = [[Database alloc] init];
             
             [db writeTree:[aUser objectForKey:@"id"] baumname:self.tree.name tag:self.tree.tag beschreibung:self.tree.description bild:self.tree.picture latitude:self.tree.latitude longitude:self.tree.longitude];
        // alertView that tree is sucessfully stored
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"Der Baum wurde gespeichert"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
        // go to mapView
         [self performSegueWithIdentifier:@"showMapView" sender:self];
         }
     }];
    
   
    
}

// delete Tree
-(IBAction)discardData:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verwerfen bestätigen"
                                                    message:@"Soll der Baum wirklich verworfen werden?"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ja"
                                          otherButtonTitles:@"Nein",nil];
    alert.delegate = self;
    [alert show];
    
    
}

// go to MapView if Tree delete is confirmed with "yes"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        [self performSegueWithIdentifier:@"showMapView" sender:self];
    }
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
    nameLabel.text = self.tree.name;
    descriptionLabel.text = self.tree.description;
    tagsLabel.text = self.tree.tag;
    imageView.image = self.tree.picture;

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
