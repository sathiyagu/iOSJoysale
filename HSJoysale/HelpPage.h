//
//  HelpPage.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 16/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@interface HelpPage : UIViewController<UITableViewDataSource,UITableViewDelegate,Wsdl2CodeProxyDelegate,UIGestureRecognizerDelegate>
{
    //Class Declaration
    AppDelegate * delegate;
    ApiControllerServiceProxy *proxy;

    //UI Declaration
    UITableView *HelpTableView;
    UIView *loadingErrorViewBG;

    //Variable declaration
    NSMutableArray * HelpArray;
}

@end
