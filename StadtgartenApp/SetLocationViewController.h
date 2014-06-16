//
//  SetLocationViewController.h
//  StadtgartenApp
//
//  Created by Ka Wi on 14.05.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	<CoreLocation/CoreLocation.h>
#import "MKMapView+ZoomLevel.h"

@interface SetLocationViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myLocationButton;
- (IBAction)goToMyLocationClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *crossHair;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property	(strong,	nonatomic)	CLLocationManager	*locationManager;

@end
