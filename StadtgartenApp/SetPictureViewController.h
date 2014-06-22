//
//  SetPictureViewController.h
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/3/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGTree.h"

@interface SetPictureViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController *picker;

@property (strong, readwrite) SGTree *tree;

-  (IBAction) takePicture:(id) sender;
-  (IBAction) selectPhoto:(id)sender;

- (IBAction) requireImage:(id)sender;

@end