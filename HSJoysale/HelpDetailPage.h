//
//  HelpDetailPage.h
//  HSJoysale
//
//  Created by HiatsoftMac1 on 29/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpDetailPage : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate>{
    //Class Declaration
    AppDelegate * delegate;
    
    //Variable declaration
    NSMutableArray * helpContent;
    
    UIWebView *detailWebView;

    
    //UI Declaration
    IBOutlet UIView *mainView;
    IBOutlet UITableView *helpDetailTableview;
}
-(void)loadcontent:(NSMutableArray *)helpcontent;
@end
