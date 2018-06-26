//
//  YSLScrollMenuView.h
//  YSLContainerViewController
//
//  Created by yamaguchi on 2015/03/03.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSLScrollMenuViewDelegate <NSObject>

- (void)scrollMenuViewSelectedIndex:(NSInteger)index;

@end

@interface YSLScrollMenuView : UIView

@property (retain, nonatomic) id <YSLScrollMenuViewDelegate> delegate;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *itemTitleArray;
@property (strong, nonatomic) NSArray *itemViewArray;

@property (strong, nonatomic) UIColor *viewbackgroudColor;
@property (strong, nonatomic) UIFont *itemfont;
@property (strong, nonatomic) UIColor *itemTitleColor;
@property (strong, nonatomic) UIColor *itemSelectedTitleColor;
@property (strong, nonatomic) UIColor *itemIndicatorColor;

- (void)setShadowView;

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex;

- (void)setItemTextColor:(UIColor *)itemTextColor
    seletedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex;
@end
