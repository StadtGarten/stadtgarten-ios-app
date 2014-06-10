//
//  MapViewController.h
//  StadtgartenApp
//
//  Created by Ka Wi on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
//<UISearchBarDelegate>


@interface MapViewController : UIViewController < MKMapViewDelegate, UISearchBarDelegate>


@property (nonatomic) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) IBOutletCollection(MKMapView) NSArray *test;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIToolbar *navigationBar;


@property (nonatomic) IBOutlet UISearchBar *searchBar;


//@property ( nonatomic) UISearchDisplayController *searchDC;

@end