//
//  MapViewController.m
//  StadtgartenApp
//
//  Created by Katharina Winkler on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//
// Map, Pins setzen, Fokus setzen



#import "MapViewController.h"
#import "TreeDetailViewController.h"
#import "SGTree.h"
#import "SGAppDelegate.h"

@interface MapViewController ()

@end

@implementation MapViewController

const int ZOOM_FACTOR = 11;

const int LATITUDE = 0;
const int LONGITUDE = 1;

const bool CENTER_IN_MUNICH = NO;
const bool ZOOM = NO;

//GPS of Munich
float lat = 48.133;
float lon = 11.567;

//fur die Daten aus der Datenbank
NSArray *trees;

//Zuordung fuer Pins
NSMutableArray *markers;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [CLLocationManager new];
    // Highest accuracy to place the tree
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
    [self setMap];
    [self startTrackingLocation:_mapView];
}

//Holt die Daten aus der Datenbank
- (void)getTreeFromDatabase {
    Database *database = [[Database alloc] init];
    //__block SGTree *sgTree;
    
    [database getTrees:^(NSArray *results, NSError *error) {
        trees = results;
        //[self setMapConfig];
        [self setMarker];
        //[self.mapView reloadInputViews];
    }];
}


//setzt die Marker
- (void)setMarker {
    CLLocationCoordinate2D annotationCoord;
    
    //Anzahl der Elemente
    int const numberOfElements = (int)[trees count];
    
    markers = [[NSMutableArray alloc] initWithCapacity:numberOfElements];
    
    for(int i=0; i<(numberOfElements); i++) {
        SGTree* tree = [trees objectAtIndex:i];
        annotationCoord.latitude = tree.latitude;
        annotationCoord.longitude = tree.longitude;
        
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = annotationCoord;
        annotationPoint.title = tree.name;
        annotationPoint.subtitle = tree.tag;
        
        [markers addObject:annotationPoint];
        [_mapView addAnnotation:annotationPoint];

        //to location
        //[self.locationManager setDelegate:self];

    }
}


//
// Location Update Functions
//

- (IBAction)startTrackingLocation:(id)sender {
    [self.locationManager setDelegate:self];
}

- (void) stopTrackingLocation
{
    [self.locationManager setDelegate:nil];
    //self.myLocationButton.enabled = true;
}

//setzt die Map
- (void)setMap {

    _mapView = [[MKMapView alloc]
                initWithFrame:CGRectMake(0,
                                         -45,
                                         self.view.bounds.size.width,
                                         self.view.bounds.size.height)
                ];
     
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}

- (void)setMapConfig {

    MKCoordinateRegion region;
    
    if(CENTER_IN_MUNICH) {
        region.center.latitude = lat;
        region.center.longitude = lon;
    }
    
    if(ZOOM) {
        region.span.latitudeDelta = 0.2;
        region.span.longitudeDelta = 0.2;
    }
    //[_mapView setRegion:region animated:YES];
}

-(void)centerOn:(CLLocationCoordinate2D)location {
    MKCoordinateRegion region;
    region.center = location;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)onProfileTap:(id)sender {
    
   if ([self isLoggedInFacebook ]) {
    [self performSegueWithIdentifier:@"showProfile" sender:self];
    }
   else{
       [self connectWithFacebook];
   }
}

- (IBAction)onTreeListTap:(id)sender {
    if ([self isLoggedInFacebook ]) {
        [self performSegueWithIdentifier:@"showTreeList" sender:self];
    }
    else{
        [self connectWithFacebook];
    }
}

- (IBAction)onAddTreeTap:(id)sender {
    
    if ([self isLoggedInFacebook ]) {
        [self performSegueWithIdentifier:@"showAddTree" sender:self];
    }
    else{
        [self connectWithFacebook];
    }
}

- (IBAction)setCurrentLocation:(id)sender {
}

-(BOOL)isLoggedInFacebook{
    
    return [FBSession activeSession].isOpen;
}

- (void) connectWithFacebook {
    // The user has initiated a login, so call the openSession method
    // and show the login UI if necessary << Only if user has never
    // logged in or ir requesting new permissions.
    SGAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
}



//setzt das entsprechende Bild, ordnet den Pins ein Bild zu
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *annotationIdentifier = @"CustomViewAnnotation";
    
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    MKAnnotationView *myAnnotation =  [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];

    int index = 0;
    for (int i = 0; i < markers.count; i++) {
        MKPointAnnotation *pA = markers[i];
        if (pA.coordinate.latitude == annotation.coordinate.latitude && pA.coordinate.longitude == annotation.coordinate.longitude) {
            
            index = i;
        }
    }
    
    SGTree* sgTree = [trees objectAtIndex:index];
    
    if([sgTree.tag isEqual: @"Apfel"]) {
        myAnnotation.image = [UIImage imageNamed:@"apple_pin.png"];
    } else if([sgTree.tag isEqual: @"Kirsche"]) {
        myAnnotation.image = [UIImage imageNamed:@"cherrie_pin.png"];
    } else if([sgTree.tag isEqual: @"Birne"]) {
        myAnnotation.image = [UIImage imageNamed:@"pear_pin.png"];
    }
    
    myAnnotation.canShowCallout= YES;
    myAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return myAnnotation;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    int index = 0;
    for (int i = 0; i < markers.count; i++) {
        MKPointAnnotation *pA = markers[i];
        if (pA.coordinate.latitude == view.annotation.coordinate.latitude && pA.coordinate.longitude == view.annotation.coordinate.longitude) {
        
        index = i;
        }
    
    }
    SGTree* tree = [trees objectAtIndex:index];
    [self performSegueWithIdentifier:@"treeDetailView" sender:tree];

};


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"treeDetailView"])
    {
        TreeDetailViewController *destViewController = segue.destinationViewController;
        destViewController.treeObject = sender;
    }
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getTreeFromDatabase];
    //[self startTrackingLocation];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLocation = locations.lastObject;
    [_mapView setCenterCoordinate:lastLocation.coordinate zoomLevel:(int)ZOOM_FACTOR animated:true];
    [self stopTrackingLocation];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
