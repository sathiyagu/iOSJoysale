//
//  LanguagePage.h
//  HSJoysale
//
//  Created by HitasoftMac2 on 12/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@interface LanguagePage : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,Wsdl2CodeProxyDelegate>
{
    AppDelegate * delegate;
    
    IBOutlet UIView *MainView;
    IBOutlet UITableView *LanguageTableView;
    
    NSMutableArray *LanguageArray;
}

@end
