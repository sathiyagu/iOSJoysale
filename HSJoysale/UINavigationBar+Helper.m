//
//  UINavigationBar+Helper.m
//  HSJoysale
//
//  Created by BTMani on 25/07/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import "UINavigationBar+Helper.h"

@implementation UINavigationBar (Helper)

- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height {
    CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), height);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:bottomBorderRect];
    [bottomBorder setBackgroundColor:color];
    [self addSubview:bottomBorder];
}
@end
