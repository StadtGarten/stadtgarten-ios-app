//
//  MapViewController.h
//  StadtgartenApp
//
//  Created by Katharina Winkler on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Database.h"
#import "SGTree.h"

@interface MapViewController : UIViewController< MKMapViewDelegate>

- (void) centerOn:(CLLocationCoordinate2D)location;
- (IBAction)onProfileTap:(id)sender;
- (IBAction)onTreeListTap:(id)sender;
- (IBAction)onAddTreeTap:(id)sender;


@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
//@property NSInteger tree;



@end