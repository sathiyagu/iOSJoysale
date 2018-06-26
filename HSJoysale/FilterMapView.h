//
//  FilterMapView.h
//  HSJoysale
//
//  Created by BTMani on 31/03/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class AppDelegate;
@class SPGooglePlacesAutocompleteQuery;

@interface FilterMapView : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    //Class object declaration
    AppDelegate * delegate;
    CLLocationManager * locationManager;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    
    //Variable declaration
    NSMutableArray * choosedDataArray;
    NSArray *searchResultPlaces;

    BOOL regionWillChangeAnimatedCalled;
    
    //UI Declaration
    IBOutlet MKMapView * filterMapView;
    IBOutlet UIImageView * mapPinImageView;
    IBOutlet UILabel * updateLocationLable;
    IBOutlet UIButton * currentLocationButton;
    IBOutlet UIButton * RemoveLocationButton;
    IBOutlet UIButton *LocationBtn;
    IBOutlet UIButton *ResignSearchBarTextBtn;
    IBOutlet UIView *FilterView;
    IBOutlet UIView * autocompleteView;
    IBOutlet UITableView * autocompleteTableView;
    UIView *locationBtnView;
    UISearchBar * searchBarSearchButton;
    UIView *searchbarmainView;
    UIView *searchbarView;
}
- (IBAction)LocationBtnTapped:(id)sender;
- (IBAction)currentLocationBtnTapped:(id)sender;
- (IBAction)RemoveLocationBtnTapped:(id)sender;
- (IBAction)ResignSearchBarTextBtnTapped:(id)sender;
@property (retain, nonatomic) IBOutlet MKMapView *suggetionmapView;

@end
