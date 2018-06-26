//
//  HSUtility.m
//  HSJoysale
//
//  Created by HiatsoftMac1 on 09/11/17.
//  Copyright © 2017 Hitasoft. All rights reserved.
//

#import "HSUtility.h"

@implementation HSUtility
+(CGFloat)adjustablePadding{
    if (@available(iOS 11.0, *)) {
        return -10;
    }
    else {
        return 0;
    }
    return 0;

    
}
@end
