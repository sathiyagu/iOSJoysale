//
//  FilterSubcategory.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 13/06/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSubcategory : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    //Class Declaration
    AppDelegate * delegate;
    
    //UI Declaration
    IBOutlet UITableView * categoryTable;
    
}
@end
