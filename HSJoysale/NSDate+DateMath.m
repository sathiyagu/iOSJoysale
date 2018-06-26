//
//  NSDate+DateMath.m
//  WueltoApp
//
//  Created by Usuario on 8/11/15.
//  Copyright (c) 2015 BTMANI. All rights reserved.
//

#import "NSDate+DateMath.h"
#import "AppDelegate.h"

@implementation NSDate (DateMath)

+ (NSString *)dateDiff:(NSString *)origDate
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
    NSDate *convertedDate = [df dateFromString:origDate];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    NSLog(@"ti:%f",ti);
    if(ti < 1)
    {
        return [delegate.languageDict objectForKey:@"justnow"];
    }
    else if (ti < 60)
    {
        return [delegate.languageDict objectForKey:@"justnow"];
    }
    else if (ti < 3600)
    {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d %@", diff,[delegate.languageDict objectForKey:@"aminuteago"]];
    }
    else if (ti < 86400)
    {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d %@", diff,[delegate.languageDict objectForKey:@"hoursago"]];
    }
    else if (ti < 2629743)
    {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d %@", diff,[delegate.languageDict objectForKey:@"daysago"]];
    }
    else if (ti < 31556916) {
        int diff = round(ti / 30 / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d %@", diff,[delegate.languageDict objectForKey:@"month ago"]];
    }
    else
    {
        int diff = round(ti / 12 / 30 / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d %@", diff,[delegate.languageDict objectForKey:@"Year ago"]];
    }
    
}

@end
