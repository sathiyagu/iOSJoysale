//
//  Followers.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 27/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "BLLoader.h"
#import "BLMultiColorLoader.h"

@class AppDelegate;

@interface Followers : UIViewController<UITableViewDataSource,UITableViewDelegate,Wsdl2CodeProxyDelegate>
{
    //Class Declaration
    ASIFormDataRequest * requestASI;
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;
    UIRefreshControl * refreshControl;

    //Variable declaration
    NSMutableArray *jsonDict;
    NSMutableArray *userIDValue;
    NSMutableArray *followersArray;
    NSMutableArray *sampleArray;
    NSString *localUserIDStr;
    BOOL pulltoRefresh;

    //UI Declaration
    IBOutlet UIView *mainView;
    IBOutlet UITableView *followerTableView;
    UIView *loadingErrorViewBG;
}

@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;

@end
