//
//  CategoryTab.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 27/05/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
@class AppDelegate;

@interface CategoryTab : UIViewController<UITableViewDataSource,UITableViewDelegate,Wsdl2CodeProxyDelegate,UIGestureRecognizerDelegate>
{
    //Class object declaration
    AppDelegate * delegate;
    ASIFormDataRequest * requestASI;
    
    //Variable declaration
    NSMutableArray * categorPageArray;
    
    //UI Declaration
    IBOutlet UITableView * categoryTable;
    UIView *loadingErrorViewBG;
}

@end
