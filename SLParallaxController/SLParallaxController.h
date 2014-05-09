//
//  SLParallaxController.h
//  SLParallax
//
//  Created by Stefan Lage on 14/03/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol SLParallaxControllerDelegate <NSObject>

// Tap handlers
-(void)didTapOnMapView;
-(void)didTapOnTableView;
// TableView's move
-(void)didTableViewMoveDown;
-(void)didTableViewMoveUp;

@end

@interface SLParallaxController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

@property (nonatomic, weak)     id<SLParallaxControllerDelegate>    delegate;
@property (nonatomic, strong)   UITableView                         *tableView;
@property (nonatomic, strong)   MKMapView                           *mapView;
@property (nonatomic)           float                               heighTableView;
@property (nonatomic)           float                               heighTableViewHeader;
@property (nonatomic)           float                               minHeighTableViewHeader;
@property (nonatomic)           float                               minYOffsetToReach;
@property (nonatomic)           float                               default_Y_mapView;
@property (nonatomic)           float                               default_Y_tableView;
@property (nonatomic)           float                               Y_tableViewOnBottom;
@property (nonatomic)           float                               latitudeUserUp;
@property (nonatomic)           float                               latitudeUserDown;
@property (nonatomic)           BOOL                                regionAnimated;
@property (nonatomic)           BOOL                                userLocationUpdateAnimated;

// Move the map in terms of user location
// @minLatitude : subtract to the current user's latitude to move it on Y axis in order to view it when the map move
- (void)zoomToUserLocation:(MKUserLocation *)userLocation minLatitude:(float)minLatitude animated:(BOOL)anim;

@end
