//
//  RuntimeAttributes.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 20/08/16.
//  Copyright © 2016 Hitasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuntimeAttributes.h"

@implementation CALayer (IBConfiguration)

-(void)setBorderColorIB:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderColorIB
{
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setShadowColorIB:(UIColor*)color
{
    self.shadowColor = color.CGColor;
}

-(UIColor*)shadowColorIB
{
    return [UIColor colorWithCGColor:self.shadowColor];
}

@end
