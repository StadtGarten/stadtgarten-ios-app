//
//  SetPictureViewController.h
//  StadtgartenApp
//
//  Created by Jule Zigeler on 6/3/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPictureViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
// Methoden der Delegates benutzen
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

-  (IBAction) takePicture:(id) sender;
-  (IBAction) selectPhoto:(id)sender;
@end