//
//  LoginViewController.m
//  StadtgartenApp
//
//  Created by Tobias Keinath on 10.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "LoginViewController.h"
#import "Database.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


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
    self.loginButton.delegate = self;

}

-(void)viewDidDisappear:(BOOL)animated{
    _isFromProfile=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - FBLoginViewDelegate



- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    
    NSString *skipButtonString = [NSString stringWithFormat:@"%@ %@", @"Fortfahren als",user.name];
    [self.skipButton setTitle:skipButtonString forState:UIControlStateNormal];
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    _isLoggedIn = YES;
    
    if(!_isFromProfile && _isLoggedIn){
    [self performSegueWithIdentifier:@"showMap" sender:loginView];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    _isLoggedIn = NO;
    _isFromProfile=NO;
    
     [self.skipButton setTitle:@"Fortfahren als Gast" forState:UIControlStateNormal];
    
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
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

- (IBAction)tapSkipButton:(id)sender {
    NSLog(@"single Tap on SkipButton");
        [self performSegueWithIdentifier:@"showMap" sender:self];
}
@end
