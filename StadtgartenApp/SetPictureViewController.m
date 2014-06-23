//
//  SetPictureViewController.m
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/3/14.

//  Copyright (c) 2014 StadtGarten. All rights reserved. test blabla
//

#import "SetPictureViewController.h"
#import "SetItemViewController.h"
#import "SGTree.h"

@interface SetPictureViewController ()

@end

@implementation SetPictureViewController

@synthesize picker;
@synthesize imageView;


// an image is necessary before switching to the next view, show alertView
-(IBAction) requireImage:(id)sender{
    if(imageView.image == nil){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler"
                                                   message:@"Bitte wählen Sie ein Bild aus"
                                                 delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
    [alert show];
    }else{
    // go to next view if segue "showDescription" is chosen
    [self performSegueWithIdentifier:@"showDescription" sender:self];
    }
}

/*
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}*/


// if segue "showDescription" is chosen, instantiate itemController and set attributes to treeObject
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDescription"]){
        SetItemViewController *itemController = (SetItemViewController *)segue.destinationViewController ;
        self.tree.picture = imageView.image;
        //itemController.image= imageView.image;
        itemController.image = self.tree.picture;
        itemController.tree = self.tree;
        
    }
}

// test if camerafunction is available, if not show Error Message
- (IBAction)takePicture:(id)sender {
    if (![UIImagePickerController
          isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView =
        [[UIAlertView alloc] initWithTitle:@"Fehler"
                                   message:@"iPhone besitzt keine Kamerafunktion" delegate:nil cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [myAlertView show];
        
    }else{
       
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // choose picture from camera
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}

// select photo from library
- (IBAction)selectPhoto:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing =YES;
    // choose picture from Library
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

// show chosenImage in imageView
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// show Cancel Button
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
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
