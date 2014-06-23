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

// if segue "showDescription" is chosen, instantiate itemController and set attributes to treeObject
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDescription"]){
        SetItemViewController *itemController = (SetItemViewController *)segue.destinationViewController ;
        
        
        CGSize size;
        size.height = 512;
        size.width = 512;
        UIImage *image = [self squareImageWithImage:imageView.image scaledToSize:size];
        
        self.tree.picture = image;
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

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
