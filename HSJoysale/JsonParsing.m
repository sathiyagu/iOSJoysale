//
//  JsonParsing.m
//  HSJoysale
//
//  Created by BTMANI on 06/09/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import "JsonParsing.h"
#import "DefensiveClass.h"
#import "JSON.h"
#import "SBJson.h"
#import "AppDelegate.h"

@implementation JsonParsing

-(NSMutableDictionary *) languagedata:(NSURL*)url
{
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    NSMutableDictionary *value = [[[NSMutableDictionary alloc]init]autorelease];
    
    if ([delegate connectedToNetwork])
    {
        
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *errorReq = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&errorReq];
        if (!errorReq)
        {
            NSString *encoded = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            [value addEntriesFromDictionary:[encoded JSONValue]];
            [encoded release];
        }
        else
        {
        }
        
    }
    
    
    return value;
}
@end
