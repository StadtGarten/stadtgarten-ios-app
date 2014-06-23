//
//  MapViewController.m
//  StadtgartenApp
//
//  Created by Katharina Winkler on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//
// Map, Marker/Pins setzen, Fokus setzen



#import "MapViewController.h"
#import "TreeDetailViewController.h"
#import "SGTree.h"

@interface MapViewController ()

@end

@implementation MapViewController

#define APPLE 0
#define CHERRIE 1
#define PEAR 2

const int LATITUDE = 0;
const int LONGITUDE = 1;

const bool CENTER_IN_MUNICH = YES;
const bool ZOOM = YES;

//GPS of Munich
float lat = 48.133;
float lon = 11.567;

NSArray *trees;
NSMutableArray *markers;


- (void)viewDidLoad
{
    _tree = APPLE;

    [super viewDidLoad];
    [self getTreeFromDatabase];
    
}

- (void)getTreeFromDatabase {
    Database *database = [[Database alloc] init];
    __block SGTree *sgTree;
    
    [database getTrees:^(NSArray *results, NSError *error) {
        trees = results;
        [self setMap];
        [self setMapConfig];
        [self setMarker];
    }];
}



- (void)setMarker {
    CLLocationCoordinate2D annotationCoord;
    
    //Anzahl der Elemente
    int const numberOfElements = (int)[trees count];
    
    markers = [[NSMutableArray alloc] initWithCapacity:numberOfElements];
    
    for(int i=0; i<(numberOfElements-1); i++) {
        SGTree* tree = [trees objectAtIndex:i];
        annotationCoord.latitude = tree.latitude;
        annotationCoord.longitude = tree.longitude;
        
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = annotationCoord;
        annotationPoint.title = tree.name;
        annotationPoint.subtitle = tree.tag;
        
        [markers addObject:annotationPoint];
        [_mapView addAnnotation:annotationPoint];

    }
}

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
    [_mapView setRegion:region animated:YES];
}

//int j = 0;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *annotationIdentifier = @"CustomViewAnnotation";
    
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    MKAnnotationView *myAnnotation =  [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];

    int index = 0;
    for (int i = 0; i < markers.count - 1; i++) {
        MKPointAnnotation *pA = markers[i];
        if (pA.coordinate.latitude == annotation.coordinate.latitude && pA.coordinate.longitude == annotation.coordinate.longitude) {
            
            index = i;
        }
    }
    
    SGTree* tr = [trees objectAtIndex:index];
    NSLog(@"ANNOTATION INDEX %d", index);
    
    
    
    if([tr.tag isEqual: @"Apfel"]) {
        myAnnotation.image = [UIImage imageNamed:@"apple_pin.png"];
    } else if([tr.tag isEqual: @"Kirsche"]) {
        myAnnotation.image = [UIImage imageNamed:@"cherrie_pin.png"];
    } else if([tr.tag isEqual: @"Birne"]) {
        myAnnotation.image = [UIImage imageNamed:@"pear_pin.png"];
    }
    
    myAnnotation.canShowCallout= YES;
    //UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[detailButton setImage:[UIImage imageNamed:@"apple_pin.png"] forState: UIControlStateNormal];
    //annotationView.rightCalloutAccessoryView = detailButton;
    myAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return myAnnotation;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
   // TreeDetailViewController *treeDetailViewController = [[TreeDetailViewController alloc]initWithNibName:@"treeDetailView" bundle:nil];
    //[self.navigationController pushViewController:treeDetailViewController animated:YES];
    int index = 0;
    for (int i = 0; i < markers.count - 1; i++) {
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
        //SGTree* tree = sender;
        //[segue.destinationViewController setObject:@"NlU2yP62C9" forKey:@"treeObject"];
        TreeDetailViewController *destViewController = segue.destinationViewController;
        destViewController.treeObject = sender;
    }
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
