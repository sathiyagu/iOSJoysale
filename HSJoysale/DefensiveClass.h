//
//  DefensiveClass.h
//  HSJoysale
//
//  Created by BTMANI on 06/09/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefensiveClass : NSObject
- (NSMutableDictionary *) testingHomePageData:(NSMutableDictionary *)homePageDictionary;
- (NSMutableDictionary *) testingMessagePageData:(NSMutableDictionary *)homePageDictionary;
-(NSMutableDictionary *) mycategoryArrayTesting:(NSMutableDictionary *)myorderpageDict;
-(NSMutableDictionary *) myExchageTesting:(NSMutableDictionary *)catogorypageDict;
- (NSMutableDictionary *) notificationPageData:(NSMutableDictionary *)notificationPageDictionary;
- (NSMutableDictionary *) helpPageData:(NSMutableDictionary *)helpPageDictionary;

-(NSMutableArray *) followPageData:(NSMutableArray *)followDict;
-(NSMutableArray *) profileParsing:(NSMutableArray *)profileArray;
- (NSMutableDictionary *) addressParsing:(NSMutableDictionary *)addressDict;
- (NSMutableDictionary *) myorderParsing:(NSMutableDictionary *)myorderDict;
- (NSMutableDictionary *) mysaleParsing:(NSMutableDictionary *)mysaleDict;
- (NSMutableDictionary *) myreviewPasrsing:(NSMutableDictionary *)myreviewDict;
@end
