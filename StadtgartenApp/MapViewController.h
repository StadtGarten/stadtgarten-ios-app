//
//  MapViewController.h
//  StadtgartenApp
//
//  Created by Katharina Winkler on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKMapView+ZoomLevel.h"
#import "Database.h"
#import "SGTree.h"

@interface MapViewController : UIViewController< MKMapViewDelegate, CLLocationManagerDelegate>

- (void) centerOn:(CLLocationCoordinate2D)location;
- (IBAction)onProfileTap:(id)sender;
- (IBAction)onTreeListTap:(id)sender;
- (IBAction)onAddTreeTap:(id)sender;
- (IBAction)startTrackingLocation:(id)sender;


@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;



@end