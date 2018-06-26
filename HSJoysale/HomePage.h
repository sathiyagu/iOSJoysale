//
//  HomePage.h
//  HSJoysale
//
//  Created by BTMANI on 01/09/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UINavigationBar+Helper.h"
#import "ASIFormDataRequest.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "GridView.h"
#import "SMPageControl.h"
#import "BLMultiColorLoader.h"
#import "JOLImageSlider.h"

@class AppDelegate;
@interface HomePage : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, Wsdl2CodeProxyDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, UIGestureRecognizerDelegate, UIScrollViewDelegate, JOLImageSliderDelegate>
{
    //ClassDeclaration
    AppDelegate * delegate; //Access Appdelegate Datas
    ApiControllerServiceProxy *proxy;
    CHTCollectionViewWaterfallLayout *fallLayout; //for collectionView
    CLLocationManager * locationManager;
    JOLImageSlider *imageSlider;
    
    BOOL homeCategorySearchEnable;

    //UI Declaration
    IBOutlet UITableView * homePageHeaderTable; // to Show Selected or currentLocation
    IBOutlet UITableView * homeTableview; // to Show Selected or currentLocation
    UILabel *noitemLbl;  // Its used to display home page list
    UIScrollView *filterScroll;
    UIButton *searchbarBtn; // Navigation Search button
    UIView *loadingErrorViewBG; // No Data Alert view
    UIView *headerview;
    
    //Its used to store refresh control datas
    UIRefreshControl * refreshControl;
    UIRefreshControl * bottomrefreshControl;
    
    //Variable declaration
    NSDateFormatter * dateFormatter; // Date formater for format unix time stamp to date
    NSMutableArray * filterArray;  // For Filter Selection
    NSMutableArray * homePageArray; // Its used to store home page datas
    
    int count; // for filter scroll
    float latituted;
    
    UIScrollView * bannerScrollView;
    UIScrollView * categoryScrollView;
    CHTCollectionViewWaterfallLayout *layout;
    BOOL isBannerEnable;
    
    BOOL taptouch;
    
}
/**
 To parse advance search datas in the home page
 */
-(void) searchDatasparsing;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;


@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;


@end

