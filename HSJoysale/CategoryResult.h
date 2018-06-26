//
//  CategoryResult.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 16/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "BLMultiColorLoader.h"

@class AppDelegate;

@interface CategoryResult : UIViewController<Wsdl2CodeProxyDelegate,UIGestureRecognizerDelegate,UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    //Class object declaration
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;
    CHTCollectionViewWaterfallLayout *fallLayout;
    
    //Variable declaration
    NSMutableArray * homePageArray;
    NSMutableArray * filterArray;
    NSDateFormatter * dateFormatter; // Date formater for format unix time stamp to date

    int count;
    float latituted;
    
    //UI Declaration
    IBOutlet UITableView * homePageHeaderTable;
    UIRefreshControl * refreshControl;
    UIScrollView *filterScroll;
    UIView *loadingErrorViewBG;
    UIView *headerview;

    
}
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;
@end
