//
//  AuthentificationViewController.h
//  StadtgartenApp
//
//  Created by Tobias Keinath on 04.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AuthentificationViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblLoginStatus;

@property (strong, nonatomic) IBOutlet UILabel *lblUsername;

@property (strong, nonatomic) IBOutlet UILabel *lblEmail;

@property (strong, nonatomic) IBOutlet FBLoginView *loginButton;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;

@end
