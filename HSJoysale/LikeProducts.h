//
//  LikeProducts.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 27/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "BLLoader.h"
#import "BLMultiColorLoader.h"
@class AppDelegate;

@interface LikeProducts : UIViewController<UITableViewDataSource,UITableViewDelegate,Wsdl2CodeProxyDelegate>
{
    //class declaration
    ASIFormDataRequest * requestASI;
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;

    //Variable declaration
    NSMutableArray *userIDValue;
    NSMutableArray *likeProductsArray;
    UIRefreshControl * refreshControl;
    NSString *tempUserId;
    BOOL pulltoRefresh;

    //UI declaration
    IBOutlet UIView *MainView;
    IBOutlet UITableView *likedProductTableView;
    UIView *loadingErrorViewBG;
}

@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;
@end