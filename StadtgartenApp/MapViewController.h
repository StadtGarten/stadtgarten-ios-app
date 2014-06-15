//
//  MapViewController.h
//  StadtgartenApp
//
//  Created by Katharina Winkler on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController < MKMapViewDelegate, UISearchBarDelegate>

@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIToolbar *navigationBar;
//@property (nonatomic) IBOutlet UISearchBar *searchBar;

@property NSInteger tree;


@end