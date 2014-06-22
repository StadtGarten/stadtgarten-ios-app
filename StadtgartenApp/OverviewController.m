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



-(IBAction)storeData:(id)sender{
    // get FacebookUserID
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *aUser, NSError *error) {
         if (!error) {
             NSLog(@"User id %@",[aUser objectForKey:@"id"]);

        
         Database *db = [[Database alloc] init];
         //double latitude = 47.1;
         //double longitude = 11.1;
             UIImage *test = _image;
         //[db writeTree:[aUser objectForKey:@"id"] baumname:_name tag:_tags beschreibung:_description bild:_image latitude: latitude longitude:longitude];
             
             [db writeTree:[aUser objectForKey:@"id"] baumname:self.tree.name tag:self.tree.tag beschreibung:self.tree.description bild:self.tree.picture latitude:self.tree.latitude longitude:self.tree.longitude];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"Der Baum wurde gespeichert"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
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
    // Do any additional setup after loading the view.
    //NSLog(@"%@", _name);
    nameLabel.text = self.tree.name;
    descriptionLabel.text = self.tree.description;
    tagsLabel.text = self.tree.tag;
    imageView.image = self.tree.picture;
    //nameLabel.text = _name;
    //descriptionLabel.text = _description;
    //tagsLabel.text = _tags;
    //imageView.image = _image;
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

//- (IBAction)doneSettingUpNewTree:(id)sender {
    
//    [self performSegueWithIdentifier:@"showMap" sender:sender];
    
//}
@end
