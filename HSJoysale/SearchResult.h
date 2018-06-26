//
//  SearchResult.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 15/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "BLMultiColorLoader.h"

@class AppDelegate;

@interface SearchResult : UIViewController<UISearchBarDelegate,Wsdl2CodeProxyDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    //Class object declaration
    ApiControllerServiceProxy *proxy;
    AppDelegate * delegate;
    
    //Variable declaration
    NSMutableArray * advanceSearchArray;
    NSMutableArray * homePageArray;
    NSDateFormatter * dateFormatter; // Date formater for format unix time stamp to date
    
    UITableView * searchHistoryTable;
    
    //UI Declaration
    IBOutlet UISearchBar *SearchBar;
    IBOutlet UIView *navigationView;
    IBOutlet UILabel *searchLable;
    IBOutlet UIButton *ResetBtn;
    IBOutlet UIButton *CancelBtn;
    IBOutlet UIButton *ResignSearchBarTextBtn;
    UIView *loadingErrorViewBG;
    UIRefreshControl * refreshControl;
    
}
- (IBAction)ResetBtnTapped:(id)sender;
- (IBAction)CancelBtnTapped:(id)sender;
- (IBAction)ResignSearchBarTextBtnTapped:(id)sender;

@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;
@end


