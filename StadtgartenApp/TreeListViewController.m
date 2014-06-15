//
//  TreeListViewController.m
//  StadtgartenApp
//
//  Created by Katharina Winkler on 15.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "TreeListViewController.h"

@interface TreeListViewController ()

@end

@implementation TreeListViewController


NSArray *textData;
NSArray *imageData;
NSArray *subTextData;


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
    
    
    
    textData = [NSArray arrayWithObjects:@"Apfelbaum", @"Birnbaum", @"Kirschbaum", @"Apfelbaum", @"Kirschbaum",nil];

    
    imageData = [NSArray arrayWithObjects:@"apple_pin.png", @"pear_pin.png", @"cherrie_pin.png", @"apple_pin.png", @"cherrie_pin.png", nil];
 
    subTextData = [NSArray arrayWithObjects:@"in 400 m", @"in 650 m", @"in 700 m", @"in 1,2 km", @"in 2,3 km",nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Menu";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [textData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    //fügt kleinen pfeil hinzu
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //setzt Text
    cell.textLabel.text = [textData objectAtIndex:indexPath.row];


    //subtitel
    cell.detailTextLabel.text = [subTextData objectAtIndex:indexPath.row];
    
    
    //setzt bilder
    cell.imageView.image = [UIImage imageNamed:[imageData objectAtIndex:indexPath.row]];
    
    return cell;
}

/*wird aufgerufen wenn ein element aus tabelle ausgewählt wird*/
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    
    //[data setMenu:cell.textLabel.text];
    
    cell.textLabel.text = @"test";
    
    NSLog(@"selected element: %@", cellText);
 
}
 */

@end
