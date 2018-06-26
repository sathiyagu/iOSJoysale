//
//  MyListingPage.h
//  HSJoysale
//
//  Created by BTMani on 23/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "BLLoader.h"
#import "BLMultiColorLoader.h"

@class AppDelegate;

@interface MyListingPage : UIViewController<UITableViewDataSource,UITableViewDelegate,Wsdl2CodeProxyDelegate>
{
    //Class Declaration
    ASIFormDataRequest * requestASI;
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;
    UIRefreshControl * refreshControl;

    //Variable declaration
    NSMutableArray *userIDValue;
    NSMutableArray *mylistingArray;
    NSString *tempUserId;
    BOOL pulltoRefresh;
        
    //UI Declaration
    IBOutlet UIView *MainView;
    IBOutlet UITableView *listProductTableView;
    UIView *loadingErrorViewBG;

}

@property (retain, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;

@end
