//
//  AddproductCondition.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 05/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@interface AddproductCondition : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

{
    //Class declaration
    AppDelegate * delegate;

    //UI Declaration
    IBOutlet UIView *MainView;
    IBOutlet UITableView *ProductconditionTableview;
    
    //Variable Declaration
    NSMutableArray * ConditionTypeArray;

}
@end
