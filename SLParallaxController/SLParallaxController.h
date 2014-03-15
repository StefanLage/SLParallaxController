//
//  SLParallaxController.h
//  SLParallax
//
//  Created by Stefan Lage on 14/03/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SLParallaxController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

@property (nonatomic, strong)   UITableView                         *tableView;
@property (nonatomic, strong)   MKMapView                           *mapView;


@end
