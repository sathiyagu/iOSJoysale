//
//  TabViewController.h
//  Hitasoft
//
//  Created by Hitasoft on 05/01/14.
//  Copyright (c) 2014 Hitasoft IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSCustomTabBar.h"
#import "AHKNavigationController.h"
@class AppDelegate;

@interface TabViewController : UIViewController<UITabBarControllerDelegate, UINavigationControllerDelegate>
{
    //Class Declaration
    AppDelegate *delegate;

    //declare navigation
    AHKNavigationController *homeNavi;
    AHKNavigationController *CategoryNavi;
    AHKNavigationController *addProductNavi;
    AHKNavigationController *notificationNavi;
    AHKNavigationController *profileNavi;
}

-(void) poptoHomeNavi;
-(void) poptoCategoryNavi;
//-(void) poptoMessageNavi;
-(void) poptoProfileNavi;
@property (nonatomic, retain) IBOutlet HTSCustomTabBar *tabBarController;

@end
