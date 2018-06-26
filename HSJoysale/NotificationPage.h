//
//  NotificationPage.h
//  HSJoysale
//
//  Created by BTMANI on 16/09/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLoader.h"
#import "BLMultiColorLoader.h"

@interface NotificationPage : UIViewController<UITableViewDataSource,UITableViewDelegate,Wsdl2CodeProxyDelegate,UIGestureRecognizerDelegate>
{
    //Class Declaration
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;
    
    //UI Declaration
    IBOutlet UITableView * notificationTable;
    UIView *loadingErrorViewBG;
    UIRefreshControl * refreshControl;

    //Variable Declaration
    NSMutableArray * notificationArray;
    NSMutableArray * itemDetailArray;
    BOOL activeSelect;
}
@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;

@end
