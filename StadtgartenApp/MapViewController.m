//
//  MapViewController.m
//  StadtgartenApp
//
//  Created by Katharina Winkler on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//
// Map, Marker/Pins setzen, Fokus setzen



#import "MapViewController.h"

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

/*
NSDictionary *baum;
double markerPosition[][2] = {47.0, 11.0,
    47.1, 11.1,
    47.15, 11.2,
    48.15, 11.6,
    48.2, 11.62,
    48.15, 11.5,
    48.13, 11.6,
    48.14, 11.58,
    48.22, 11.61,
    48.1, 11.4,
    48.2, 11.15,
    48.0, 11.25,
    47.2, 11.2};
*/
 
NSArray *trees;


- (void)viewDidLoad
{
    NSLog(@"start MapViewController");

    _tree = APPLE;

    
    [super viewDidLoad];
    
    /*
    baum = [NSDictionary dictionaryWithObjectsAndKeys:
            @"01", @"id",
            @"Apfelbaum", @"baumname",
            @"Das ist eine Beschreibung", @"beschreibung",
            @"Apfel", @"tag",
            @"Das ist ein Bild", @"bild",
            nil];
    
    NSLog(@"%@", [baum objectForKey: @"tag"]);
    */

    
    [self getTreeFromDatabase];
    
    }


- (void)getTreeFromDatabase {

    Database *database = [[Database alloc] init];
    __block SGTree *sgTree;
    
    [database getTrees:^(NSArray *results, NSError *error) {
        trees = results;
        //sgTree = [trees firstObject];


        for (int i = 0; i < results.count; i++) {
  
            sgTree = [results objectAtIndex:i];
            if ([sgTree.tag  isEqual: @"Apfel"]){
                _tree = APPLE;
            } else if ([sgTree.tag  isEqual: @"Birne"]){
                _tree = PEAR;
            } else {
                _tree = CHERRIE;
            }
            
            NSLog(@"Tree: %@", sgTree);

            [self setMap];

        }
        
        [self setMarker];
        
        //NSLog(@"result Trees: %@ %@", [trees objectAtIndex:0], [results objectAtIndex:0]);
    }];
    
    //NSLog(@"Trees: %@", [trees objectAtIndex:@"tag"]);
    //NSLog(@"Trees: %@", [trees objectAtIndex:0]);
    //NSLog(@"Trees: %@", sgTree.tag);
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


- (void)setMarker {
    CLLocationCoordinate2D annotationCoord;

    //Anzahl der Elemente
    int const numberOfElements = (int)[trees count];

    for(int i=0; i<(numberOfElements-1); i++) {
     
        SGTree* tree = [trees objectAtIndex:i];
        annotationCoord.latitude = tree.latitude;
        annotationCoord.longitude = tree.longitude;
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = annotationCoord;
        annotationPoint.title = tree.name;
        annotationPoint.subtitle = tree.tag;

        [_mapView addAnnotation:annotationPoint];
    
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    NSString *annotationIdentifier = @"CustomViewAnnotation";
    MKAnnotationView* annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if(!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:annotationIdentifier];
    }
    
    
    if(_tree == APPLE) {
        annotationView.image = [UIImage imageNamed:@"apple_pin.png"];
    }
    if(_tree == CHERRIE) {
        annotationView.image = [UIImage imageNamed:@"cherrie_pin.png"];
    }
    if(_tree == PEAR) {
        annotationView.image = [UIImage imageNamed:@"pear_pin.png"];
    }

    annotationView.canShowCallout= YES;
    
    return annotationView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MKCoordinateRegion region;
    
    if(ZOOM) {
        region.span.latitudeDelta = 0.1;
        region.span.longitudeDelta = 0.1;
    }
    
    if(CENTER_IN_MUNICH) {
        region.center.latitude = lat;
        region.center.longitude = lon;
    }
    [_mapView setRegion:region animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
