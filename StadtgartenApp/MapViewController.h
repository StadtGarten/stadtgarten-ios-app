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


@interface MapViewController : UIViewController < MKMapViewDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutletCollection(MKMapView) NSArray *test;
@property (nonatomic, strong) CLLocationManager *locationManager;

//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)uloc;

@end