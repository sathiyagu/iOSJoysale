//
//  following.h
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

@interface following : UIViewController<UITableViewDataSource,UITableViewDelegate,Wsdl2CodeProxyDelegate>
{
    //Class Declaration
    ASIFormDataRequest * requestASI;
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;
    UIRefreshControl * refreshControl;

    //variable Declaration
    NSMutableArray *userIDValue;
    NSMutableArray *followingArray;
    NSMutableArray *sampleArray;
    NSMutableArray *jsonDict;
    NSString *localUserId;
    BOOL pulltoRefresh;
 
    //UI Declaration
    IBOutlet UIView *mainView;
    IBOutlet UITableView *followingTableView;
    UIView *loadingErrorViewBG;
}
@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;

@end
