//
//  MapViewController.m
//  StadtgartenApp
//
//  Created by Ka Wi on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//



#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

//test
//Muenchen
float lat = 48.133;
float lon = 11.567;

bool testSession = YES;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    //Map
    _mapView = [[MKMapView alloc]
                initWithFrame:CGRectMake(0,
                                         -80,
                                         self.view.bounds.size.width,
                                         self.view.bounds.size.height)
                ];
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeHybrid;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    

    
    // Create a search bar - you can add this in the viewDidLoad
	//self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
    //self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
   
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
	self.searchBar.delegate = self;
	//self.tableView.tableHeaderView = self.searchBar;
    
    
    
    
    // Create the search display controller
	//self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    //self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
	//self.searchDC.searchResultsDataSource = self;
	//self.searchDC.searchResultsDelegate = self;
    
    [self.view addSubview:_searchBar];

    
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



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //NSLog(@"%@", NSStringFromClass(self.class));
    
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
