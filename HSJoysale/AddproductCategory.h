//
//  AddproductCategory.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 04/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@interface AddproductCategory : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    //Class declaration
    AppDelegate * delegate;
    
    //UI Declaration
    IBOutlet UIView *MainView;
    IBOutlet UITableView *CategoryTableview;
    IBOutlet UITableView *subCategoryTableView;
    
    //Variable Declaration
    NSMutableArray * subcategoryArray;

}
@end
