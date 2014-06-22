//
//  SetLocationViewController.m
//  StadtgartenApp
//
//  Created by Ka Wi on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "SetLocationViewController.h"

@interface SetLocationViewController ()

@end

@implementation SetLocationViewController

//
// Center map based on phone location
// When user drags, stop tracking location
//  - and show the current location button
//
// When user clicks ok, save location (where?)
// - the selected location is map.center


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
    self.locationManager = [CLLocationManager new];
    // Highest accuracy to place the tree
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
    
    [self.mapView setDelegate:self];
    
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    
    [panRec setDelegate:self];
    [self.mapView addGestureRecognizer:panRec];
    
    //[self.mapView addSubview:self.crossHair];
    [self.view bringSubviewToFront:self.crossHair];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self stopTrackingLocation];
    
    // remove all delegates
}

- (void) viewWillAppear:(BOOL)animated
{
    self.mapView.zoomEnabled = false;
    self.mapView.showsUserLocation = true;
    
    [self startTrackingLocation];
}

//
// Map View Functions - detect drag
//
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"drag started");
        [self stopTrackingLocation];
    }
}

- (IBAction)goToMyLocationClick:(id)sender {
    [self startTrackingLocation];
}

//
// Location Update Functions
//
- (void) startTrackingLocation
{
    [self.locationManager setDelegate:self];
   // self.myLocationButton.hidden = true;
}

- (void) stopTrackingLocation
{
    [self.locationManager setDelegate:nil];
   // self.myLocationButton.hidden = false;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLocation = locations.lastObject;
    [self.mapView setCenterCoordinate:lastLocation.coordinate zoomLevel:16 animated:true];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"some error occurred ... %@", error);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    SetPictureViewController *controller = (SetPictureViewController *) segue.destinationViewController;
    
    SGTree *tree = [[SGTree alloc] init];
    tree.latitude = self.mapView.centerCoordinate.latitude;
    tree.longitude = self.mapView.centerCoordinate.longitude;
    
    controller.tree = tree;
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
