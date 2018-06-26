//
//  advancesearchMapView.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 13/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class AppDelegate;
@class SPGooglePlacesAutocompleteQuery;

@interface advancesearchMapView : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    //Class Declaration
    AppDelegate * delegate;
    CLLocationManager * locationManager;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    
    //Variable Declaration
    NSMutableArray * choosedDataArray;
    NSArray *searchResultPlaces;
    
    BOOL regionWillChangeAnimatedCalled;
    
    IBOutlet MKMapView * filterMapView;
    IBOutlet UIImageView * mapPinImageView;
    IBOutlet UILabel * updateLocationLable;
    IBOutlet UIButton * currentLocationButton;
    IBOutlet UIButton * RemoveLocationButton;
    IBOutlet UIButton *LocationBtn;
    IBOutlet UIView *FilterView;
    IBOutlet UIView * autocompleteView;
    IBOutlet UITableView * autocompleteTableView;
    IBOutlet UIButton *ResignSearchBarTextBtn;
    
    UIView *locationBtnView;
    UISearchBar * searchBarSearchButton;
    UIView *searchbarmainView;
    UIView *searchbarView;
}
- (IBAction)LocationBtnTapped:(id)sender;
- (IBAction)currentLocationBtnTapped:(id)sender;
- (IBAction)RemoveLocationBtnTapped:(id)sender;
- (IBAction)ResignSearchBarTextBtnTapped:(id)sender;

@property (retain, nonatomic) IBOutlet MKMapView *locationmapView;
@end
