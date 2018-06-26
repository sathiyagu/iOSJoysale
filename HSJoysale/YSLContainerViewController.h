//
//  YSLContainerViewController.h
//  YSLContainerViewController
//
//  Created by yamaguchi on 2015/02/10.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSLContainerViewControllerDelegate <NSObject>

- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller;

@end

@interface YSLContainerViewController : UIViewController
{
    AppDelegate *delegate;
}

@property (retain, nonatomic) id <YSLContainerViewControllerDelegate> delegate;

@property (strong, nonatomic) UIScrollView *contentScrollView;
@property (strong, nonatomic, readonly) NSMutableArray *titles;
@property (strong, nonatomic, readonly) NSMutableArray *childControllers;

@property (strong, nonatomic) UIFont  *menuItemFont;
@property (strong, nonatomic) UIColor *menuItemTitleColor;
@property (strong, nonatomic) UIColor *menuItemSelectedTitleColor;
@property (strong, nonatomic) UIColor *menuBackGroudColor;
@property (strong, nonatomic) UIColor *menuIndicatorColor;

- (id)initWithControllers:(NSArray *)controllers
             topBarHeight:(CGFloat)topBarHeight
     parentViewController:(UIViewController *)parentViewController;

@end
