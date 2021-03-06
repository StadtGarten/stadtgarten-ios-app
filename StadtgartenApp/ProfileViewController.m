//
//  ProfileViewController.m
//  StadtgartenApp
//
//  Created by Tobias Keinath on 11.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "TreeDetailViewController.h"
#import "SGTree.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

Database * db;

NSArray *tableData;
NSString *userId;
int selectedList = 1; // own trees or favorites

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
    
    [self toggleHiddenState:YES];
   
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    self.loginButton.delegate = self;
    
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    _profilePicture.userInteractionEnabled = YES;
    [_profilePicture addGestureRecognizer:singleTap];
    
    
    db = [[Database alloc]init];
    self.tableView.dataSource = self;

    
    _segmentControl = [[UISegmentedControl alloc] init];
    [self.segmentControl addTarget:self
                         action:@selector(selectedControlChange:)
               forControlEvents:UIControlEventValueChanged];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self fetchTableData];
}

- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender {
    
    NSInteger clickedSegment = [sender selectedSegmentIndex];
    
    selectedList = (int)clickedSegment;
    [self fetchTableData];
    
}

- (void) fetchTableData {
    if (selectedList == 0) {
        [db getUserTrees:userId callback:^(NSArray *objects, NSError *error) {
            tableData = objects;
            [self.tableView reloadData];
        }];
    } else {
        [db getUserFavourites:userId with:^(NSArray *objects, NSError *error) {
            tableData = objects;
            [self.tableView reloadData];
        }];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
//    cell.textLabel.text
    SGTree *tree = tableData[indexPath.row];
    cell.textLabel.text = tree.name;
    
//    @"TESTETSETUE";
//    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}


-(void)tapDetected{
    NSLog(@"single Tap on profilePicture");
    [self performSegueWithIdentifier:@"showInitial" sender:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toggleHiddenState:(BOOL)shouldHide{
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
    self.loginButton.hidden = !shouldHide;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showInitial"]){
        LoginViewController *controller = (LoginViewController *)segue.destinationViewController;
        controller.isFromProfile = YES;
    } else if ([segue.identifier isEqualToString:@"showTreeDetail"]) {
        NSIndexPath *indexPath = nil;
        SGTree *selectedTree = nil;
        
        
        indexPath = [self.tableView indexPathForSelectedRow];
        selectedTree = [tableData objectAtIndex:indexPath.row];
        
        
        TreeDetailViewController *destViewController = segue.destinationViewController;
        destViewController.treeObject = selectedTree;
        
    }
}



//Facebook
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    
    [self toggleHiddenState:NO];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    self.profilePicture.profileID = user.objectID;
    self.lblUsername.text = user.name;
    self.lblEmail.text = [user objectForKey:@"email"];
    
    userId = user.objectID;
    [self fetchTableData];
    
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{

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



@end
