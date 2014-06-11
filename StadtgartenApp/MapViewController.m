//
//  MapViewController.m
//  StadtgartenApp
//
//  Created by Katharina Winkler on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//
// Setzen der Map und der Marker



#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController



const int LATITUDE = 0;
const int LONGITUDE = 1;


//test
//Muenchen
float lat = 48.133;
float lon = 11.567;

NSArray *myColors;

//myColors = [NSArray arrayWithObjects: @"Red", @"Green", @"Blue", @"Yellow", nil];

//NSDictionary *dict;
/*
 *dict = [NSDictionary dictionaryWithObjectsAndKeys:
        @"/opt/picture.png", @"Luca",
        @"/home/nico/birthday.png", @"Birthday Photo",
        @"/home/nico/birthday.png", @"Birthday Image",
        @"/home/marghe/pic.jpg", @"My Sister", nil];
*/
//NSString *value = [myDictionary objectForKey:@"Bob", "ddd", "ddd"];

//lat, lon, title (Apfelbaum), subtitle

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


bool testSession = NO;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self setMap];

    [self setMarker];

    //[self.view addSubview:_navigationBar];

    


    
    //Button ohne Storyboard
    /*
     UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [button addTarget:self
     action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchUpInside];
     [button setTitle:@"add" forState:UIControlStateNormal];
     button.frame = CGRectMake(180.0, 430.0, 160.0, 40.0);
     [self.view addSubview:button];
     */
    
    //[_mapView release];
    
    
    }


- (void)setMap {

    _mapView = [[MKMapView alloc]
                initWithFrame:CGRectMake(0,
                                         -170,
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
 
    int const sizeOfElements = 13;
    
    
    for(int i=0; i<(sizeOfElements-1); i++) {
     
        annotationCoord.latitude = markerPosition[i][LATITUDE];
        annotationCoord.longitude = markerPosition[i][LONGITUDE];
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = annotationCoord;
        annotationPoint.title = @"Apfelbaum";
        annotationPoint.subtitle = @"";

        [_mapView addAnnotation:annotationPoint];
    
    }


}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(testSession) {
        MKCoordinateRegion region;
        region.center.latitude = lat;
        region.center.longitude = lon;
        region.span.latitudeDelta = 0.1;
        region.span.longitudeDelta = 0.1;
        [_mapView setRegion:region animated:YES];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
