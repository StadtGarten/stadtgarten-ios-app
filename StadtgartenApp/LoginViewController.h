//
//  LoginViewController.h
//  StadtgartenApp
//
//  Created by Tobias Keinath on 10.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet FBLoginView *loginButton;

@end
