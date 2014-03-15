//
//  SLParallaxController.m
//  SLParallax
//
//  Created by Stefan Lage on 14/03/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "SLParallaxController.h"
#import <MapKit/MapKit.h>


#define HEIGHT_STATUS_BAR                    [[UIScreen mainScreen] bounds].size.height - 20
#define Y_DOWN_TABLEVIEW                     HEIGHT_STATUS_BAR - 40
#define IDENTIFIER_FIRST_CELL                @"firstCell"
#define IDENTIFIER_OTHER_CELL                @"otherCell"
#define HELLO_WORLD                          @"Hello World !"
#define DEFAULT_HEIGHT_HEADER                100.0f
#define MIN_HEIGHT_HEADER                    10.0f
#define DEFAULT_Y_OFFSET                     -250.0f
#define FULL_Y_OFFSET                        20.0f
#define MIN_Y_OFFSET_TO_REACH                -30
#define OPEN_SHUTTER_LATITUDE_MINUS          .005
#define CLOSE_SHUTTER_LATITUDE_MINUS         .018


@interface SLParallaxController ()

@property (strong, nonatomic)   UIView                  *header;
@property (strong, nonatomic)   UITapGestureRecognizer  *tapMapViewGesture;
@property (strong, nonatomic)   UITapGestureRecognizer  *tapTableViewGesture;
@property (nonatomic)           CGRect                  headerFrame;
@property (nonatomic)           float                   headerYOffSet;
@property (nonatomic)           BOOL                    isShutterOpen;
@property (nonatomic)           BOOL                    displayMap;

@end


@implementation SLParallaxController

-(id)init{
    self =  [super init];
    if(self){
        [self setupTableView];
        [self setupMapView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setupTableView{
    _tableView                  = [[UITableView alloc]  initWithFrame: CGRectMake(0, 20, 320, HEIGHT_STATUS_BAR)];
    _tableView.tableHeaderView  = [[UIView alloc]       initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, DEFAULT_HEIGHT_HEADER)];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    // Add gesture to gestures
    _tapMapViewGesture      = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(handleTapMapView:)];
    _tapTableViewGesture    = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(handleTapTableView:)];
    [_tableView.tableHeaderView addGestureRecognizer:_tapMapViewGesture];
    [_tableView addGestureRecognizer:_tapTableViewGesture];
    
    // Init selt as default tableview's delegate & datasource
    _tableView.dataSource   = self;
    _tableView.delegate     = self;
    [self.view addSubview:_tableView];
}

-(void)setupMapView{
    _mapView                        = [[MKMapView alloc] initWithFrame:CGRectMake(0, DEFAULT_Y_OFFSET, 320, HEIGHT_STATUS_BAR)];
    [_mapView setShowsUserLocation:YES];
    _mapView.delegate = self;
    [self.view insertSubview:_mapView
                belowSubview: _tableView];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Internal Methods

- (void)handleTapMapView:(UIGestureRecognizer *)gesture {
    if(!self.isShutterOpen)
        [self openShutter];
}

- (void)handleTapTableView:(UIGestureRecognizer *)gesture {
    if(self.isShutterOpen)
        [self closeShutter];
}

// Move DOWN the tableView to show the "entire" mapView
-(void) openShutter{
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.mapView.frame                 = CGRectMake(0, FULL_Y_OFFSET, self.mapView.frame.size.width, self.mapView.frame.size.height);
                         self.tableView.tableHeaderView     = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, MIN_HEIGHT_HEADER)];
                         self.tableView.frame               = CGRectMake(0, Y_DOWN_TABLEVIEW, self.tableView.frame.size.width, self.tableView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         self.isShutterOpen = YES;
                         [self.tableView setScrollEnabled:NO];
                         // Center the user 's location
                         [self zoomToUserLocation:self.mapView.userLocation minLatitude:OPEN_SHUTTER_LATITUDE_MINUS];
                     }];
}

// Move UP the tableView to get its original position
-(void) closeShutter{
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.mapView.frame             = CGRectMake(0, DEFAULT_Y_OFFSET, self.mapView.frame.size.width, self.mapView.frame.size.height);
                         self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, _headerYOffSet, self.view.frame.size.width, DEFAULT_HEIGHT_HEADER)];
                         self.tableView.frame           = CGRectMake(0, 20, self.tableView.frame.size.width, self.tableView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         self.isShutterOpen = NO;
                         [self.tableView setScrollEnabled:YES];
                         [self.tableView.tableHeaderView addGestureRecognizer:_tapMapViewGesture];
                         // Center the user 's location
                         [self zoomToUserLocation:self.mapView.userLocation minLatitude:CLOSE_SHUTTER_LATITUDE_MINUS];
                     }];
}

#pragma mark - Table view Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // check if the Y offset is under the minus Y to reach
    if (self.tableView.contentOffset.y < MIN_Y_OFFSET_TO_REACH){
        if(!self.displayMap)
            self.displayMap                      = YES;
    }else{
        if(self.displayMap)
            self.displayMap                      = NO;
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(self.displayMap)
        [self openShutter];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *identifier;
    if(indexPath.row == 0){
        identifier = @"firstCell";
        // Add some shadow to the first cell
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];

            CGRect shadowFrame      = cell.layer.bounds;
            CGPathRef shadowPath    = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
            cell.layer.shadowPath   = shadowPath;
            [cell.layer setShadowOffset:CGSizeMake(-2, -2)];
            [cell.layer setShadowColor:[[UIColor grayColor] CGColor]];
            [cell.layer setShadowOpacity:.75];
        }
    }
    else{
        identifier = @"otherCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
    }
    [[cell textLabel] setText:@"Hello World !"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //first get total rows in that section by current indexPath.
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];

    //this is the last row in section.
    if(indexPath.row == totalRow -1){
        // get total of cells's Height
        float cellsHeight = totalRow * cell.frame.size.height;
        // calculate tableView's Height with it's the header
        float tableHeight = (tableView.frame.size.height - tableView.tableHeaderView.frame.size.height);

        // Check if we need to create a foot to hide the backView (the map)
        if((cellsHeight - tableView.frame.origin.y)  < tableHeight){
            // Add a footer to hide the background
            int footerHeight = tableHeight - cellsHeight;
            tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, footerHeight)];
            [tableView.tableFooterView setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

#pragma mark - MapView Delegate

- (void)zoomToUserLocation:(MKUserLocation *)userLocation minLatitude:(float)minLatitude
{
    if (!userLocation)
        return;
    MKCoordinateRegion region;
    CLLocationCoordinate2D loc  = userLocation.location.coordinate;
    loc.latitude                = loc.latitude - minLatitude;
    region.center               = loc;
    region.span                 = MKCoordinateSpanMake(.05, .05);       //Zoom distance
    region                      = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region
                   animated:YES];
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(_isShutterOpen)
        [self zoomToUserLocation:self.mapView.userLocation minLatitude:OPEN_SHUTTER_LATITUDE_MINUS];
    else
        [self zoomToUserLocation:self.mapView.userLocation minLatitude:CLOSE_SHUTTER_LATITUDE_MINUS];
}

@end
