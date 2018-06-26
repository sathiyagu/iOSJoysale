//
//  CGSuggestionSizeMake.m
//  HSJoysale
//
//  Created by BTMANI on 05/09/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import "CGSuggestionSizeMake.h"

@implementation CGSuggestionSizeMake
-(CGSize) lableSuggetionSize:(NSString *) suggetionLableText font:(UIFont*) font lableWidth:(float) lableWidth lableHeight:(float)lableHeight
{
    CGSize suggetionSize;
    if (isAboveiOSVersion7) {
        NSDictionary *attributes = @{NSFontAttributeName: font};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect productrect = [suggetionLableText boundingRectWithSize:CGSizeMake(lableWidth,lableHeight)
                                                                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                                                                     attributes:attributes
                                                                                                                        context:nil];
        suggetionSize = CGSizeMake(productrect.size.width, productrect.size.height);
    }
    else
    {
        suggetionSize =[suggetionLableText sizeWithFont:font constrainedToSize:CGSizeMake(lableWidth,lableHeight) lineBreakMode:NSLineBreakByWordWrapping];
        
        
    }
    
    return suggetionSize;
}
@end
