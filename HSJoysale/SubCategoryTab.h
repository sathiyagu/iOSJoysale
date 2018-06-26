//
//  SubCategoryTab.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 27/05/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface SubCategoryTab : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    //Class object declaration
    AppDelegate * delegate;

    //UI Declaration
    IBOutlet UITableView * categoryTable;
}

@end
