//
//  SetPictureViewController.m
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/3/14.

//  Copyright (c) 2014 StadtGarten. All rights reserved. test blabla
//

#import "SetPictureViewController.h"
#import "SetItemViewConntroller.h"

@interface SetPictureViewController ()

@end

@implementation SetPictureViewController

@synthesize picker;

-(void) requireImage:(id)sender{
    //if([picker == nil]){
    //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler"
    //                                                message:@"Waehlen Sie ein Bild aus"
    //                                             delegate:self
    //                                  cancelButtonTitle:@"OK"
    //                                otherButtonTitles:nil];
    //[alert show];
    //[alert release];
    //}else{
    //[self performSegueWithIdentifier:@"showDescription" sender:self];
    //}
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDescription"]){
        SetItemViewConntroller *itemController = (SetItemViewConntroller *)segue.destinationViewController ;
        //  itemcontroller _image = picker;
    }
}
- (IBAction)takePicture:(id)sender {
    
    // test if camerafunction is available
    // if not show Error Message
    if (![UIImagePickerController
          isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView =
        [[UIAlertView alloc] initWithTitle:@"Fehler"
                                   message:@"iPhone besitzt keine Kamerafunktion" delegate:nil cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [myAlertView show];
        
    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // choose picture from camera
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}
- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing =YES;
    // choose picture from Library
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //Cancle Button Methode
    [picker dismissViewControllerAnimated:YES completion:NULL];
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
