//
//  MKMapView+ZoomLevel.h
//  StadtgartenApp
//
//  Created by Dennis Schaaf on 6/6/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
