//
//  DefensiveClass.m
//  HSJoysale
//
//  Created by BTMANI on 06/09/14.
//  Copyright (c) 2014 BTMANI. All rights reserved.
//

#import "DefensiveClass.h"
#define SET_IF_NOT_NULL(TARGET, VAL) if(VAL != [NSNull null]&&VAL!=nil) { TARGET = VAL; } else{TARGET=@"Json Error";}

#define SET_IF_NOT_NULLCurrencyValue(TARGET, VAL) if(VAL != [NSNull null]&&VAL!=nil) { TARGET = VAL; } else{TARGET=@"$";}

#define SET_IF_NOT_NULLIntegerValue(TARGET, VAL) if(VAL != [NSNull null]&&VAL!=nil) { TARGET = VAL; } else{TARGET=@"0";}

#define SET_IF_NOT_NULLheightValue(TARGET, VAL) if(VAL != [NSNull null]&&VAL!=nil) { TARGET = VAL; } else{TARGET=@"100";}



@implementation DefensiveClass

- (NSMutableDictionary *) testingFollowingData:(NSMutableDictionary *)homePageDictionary
{
    NSMutableDictionary * testedHomePageDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    
    
    NSMutableArray * goingToTestedArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    if ([homePageDictionary objectForKey:@"result"]!=nil&&[homePageDictionary objectForKey:@"result"]!=[NSNull null])
    {
        [goingToTestedArray addObjectsFromArray:[homePageDictionary objectForKey:@"result"]];
        for (int i=0;i<[goingToTestedArray count];i++)
        {
            
            
        }
        [testedHomePageDict setObject:@"true" forKey:@"status"];
    }
    else
    {
        [testedHomePageDict setObject:@"false" forKey:@"status"];
  
    }
    //[items setObject:[self testFollowingData:goingToTestedArray] forKey:@"result"];
    [testedHomePageDict setObject:[self testFollowingData:goingToTestedArray] forKey:@"result"];
    
    return testedHomePageDict;

}

- (NSMutableDictionary *) testingHomePageData:(NSMutableDictionary *)homePageDictionary
{
    NSMutableDictionary * testedHomePageDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSMutableDictionary * items = [[NSMutableDictionary alloc]initWithCapacity:0];


    
    NSMutableArray * goingToTestedArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    if ([homePageDictionary objectForKey:@"result"]!=nil&&[homePageDictionary objectForKey:@"result"]!=[NSNull null])
    {
        if ([[[homePageDictionary objectForKey:@"result"]objectForKey:@"items"]isKindOfClass:ArrayClass])
        {
            [goingToTestedArray addObjectsFromArray:[[homePageDictionary objectForKey:@"result"]objectForKey:@"items"]];
            for (int i=0;i<[goingToTestedArray count];i++)
            {
               
                
            }
            [testedHomePageDict setObject:@"true" forKey:@"status"];

        }
        [testedHomePageDict setObject:@"true" forKey:@"status"];

    }
    else
    {
        [testedHomePageDict setObject:@"false" forKey:@"status"];

    }
    [items setObject:[self testTheGridDataForAllFunction:goingToTestedArray] forKey:@"items"];
    [testedHomePageDict setObject:items forKey:@"result"];
    
    return testedHomePageDict;
}
-(NSMutableArray*) testFollowingData:(NSMutableArray*) homeGridArray
{
    NSMutableArray * testedHomePageArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    NSMutableArray * homeGridtestingArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    [homeGridtestingArray addObjectsFromArray:homeGridArray];
    for (int i=0; i<[homeGridtestingArray count]; i++)
    {
        
        
        NSMutableDictionary * homeGridDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * idStr = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"user_id"];
        SET_IF_NOT_NULL(idStr,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"user_id"]);
        
        NSString * userImageStr = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"user_image"];
        SET_IF_NOT_NULL(userImageStr,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"user_image"]);
        
        NSString * statusStr = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"status"];
        SET_IF_NOT_NULL(statusStr,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"status"]);
        
        NSString * user_nameStr = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"user_name"];
        SET_IF_NOT_NULL(user_nameStr,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"user_name"]);
        
        NSString * full_nameStr = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"full_name"];
        SET_IF_NOT_NULL(full_nameStr,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"full_name"]);
        
        
        [homeGridDictionary setObject:idStr forKey:@"user_id"];
        [homeGridDictionary setObject:userImageStr forKey:@"user_image"];
        [homeGridDictionary setObject:statusStr forKey:@"status"];
        [homeGridDictionary setObject:user_nameStr forKey:@"user_name"];
        [homeGridDictionary setObject:full_nameStr forKey:@"full_name"];
        
        [testedHomePageArray addObject:homeGridDictionary];
    }
    return testedHomePageArray;


}
-(NSMutableArray*) testTheGridDataForAllFunction:(NSMutableArray*) homeGridArray
{
    NSMutableArray * testedHomePageArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    NSMutableArray * homeGridtestingArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    [homeGridtestingArray addObjectsFromArray:homeGridArray];
    for (int i=0; i<[homeGridtestingArray count]; i++)
    {
        
        
        NSMutableDictionary * homeGridDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        NSString * idStr = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"id"];
        SET_IF_NOT_NULL(idStr,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"id"]);
        
        NSString * item_title = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"item_title"];
        SET_IF_NOT_NULL(item_title,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"item_title"]);
        
        NSString * item_description = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"item_description"];
        SET_IF_NOT_NULL(item_description,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"item_description"]);
        
        NSString * item_condition = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"item_condition"];
        SET_IF_NOT_NULL(item_condition,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"item_condition"]);
        
        NSString * shipping_time = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"shipping_time"];
        SET_IF_NOT_NULL(shipping_time,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"shipping_time"]);
        
        NSString * item_approve  = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"item_approve"];
        SET_IF_NOT_NULL(item_approve,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"item_approve"]);

        NSString * seller_rating  = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"seller_rating"];
        SET_IF_NOT_NULL(seller_rating,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"seller_rating"]);

        
        //shipping_time
        
        NSString * report = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"report"];
        SET_IF_NOT_NULL(report,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"report"]);
        
        
        NSString * location = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"location"];
        SET_IF_NOT_NULL(location,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"location"]);
        
        NSString * price = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"price"];
        SET_IF_NOT_NULL(price,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"price"]);
        
        
        
        NSString * quantity = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"quantity"];
        SET_IF_NOT_NULL(quantity,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"quantity"]);
        
        NSString * size = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"size"];
        SET_IF_NOT_NULL(size,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"size"]);
        
        NSString * seller_name = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"seller_name"];
        SET_IF_NOT_NULL(seller_name,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"seller_name"]);
        
        NSString * seller_id = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"seller_id"];
        SET_IF_NOT_NULL(seller_id,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"seller_id"]);
        
        NSString * seller_img = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"seller_img"];
        SET_IF_NOT_NULL(seller_img,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"seller_img"]);
        
        NSString * currency_code = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"currency_code"];
        SET_IF_NOT_NULL(currency_code,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"currency_code"]);
        
        NSString * product_url = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"product_url"];
        SET_IF_NOT_NULL(product_url,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"product_url"]);
        
        NSString * likes_count = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"likes_count"];
        SET_IF_NOT_NULL(likes_count,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"likes_count"]);
        
        
        NSString * comments_count = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"comments_count"];
        SET_IF_NOT_NULL(comments_count,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"comments_count"]);
        
        NSString * views_count = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"views_count"];
        SET_IF_NOT_NULL(views_count,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"views_count"]);
        
        NSString * liked = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"liked"];
        SET_IF_NOT_NULL(liked,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"liked"]);
        
        NSString * posted_time = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"posted_time"];
        SET_IF_NOT_NULL(posted_time,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"posted_time"]);
        
        NSString * latitude = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"latitude"];
        SET_IF_NOT_NULL(latitude,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"latitude"]);
        
        NSString * longitude = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"longitude"];
        SET_IF_NOT_NULL(longitude,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"longitude"]);
        
        NSString * best_offer = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"best_offer"];
        SET_IF_NOT_NULL(best_offer,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"best_offer"]);
        
        NSString * buy_type = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"buy_type"];
        SET_IF_NOT_NULL(buy_type,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"buy_type"]);
        
        NSString * paypal_id = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"paypal_id"];
        SET_IF_NOT_NULL(paypal_id,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"paypal_id"]);
        
        NSString * instant_buy = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"instant_buy"];
        SET_IF_NOT_NULL(instant_buy,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"instant_buy"]);
        
        NSString * country_id = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"country_id"];
        SET_IF_NOT_NULL(country_id,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"country_id"]);
        
        NSString * shipping_cost = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"shipping_cost"];
        SET_IF_NOT_NULL(shipping_cost,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"shipping_cost"]);
        
        NSMutableArray * photos = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
        
        if ([[[homeGridtestingArray objectAtIndex:i]objectForKey:@"photos"]isKindOfClass:ArrayClass])
        {
            [photos addObjectsFromArray:[[homeGridtestingArray objectAtIndex:i]objectForKey:@"photos"]];
        }
        NSMutableArray * shipping_detail = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
        if ([[[homeGridtestingArray objectAtIndex:i]objectForKey:@"photos"]isKindOfClass:ArrayClass])
        {
            [shipping_detail addObjectsFromArray:[[homeGridtestingArray objectAtIndex:i]objectForKey:@"shipping_detail"]];
        }
        
        
        
        NSString * item_status = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"item_status"];
        SET_IF_NOT_NULL(item_status,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"item_status"]);
        
        NSString * category_id = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"category_id"];
        SET_IF_NOT_NULL(category_id,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"category_id"]);
        NSString * category_name = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"category_name"];
        SET_IF_NOT_NULL(category_name,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"category_name"]);
        NSString * subcat_id = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"subcat_id"];
        SET_IF_NOT_NULL(subcat_id,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"subcat_id"]);
        NSString * subcat_name = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"subcat_name"];
        SET_IF_NOT_NULL(subcat_name,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"subcat_name"]);
        
        NSString * email_verification = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"email_verification"];
        SET_IF_NOT_NULL(email_verification,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"email_verification"]);
        
        NSString * facebook_verification = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"facebook_verification"];
        SET_IF_NOT_NULL(facebook_verification,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"facebook_verification"]);
        
        NSString * mobile_verification = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"mobile_verification"];
        SET_IF_NOT_NULL(mobile_verification,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"mobile_verification"]);
        
        NSString * exchange_buy = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"exchange_buy"];
        SET_IF_NOT_NULL(exchange_buy,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"exchange_buy"]);
        
        NSString * promotion_type = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"promotion_type"];
        SET_IF_NOT_NULL(promotion_type,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"promotion_type"]);
        
        NSString * seller_username = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"seller_username"];
        SET_IF_NOT_NULL(seller_username,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"seller_username"]);
        
        NSString * make_offer = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"make_offer"];
        SET_IF_NOT_NULL(make_offer,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"make_offer"]);
        
        NSString * mobile_no = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"mobile_no"];
        SET_IF_NOT_NULL(mobile_no,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"mobile_no"]);
        
        NSString * show_seller_mobile = [[homeGridtestingArray objectAtIndex:i]objectForKey:@"show_seller_mobile"];
        SET_IF_NOT_NULL(show_seller_mobile,[[homeGridtestingArray objectAtIndex:i]objectForKey:@"show_seller_mobile"]);

        
        [homeGridDictionary setObject:idStr forKey:@"id"];
        [homeGridDictionary setObject:item_title forKey:@"item_title"];
        [homeGridDictionary setObject:liked forKey:@"liked"];
        [homeGridDictionary setObject:item_description forKey:@"item_description"];
        [homeGridDictionary setObject:item_approve forKey:@"item_approve"];
        [homeGridDictionary setObject:seller_rating forKey:@"seller_rating"];
        [homeGridDictionary setObject:item_condition forKey:@"item_condition"];
        [homeGridDictionary setObject:shipping_time forKey:@"shipping_time"];
        [homeGridDictionary setObject:report forKey:@"report"];
        [homeGridDictionary setObject:price forKey:@"price"];
        [homeGridDictionary setObject:quantity forKey:@"quantity"];
        [homeGridDictionary setObject:location forKey:@"location"];
        [homeGridDictionary setObject:size forKey:@"size"];
        [homeGridDictionary setObject:seller_name forKey:@"seller_name"];
        [homeGridDictionary setObject:seller_id forKey:@"seller_id"];
        [homeGridDictionary setObject:seller_img forKey:@"seller_img"];
        [homeGridDictionary setObject:currency_code forKey:@"currency_code"];
        [homeGridDictionary setObject:product_url forKey:@"product_url"];
        [homeGridDictionary setObject:likes_count forKey:@"likes_count"];
        [homeGridDictionary setObject:comments_count forKey:@"comments_count"];
        [homeGridDictionary setObject:views_count forKey:@"views_count"];
        [homeGridDictionary setObject:posted_time forKey:@"posted_time"];
        [homeGridDictionary setObject:latitude forKey:@"latitude"];
        [homeGridDictionary setObject:longitude forKey:@"longitude"];
        [homeGridDictionary setObject:best_offer forKey:@"best_offer"];
        [homeGridDictionary setObject:buy_type forKey:@"buy_type"];
        [homeGridDictionary setObject:instant_buy forKey:@"instant_buy"];
        [homeGridDictionary setObject:country_id forKey:@"country_id"];
        [homeGridDictionary setObject:shipping_cost forKey:@"shipping_cost"];
        [homeGridDictionary setObject:photos forKey:@"photos"];
        [homeGridDictionary setObject:paypal_id forKey:@"paypal_id"];
        [homeGridDictionary setObject:category_id forKey:@"category_id"];
        [homeGridDictionary setObject:category_name forKey:@"category_name"];
        [homeGridDictionary setObject:subcat_id forKey:@"subcat_id"];
        [homeGridDictionary setObject:subcat_name forKey:@"subcat_name"];
        [homeGridDictionary setObject:item_status forKey:@"item_status"];
        [homeGridDictionary setObject:shipping_detail forKey:@"shipping_detail"];
        [homeGridDictionary setObject:email_verification forKey:@"email_verification"];
        [homeGridDictionary setObject:facebook_verification forKey:@"facebook_verification"];
        [homeGridDictionary setObject:mobile_verification forKey:@"mobile_verification"];
        [homeGridDictionary setObject:exchange_buy forKey:@"exchange_buy"];
        [homeGridDictionary setObject:promotion_type forKey:@"promotion_type"];
        [homeGridDictionary setObject:seller_username forKey:@"seller_username"];
        [homeGridDictionary setObject:make_offer forKey:@"make_offer"];
        [homeGridDictionary setObject:mobile_no forKey:@"mobile_no"];
        [homeGridDictionary setObject:show_seller_mobile forKey:@"show_seller_mobile"];

        [testedHomePageArray addObject:homeGridDictionary];
    }
    return testedHomePageArray;
}

- (NSMutableDictionary *) testingMessagePageData:(NSMutableDictionary *)messagePageDictionary
{
    NSMutableDictionary * testedMessagePageDict = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    if ([[messagePageDictionary objectForKey:@"status"]isEqualToString:@"true"])
    {
        [testedMessagePageDict setObject:@"true" forKey:@"status"];
        if ([messagePageDictionary objectForKey:@"result"]==NULL||[messagePageDictionary objectForKey:@"result"]==[NSNull null])
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your Data is corrupted" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            NSMutableArray * goingtotestArray = [[[NSMutableArray alloc]init]autorelease];
            [goingtotestArray addObjectsFromArray:[messagePageDictionary objectForKey:@"result"]];
            NSMutableArray * messagesArray = [[[NSMutableArray alloc]init]autorelease];
            for (int i=0; i<[goingtotestArray count]; i++)
            {
                
                NSMutableDictionary * messagesDict = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];

                NSString * message_id = [[goingtotestArray objectAtIndex:i]objectForKey:@"message_id"];
                SET_IF_NOT_NULL(message_id,[[goingtotestArray objectAtIndex:i]objectForKey:@"message_id"]);

                NSString * user_image = [[goingtotestArray objectAtIndex:i]objectForKey:@"user_image"];
                SET_IF_NOT_NULL(user_image,[[goingtotestArray objectAtIndex:i]objectForKey:@"user_image"]);
                
                NSString * message = [[goingtotestArray objectAtIndex:i]objectForKey:@"message"];
                SET_IF_NOT_NULL(message,[[goingtotestArray objectAtIndex:i]objectForKey:@"message"]);


                NSString * user_name = [[goingtotestArray objectAtIndex:i]objectForKey:@"user_name"];
                SET_IF_NOT_NULL(user_name,[[goingtotestArray objectAtIndex:i]objectForKey:@"user_name"]);

                NSString * full_name = [[goingtotestArray objectAtIndex:i]objectForKey:@"full_name"];
                SET_IF_NOT_NULL(full_name,[[goingtotestArray objectAtIndex:i]objectForKey:@"full_name"]);

                NSString * message_time = [[goingtotestArray objectAtIndex:i]objectForKey:@"message_time"];
                SET_IF_NOT_NULL(message_time,[[goingtotestArray objectAtIndex:i]objectForKey:@"message_time"]);
                
                NSString * last_repliedto = [[goingtotestArray objectAtIndex:i]objectForKey:@"last_repliedto"];
                SET_IF_NOT_NULL(last_repliedto,[[goingtotestArray objectAtIndex:i]objectForKey:@"last_repliedto"]);
                
                NSString * user_id = [[goingtotestArray objectAtIndex:i]objectForKey:@"user_id"];
                SET_IF_NOT_NULL(user_id,[[goingtotestArray objectAtIndex:i]objectForKey:@"user_id"]);
                
                [messagesDict setObject:user_id forKey:@"user_id"];
                [messagesDict setObject:last_repliedto forKey:@"last_repliedto"];
                [messagesDict setObject:message_id forKey:@"message_id"];
                [messagesDict setObject:user_image forKey:@"user_image"];
                [messagesDict setObject:message forKey:@"message"];
                [messagesDict setObject:user_name forKey:@"user_name"];
                [messagesDict setObject:message_time forKey:@"message_time"];
                [messagesDict setObject:full_name forKey:@"full_name"];
                if(![message isEqualToString:@""]){[messagesArray addObject:messagesDict];}
                
            }
            NSMutableDictionary * resultDict = [[[NSMutableDictionary alloc]init]autorelease];
            [resultDict setObject:messagesArray forKey:@"message"];
            [testedMessagePageDict setObject:resultDict forKey:@"result"];
        }
        
        
    }
    
    return testedMessagePageDict;
}




-(NSMutableDictionary *) mycategoryArrayTesting:(NSMutableDictionary *)catogorypageDict
{
    NSMutableDictionary * testedCategoryDictionary = [[[NSMutableDictionary alloc]init]autorelease];
    
    NSMutableArray * goingToTestedArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    if ([catogorypageDict objectForKey:@"result"]!=nil&&[catogorypageDict objectForKey:@"result"]!=[NSNull null])
    {
        if ([[[catogorypageDict objectForKey:@"result"]objectForKey:@"category"]isKindOfClass:ArrayClass])
        {
            [goingToTestedArray addObjectsFromArray:[[catogorypageDict objectForKey:@"result"]objectForKey:@"category"]];
        }
    }
    
    
    NSMutableArray * categoryArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    for (int i=0;i<[goingToTestedArray count]; i++)
    {
        NSMutableDictionary * categoryInnerDict = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        NSString * category_id = [[goingToTestedArray objectAtIndex:i]objectForKey:@"category_id"];
        SET_IF_NOT_NULLIntegerValue(category_id, [[goingToTestedArray objectAtIndex:i]objectForKey:@"category_id"]);
        
        NSString * category_name = [[goingToTestedArray objectAtIndex:i]objectForKey:@"category_name"];
        SET_IF_NOT_NULLIntegerValue(category_name, [[goingToTestedArray objectAtIndex:i]objectForKey:@"category_name"]);

        
        NSString * category_img = [[goingToTestedArray objectAtIndex:i]objectForKey:@"category_img"];
        SET_IF_NOT_NULLIntegerValue(category_img, [[goingToTestedArray objectAtIndex:i]objectForKey:@"category_img"]);


        [categoryInnerDict setObject:category_id forKey:@"category_id"];
        [categoryInnerDict setObject:category_name forKey:@"category_name"];
        [categoryInnerDict setObject:category_img forKey:@"category_img"];
        [categoryArray addObject:categoryInnerDict];
    }
    NSMutableDictionary * resultDict = [[[NSMutableDictionary alloc]init]autorelease];
    [resultDict setObject:categoryArray forKey:@"category"];
    [testedCategoryDictionary setObject:resultDict forKey:@"result"];
    return testedCategoryDictionary;
}



-(NSMutableDictionary *) myExchageTesting:(NSMutableDictionary *)catogorypageDict
{
    NSMutableDictionary * testedCategoryDictionary = [[[NSMutableDictionary alloc]init]autorelease];
    
    NSMutableArray * goingToTestedArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    if ([catogorypageDict objectForKey:@"result"]!=nil&&[catogorypageDict objectForKey:@"result"]!=[NSNull null])
    {
        if ([[[catogorypageDict objectForKey:@"result"]objectForKey:@"exchange"]isKindOfClass:ArrayClass])
        {
            [goingToTestedArray addObjectsFromArray:[[catogorypageDict objectForKey:@"result"]objectForKey:@"exchange"]];
        }
    }
        
    NSMutableArray * exchangeArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    for (int i=0;i<[goingToTestedArray count]; i++)
    {
        NSMutableDictionary * exchangeInnerDict = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        NSString * exchange_id = [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchange_id"];
        SET_IF_NOT_NULLIntegerValue(exchange_id, [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchange_id"]);
        
        NSString * request_by_me = [[goingToTestedArray objectAtIndex:i]objectForKey:@"request_by_me"];
        SET_IF_NOT_NULLIntegerValue(request_by_me, [[goingToTestedArray objectAtIndex:i]objectForKey:@"request_by_me"]);
        
        
        NSString * status = [[goingToTestedArray objectAtIndex:i]objectForKey:@"status"];
        SET_IF_NOT_NULLIntegerValue(status, [[goingToTestedArray objectAtIndex:i]objectForKey:@"status"]);
        
        NSString * exchange_time = [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchange_time"];
        SET_IF_NOT_NULLIntegerValue(exchange_time, [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchange_time"]);

        
        NSString * exchanger_id = [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchanger_id"];
        SET_IF_NOT_NULLIntegerValue(exchanger_id, [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchanger_id"]);

        
        NSString * exchanger_image = [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchanger_image"];
        SET_IF_NOT_NULLIntegerValue(exchanger_image, [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchanger_image"]);

        
        NSString * exchanger_name = [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchanger_name"];
        SET_IF_NOT_NULLIntegerValue(exchanger_name, [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchanger_name"]);

        NSString * exchanger_username = [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchanger_username"];
        SET_IF_NOT_NULLIntegerValue(exchanger_username, [[goingToTestedArray objectAtIndex:i]objectForKey:@"exchanger_username"]);
        
        NSMutableDictionary *exchangeProduct = [[[NSMutableDictionary alloc]init]autorelease];
        NSMutableDictionary *my_product = [[[NSMutableDictionary alloc]init]autorelease];

        
        NSString * eitem_id = [[[goingToTestedArray objectAtIndex:i]objectForKey:@"exchange_product"]objectForKey:@"item_id"];
        SET_IF_NOT_NULLIntegerValue(eitem_id, [[[goingToTestedArray objectAtIndex:i]objectForKey:@"exchange_product"]objectForKey:@"item_id"]);
        
        NSString * eitem_image = [[[goingToTestedArray objectAtIndex:i]objectForKey:@"exchange_product"]objectForKey:@"item_image"];
        SET_IF_NOT_NULLIntegerValue(eitem_image, [[[goingToTestedArray objectAtIndex:i]objectForKey:@"exchange_product"]objectForKey:@"item_image"]);
        
        NSString * eitem_name = [[[goingToTestedArray objectAtIndex:i]objectForKey:@"exchange_product"]objectForKey:@"item_name"];
        SET_IF_NOT_NULLIntegerValue(eitem_name, [[[goingToTestedArray objectAtIndex:i]objectForKey:@"exchange_product"]objectForKey:@"item_name"]);

        [exchangeProduct setObject:eitem_id forKey:@"item_id"];
        [exchangeProduct setObject:eitem_image forKey:@"item_image"];
        [exchangeProduct setObject:eitem_name forKey:@"item_name"];

        NSString * mitem_id = [[[goingToTestedArray objectAtIndex:i]objectForKey:@"my_product"]objectForKey:@"item_id"];
        SET_IF_NOT_NULLIntegerValue(mitem_id, [[[goingToTestedArray objectAtIndex:i]objectForKey:@"my_product"]objectForKey:@"item_id"]);
        NSString * mitem_image = [[[goingToTestedArray objectAtIndex:i]objectForKey:@"my_product"]objectForKey:@"item_image"];
        SET_IF_NOT_NULLIntegerValue(mitem_image, [[[goingToTestedArray objectAtIndex:i]objectForKey:@"my_product"]objectForKey:@"item_image"]);
        NSString * mitem_name = [[[goingToTestedArray objectAtIndex:i]objectForKey:@"my_product"]objectForKey:@"item_name"];
        SET_IF_NOT_NULLIntegerValue(mitem_name, [[[goingToTestedArray objectAtIndex:i]objectForKey:@"my_product"]objectForKey:@"item_name"]);
        
        [my_product setObject:mitem_id forKey:@"item_id"];
        [my_product setObject:mitem_image forKey:@"item_image"];
        [my_product setObject:mitem_name forKey:@"item_name"];
  
        
        [exchangeInnerDict setObject:exchange_id forKey:@"exchange_id"];
        [exchangeInnerDict setObject:request_by_me forKey:@"request_by_me"];
        [exchangeInnerDict setObject:status forKey:@"status"];
        [exchangeInnerDict setObject:exchange_time forKey:@"exchange_time"];
        [exchangeInnerDict setObject:exchanger_id forKey:@"exchanger_id"];
        [exchangeInnerDict setObject:exchanger_image forKey:@"exchanger_image"];
        [exchangeInnerDict setObject:exchanger_name forKey:@"exchanger_name"];
        [exchangeInnerDict setObject:request_by_me forKey:@"category_name"];
        [exchangeInnerDict setObject:exchanger_username forKey:@"exchanger_username"];
        [exchangeInnerDict setObject:exchangeProduct forKey:@"exchange_product"];
        [exchangeInnerDict setObject:my_product forKey:@"my_product"];


        [exchangeArray addObject:exchangeInnerDict];
        
  
    }
    NSMutableDictionary * resultDict = [[[NSMutableDictionary alloc]init]autorelease];
    [resultDict setObject:exchangeArray forKey:@"exchange"];
    [testedCategoryDictionary setObject:resultDict forKey:@"result"];
    return testedCategoryDictionary;
}

//    [myExchangeArray addObjectsFromArray:[[defaultDict objectForKey:@"result"]objectForKey:@""]];

- (NSMutableDictionary *) notificationPageData:(NSMutableDictionary *)notificationPageDictionary
{
    NSMutableDictionary * testedHomePageDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSMutableDictionary * items = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    
    
    
    NSMutableArray * goingToTestedArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    if ([notificationPageDictionary objectForKey:@"result"]!=nil&&[notificationPageDictionary objectForKey:@"result"]!=[NSNull null])
    {
        if ([[notificationPageDictionary objectForKey:@"result"]isKindOfClass:ArrayClass])
        {
            [goingToTestedArray addObjectsFromArray:[notificationPageDictionary objectForKey:@"result"]];
            for (int i=0;i<[goingToTestedArray count];i++)
            {
                
                
            }
            [testedHomePageDict setObject:@"true" forKey:@"status"];
            
        }
        [testedHomePageDict setObject:@"true" forKey:@"status"];
        
    }
    else
    {
        [testedHomePageDict setObject:@"false" forKey:@"status"];
        
    }
    [items setObject:[self notificationData:goingToTestedArray] forKey:@"notification"];
    [testedHomePageDict setObject:items forKey:@"result"];
    
    return testedHomePageDict;
}

-(NSMutableArray*) notificationData:(NSMutableArray*) notificationArray
{
    NSMutableArray * testedHomePageArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    NSMutableArray * notificationDataArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    [notificationDataArray addObjectsFromArray:notificationArray];
    for (int i=0; i<[notificationDataArray count]; i++)
    {
        
        
        NSMutableDictionary * notificationDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * user_id = [[notificationDataArray objectAtIndex:i]objectForKey:@"user_id"];
        SET_IF_NOT_NULL(user_id,[[notificationDataArray objectAtIndex:i]objectForKey:@"user_id"]);
        
        NSString * user_image = [[notificationDataArray objectAtIndex:i]objectForKey:@"user_image"];
        SET_IF_NOT_NULL(user_image,[[notificationDataArray objectAtIndex:i]objectForKey:@"user_image"]);
        
        NSString * user_name = [[notificationDataArray objectAtIndex:i]objectForKey:@"user_name"];
        SET_IF_NOT_NULL(user_name,[[notificationDataArray objectAtIndex:i]objectForKey:@"user_name"]);
        
        NSString * type = [[notificationDataArray objectAtIndex:i]objectForKey:@"type"];
        SET_IF_NOT_NULL(type,[[notificationDataArray objectAtIndex:i]objectForKey:@"type"]);
        
        NSString * message = [[notificationDataArray objectAtIndex:i]objectForKey:@"message"];
        SET_IF_NOT_NULL(message,[[notificationDataArray objectAtIndex:i]objectForKey:@"message"]);
      
        NSString * event_time = [[notificationDataArray objectAtIndex:i]objectForKey:@"event_time"];
        SET_IF_NOT_NULL(event_time,[[notificationDataArray objectAtIndex:i]objectForKey:@"event_time"]);
        
        
        NSString * item_id = [[notificationDataArray objectAtIndex:i]objectForKey:@"item_id"];
        SET_IF_NOT_NULL(item_id,[[notificationDataArray objectAtIndex:i]objectForKey:@"item_id"]);
        
        NSString * item_image = [[notificationDataArray objectAtIndex:i]objectForKey:@"item_image"];
        SET_IF_NOT_NULL(item_image,[[notificationDataArray objectAtIndex:i]objectForKey:@"item_image"]);
        
        NSString * item_title = [[notificationDataArray objectAtIndex:i]objectForKey:@"item_title"];
        SET_IF_NOT_NULL(item_title,[[notificationDataArray objectAtIndex:i]objectForKey:@"item_title"]);
        
        
        [notificationDictionary setObject:user_id forKey:@"user_id"];
        [notificationDictionary setObject:user_name forKey:@"user_name"];
        [notificationDictionary setObject:type forKey:@"type"];
        [notificationDictionary setObject:message forKey:@"message"];
        [notificationDictionary setObject:event_time forKey:@"event_time"];
        [notificationDictionary setObject:item_id forKey:@"item_id"];
        [notificationDictionary setObject:item_image forKey:@"item_image"];
        [notificationDictionary setObject:item_title forKey:@"item_title"];
        [notificationDictionary setObject:user_image forKey:@"user_image"];

        
        
        [testedHomePageArray addObject:notificationDictionary];
        
        
    }
    return testedHomePageArray;
}


- (NSMutableDictionary *) helpPageData:(NSMutableDictionary *)helpPageDictionary
{
    NSMutableDictionary * testedHomePageDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSMutableDictionary * items = [[NSMutableDictionary alloc]initWithCapacity:0];

    NSMutableArray * goingToTestedArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    if ([helpPageDictionary objectForKey:@"result"]!=nil&&[helpPageDictionary objectForKey:@"result"]!=[NSNull null])
    {
        if ([[helpPageDictionary objectForKey:@"result"]isKindOfClass:ArrayClass])
        {
            [goingToTestedArray addObjectsFromArray:[helpPageDictionary objectForKey:@"result"]];
            [testedHomePageDict setObject:@"true" forKey:@"status"];
            
        }
        [testedHomePageDict setObject:@"true" forKey:@"status"];
        
    }
    else
    {
        [testedHomePageDict setObject:@"false" forKey:@"status"];
    }
    [items setObject:[self helpPage:goingToTestedArray] forKey:@"helpdata"];
    [testedHomePageDict setObject:items forKey:@"result"];
    
    return testedHomePageDict;
}

-(NSMutableArray*) helpPage:(NSMutableArray*) helpPageArray
{
    NSMutableArray * helpPageContent = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    NSMutableArray * helpPageDataArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    [helpPageDataArray addObjectsFromArray:helpPageArray];
    for (int i=0; i<[helpPageDataArray count]; i++)
    {
        
        NSMutableDictionary * helpPageDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * page_name = [[helpPageDataArray objectAtIndex:i]objectForKey:@"page_name"];
        SET_IF_NOT_NULLIntegerValue(page_name, [[helpPageDataArray objectAtIndex:i]objectForKey:@"page_name"]);
        
        NSString * page_content = [[helpPageDataArray objectAtIndex:i]objectForKey:@"page_content"];
        SET_IF_NOT_NULLIntegerValue(page_content, [[helpPageDataArray objectAtIndex:i]objectForKey:@"page_content"]);
        
        [helpPageDictionary setObject:page_name forKey:@"page_name"];
        [helpPageDictionary setObject:page_content forKey:@"page_content"];
        
        [helpPageContent addObject:helpPageDictionary];
        
        
    }
    return helpPageContent;
}
-(NSMutableArray *) followPageData:(NSMutableArray *)followDict
{
    NSMutableArray * users = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    NSMutableArray * goingToTestedArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    [goingToTestedArray addObjectsFromArray:followDict];
    
    for (int i=0; i<[goingToTestedArray count]; i++)
    {
        NSMutableDictionary * followDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * full_name = [[goingToTestedArray objectAtIndex:i]objectForKey:@"full_name"];
        SET_IF_NOT_NULLIntegerValue(full_name, [[goingToTestedArray objectAtIndex:i]objectForKey:@"full_name"]);
        
        NSString * status = [[goingToTestedArray objectAtIndex:i]objectForKey:@"status"];
        SET_IF_NOT_NULLIntegerValue(status, [[goingToTestedArray objectAtIndex:i]objectForKey:status]);

        NSString * user_id = [[goingToTestedArray objectAtIndex:i]objectForKey:@"user_id"];
        SET_IF_NOT_NULLIntegerValue(user_id, [[goingToTestedArray objectAtIndex:i]objectForKey:@"user_id"]);

        NSString * user_image = [[goingToTestedArray objectAtIndex:i]objectForKey:@"user_image"];
        SET_IF_NOT_NULLIntegerValue(user_image, [[goingToTestedArray objectAtIndex:i]objectForKey:@"user_image"]);

        NSString * user_name = [[goingToTestedArray objectAtIndex:i]objectForKey:@"user_name"];
        SET_IF_NOT_NULLIntegerValue(user_name, [[goingToTestedArray objectAtIndex:i]objectForKey:@"user_name"]);

        [followDictionary setObject:full_name forKey:@"full_name"];
        [followDictionary setObject:status forKey:@"status"];
        [followDictionary setObject:user_id forKey:@"user_id"];
        [followDictionary setObject:user_image forKey:@"user_image"];
        [followDictionary setObject:user_name forKey:@"user_name"];


        [users addObject:followDictionary];
    }
    
    return users;

}
-(NSMutableArray *) profileParsing:(NSMutableArray *)profileArray
{
    
    NSLog(@"profileArray:%@",profileArray);
    NSMutableArray * userdetailArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    NSMutableArray * goingToParseArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    [goingToParseArray addObject:profileArray];
    
    NSString * email = [[goingToParseArray objectAtIndex:0]objectForKey:@"email"];
    SET_IF_NOT_NULLIntegerValue(email, [[goingToParseArray objectAtIndex:0]objectForKey:@"email"]);

    NSString * facebook_id = [[goingToParseArray objectAtIndex:0]objectForKey:@"facebook_id"];
    SET_IF_NOT_NULLIntegerValue(facebook_id, [[goingToParseArray objectAtIndex:0]objectForKey:@"facebook_id"]);

    NSString * full_name = [[goingToParseArray objectAtIndex:0]objectForKey:@"full_name"];
    SET_IF_NOT_NULLIntegerValue(full_name, [[goingToParseArray objectAtIndex:0]objectForKey:@"full_name"]);

    NSString * mobile_no = [[goingToParseArray objectAtIndex:0]objectForKey:@"mobile_no"];
    SET_IF_NOT_NULLIntegerValue(mobile_no, [[goingToParseArray objectAtIndex:0]objectForKey:@"mobile_no"]);

    NSString * user_id = [[goingToParseArray objectAtIndex:0]objectForKey:@"user_id"];
    SET_IF_NOT_NULLIntegerValue(user_id, [[goingToParseArray objectAtIndex:0]objectForKey:@"user_id"]);

    NSString * user_img = [[goingToParseArray objectAtIndex:0]objectForKey:@"user_img"];
    SET_IF_NOT_NULLIntegerValue(user_img, [[goingToParseArray objectAtIndex:0]objectForKey:@"user_img"]);

    NSString * user_name = [[goingToParseArray objectAtIndex:0]objectForKey:@"user_name"];
    SET_IF_NOT_NULLIntegerValue(user_name, [[goingToParseArray objectAtIndex:0]objectForKey:@"user_name"]);

    
    NSString * email_verify = [[[goingToParseArray objectAtIndex:0]objectForKey:@"verification"] objectForKey:@"email"];
    SET_IF_NOT_NULLIntegerValue(email_verify, [[[goingToParseArray objectAtIndex:0]objectForKey:@"verification"] objectForKey:@"email"]);

    NSString * fb_verify = [[[goingToParseArray objectAtIndex:0]objectForKey:@"verification"] objectForKey:@"facebook"];
    SET_IF_NOT_NULLIntegerValue(fb_verify, [[[goingToParseArray objectAtIndex:0]objectForKey:@"verification"] objectForKey:@"facebook"]);

    NSString * mob_no_verify = [[[goingToParseArray objectAtIndex:0]objectForKey:@"verification"] objectForKey:@"mob_no"];
    SET_IF_NOT_NULLIntegerValue(mob_no_verify, [[[goingToParseArray objectAtIndex:0]objectForKey:@"verification"] objectForKey:@"mob_no"]);
    
    NSString * rating = [[goingToParseArray objectAtIndex:0]objectForKey:@"rating"];
    SET_IF_NOT_NULLIntegerValue(rating, [[goingToParseArray objectAtIndex:0]objectForKey:@"rating"]);
    
    NSString * showVerify = [[goingToParseArray objectAtIndex:0]objectForKey:@"show_mobile_no"];
    SET_IF_NOT_NULLIntegerValue(showVerify, [[goingToParseArray objectAtIndex:0]objectForKey:@"show_mobile_no"]);



    NSMutableDictionary * profileDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    [profileDictionary setObject:email forKey:@"email"];
    [profileDictionary setObject:facebook_id forKey:@"facebook_id"];
    [profileDictionary setObject:full_name forKey:@"full_name"];
    [profileDictionary setObject:mobile_no forKey:@"mobile_no"];
    [profileDictionary setObject:user_id forKey:@"user_id"];
    [profileDictionary setObject:user_img forKey:@"user_img"];
    [profileDictionary setObject:user_name forKey:@"user_name"];
    [profileDictionary setObject:email_verify forKey:@"email_verify"];
    [profileDictionary setObject:fb_verify forKey:@"fb_verify"];
    [profileDictionary setObject:mob_no_verify forKey:@"mob_no_verify"];
    [profileDictionary setObject:showVerify forKey:@"show_mobile_no"];
    [profileDictionary setObject:rating forKey:@"rating"];

    [userdetailArray addObject:profileDictionary];

    return userdetailArray;
}
- (NSMutableDictionary *) addressParsing:(NSMutableDictionary *)addressDict
{
    NSMutableDictionary * addressDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    
    NSMutableArray * resultArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    if ([addressDict objectForKey:@"result"]!=nil&&[addressDict objectForKey:@"result"]!=[NSNull null])
    {
        if (![[addressDict objectForKey:@"status"]isEqualToString:@"false"])
        {
            if ([[addressDict objectForKey:@"result"]isKindOfClass:ArrayClass])
            {
                [resultArray addObjectsFromArray:[addressDict objectForKey:@"result"]];
            }
        }
    }
    
    NSMutableArray * addressArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    for (int i=0; i<[resultArray count]; i++)
    {
        
        NSMutableDictionary * itemsDict = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * shipping_id = [[resultArray objectAtIndex:i]objectForKey:@"shippingid"];
        SET_IF_NOT_NULLIntegerValue(shipping_id, [[resultArray objectAtIndex:i]objectForKey:@"shippingid"]);
        
        NSString * zip_code = [[resultArray objectAtIndex:i]objectForKey:@"zipcode"];
        SET_IF_NOT_NULLIntegerValue(zip_code, [[resultArray objectAtIndex:i]objectForKey:@"zipcode"]);
        
        NSString * nick_name = [[resultArray objectAtIndex:i]objectForKey:@"nickname"];
        SET_IF_NOT_NULL(nick_name, [[resultArray objectAtIndex:i]objectForKey:@"nickname"]);
        
        NSString * full_name = [[resultArray objectAtIndex:i]objectForKey:@"name"];
        SET_IF_NOT_NULL(full_name, [[resultArray objectAtIndex:i]objectForKey:@"name"]);
        
        
        NSString * country_name = [[resultArray objectAtIndex:i]objectForKey:@"country"];
        SET_IF_NOT_NULL(country_name, [[resultArray objectAtIndex:i]objectForKey:@"country"]);
        
        NSString * defaultstr = [[resultArray objectAtIndex:i]objectForKey:@"defaultshipping"];
        SET_IF_NOT_NULLIntegerValue(defaultstr, [[resultArray objectAtIndex:i]objectForKey:@"defaultshipping"]);
        
        
        NSString * state = [[resultArray objectAtIndex:i]objectForKey:@"state"];
        SET_IF_NOT_NULL(state, [[resultArray objectAtIndex:i]objectForKey:@"state"]);
        
        NSString * address1 = [[resultArray objectAtIndex:i]objectForKey:@"address1"];
        SET_IF_NOT_NULL(address1, [[resultArray objectAtIndex:i]objectForKey:@"address1"]);
        
        
        NSString * address2 = [[resultArray objectAtIndex:i]objectForKey:@"address2"];
        SET_IF_NOT_NULL(address2, [[resultArray objectAtIndex:i]objectForKey:@"address2"]);
        
        
        
        NSString * city = [[resultArray objectAtIndex:i]objectForKey:@"city"];
        SET_IF_NOT_NULL(city, [[resultArray objectAtIndex:i]objectForKey:@"city"]);
        
        
        NSString * phone_no = [[resultArray objectAtIndex:i]objectForKey:@"phone"];
        SET_IF_NOT_NULLIntegerValue(phone_no, [[resultArray objectAtIndex:i]objectForKey:@"phone"]);
        
        NSString * country_id = [[resultArray objectAtIndex:i]objectForKey:@"countrycode"];
        SET_IF_NOT_NULLIntegerValue(country_id, [[resultArray objectAtIndex:i]objectForKey:@"countrycode"]);
        //        shippingid zipcode nickname name country
        
        
        [itemsDict setObject:shipping_id forKey:@"shippingid"];
        [itemsDict setObject:zip_code forKey:@"zipcode"];
        [itemsDict setObject:nick_name forKey:@"nickname"];
        [itemsDict setObject:full_name forKey:@"name"];
        [itemsDict setObject:country_name forKey:@"country"];
        [itemsDict setObject:address1 forKey:@"address2"];
        [itemsDict setObject:address2 forKey:@"address1"];
        [itemsDict setObject:city forKey:@"city"];
        [itemsDict setObject:phone_no forKey:@"phone"];
        [itemsDict setObject:country_id forKey:@"countrycode"];
        [itemsDict setObject:defaultstr forKey:@"defaultshipping"];
        [itemsDict setObject:state forKey:@"state"];
        
        
        [addressArray addObject:itemsDict];
    }
    [addressDictionary setObject:addressArray forKey:@"result"];
    [addressDictionary setObject:@"true" forKey:@"status"];
    
    return addressDict;
}


- (NSMutableDictionary *) myorderParsing:(NSMutableDictionary *)myorderDict{
    NSMutableDictionary * myorderDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    NSLog(@"myorderDict:%@",myorderDict);
    NSMutableArray * resultArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    if ([myorderDict objectForKey:@"result"]!=nil&&[myorderDict objectForKey:@"result"]!=[NSNull null])
    {
        if (![[myorderDict objectForKey:@"status"]isEqualToString:@"false"])
        {
            if ([[myorderDict objectForKey:@"result"]isKindOfClass:ArrayClass])
            {
                [resultArray addObjectsFromArray:[myorderDict objectForKey:@"result"]];
            }
        }
    }
    
    NSMutableArray * orderArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    for (int i=0; i<[resultArray count]; i++)
    {
        NSMutableDictionary * itemsDict = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * deliverydate = [[resultArray objectAtIndex:i]objectForKey:@"deliverydate"];
        SET_IF_NOT_NULL(deliverydate, [[resultArray objectAtIndex:i]objectForKey:@"deliverydate"]);
        
        NSString * orderid = [[resultArray objectAtIndex:i]objectForKey:@"orderid"];
        SET_IF_NOT_NULL(orderid, [[resultArray objectAtIndex:i]objectForKey:@"orderid"]);
        
        NSString * price = [[resultArray objectAtIndex:i]objectForKey:@"price"];
        SET_IF_NOT_NULL(price, [[resultArray objectAtIndex:i]objectForKey:@"price"]);
        
        NSString * saledate = [[resultArray objectAtIndex:i]objectForKey:@"saledate"];
        SET_IF_NOT_NULL(saledate, [[resultArray objectAtIndex:i]objectForKey:@"saledate"]);
        
        NSString * review_id = [[resultArray objectAtIndex:i]objectForKey:@"review_id"];
        SET_IF_NOT_NULL(review_id, [[resultArray objectAtIndex:i]objectForKey:@"review_id"]);
        
        NSString * rating = [[resultArray objectAtIndex:i]objectForKey:@"rating"];
        SET_IF_NOT_NULL(rating, [[resultArray objectAtIndex:i]objectForKey:@"rating"]);
        
        NSString * review_title = [[resultArray objectAtIndex:i]objectForKey:@"review_title"];
        SET_IF_NOT_NULL(review_title, [[resultArray objectAtIndex:i]objectForKey:@"review_title"]);
        
        NSString * review_des = [[resultArray objectAtIndex:i]objectForKey:@"review_des"];
        SET_IF_NOT_NULL(review_des, [[resultArray objectAtIndex:i]objectForKey:@"review_des"]);

        NSString * created_date = [[resultArray objectAtIndex:i]objectForKey:@"created_date"];
        SET_IF_NOT_NULL(created_date, [[resultArray objectAtIndex:i]objectForKey:@"created_date"]);

        
        NSString * status = [[resultArray objectAtIndex:i]objectForKey:@"status"];
        SET_IF_NOT_NULL(status, [[resultArray objectAtIndex:i]objectForKey:@"status"]);
        
        NSString * cancel = [[resultArray objectAtIndex:i]objectForKey:@"cancel"];
        SET_IF_NOT_NULL(cancel, [[resultArray objectAtIndex:i]objectForKey:@"cancel"]);

        
        NSString * transaction_id = [[resultArray objectAtIndex:i]objectForKey:@"transaction_id"];
        SET_IF_NOT_NULL(transaction_id, [[resultArray objectAtIndex:i]objectForKey:@"transaction_id"]);
        
        NSString * payment_type = [[resultArray objectAtIndex:i]objectForKey:@"payment_type"];
        SET_IF_NOT_NULL(payment_type, [[resultArray objectAtIndex:i]objectForKey:@"payment_type"]);
        
        NSMutableDictionary * myorderitemsDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * cSymbol = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"cSymbol"];
        SET_IF_NOT_NULL(cSymbol, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"cSymbol"]);
        
        NSString * itemid = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"itemid"];
        SET_IF_NOT_NULL(itemid, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"itemid"]);
        
        NSString * itemname = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"itemname"];
        SET_IF_NOT_NULL(itemname, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"itemname"]);
        
        NSString * orderImage = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"orderImage"];
        SET_IF_NOT_NULL(orderImage, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"orderImage"]);
        
        NSString * prices = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"price"];
        SET_IF_NOT_NULL(prices, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"price"]);
        
        NSString * quantity = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"quantity"];
        SET_IF_NOT_NULL(quantity, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"quantity"]);
        
        NSString * seller_id = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"seller_id"];
        SET_IF_NOT_NULL(seller_id, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"seller_id"]);
        
        NSString * seller_name = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"seller_name"];
        SET_IF_NOT_NULL(seller_name, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"seller_name"]);
        
        NSString * seller_img = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"seller_img"];
        SET_IF_NOT_NULL(seller_img, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"seller_img"]);
        
        NSString * seller_username = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"seller_username"];
        SET_IF_NOT_NULL(seller_username, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"seller_username"]);
        
        NSString * shipping_cost = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"shipping_cost"];
        SET_IF_NOT_NULL(shipping_cost, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"shipping_cost"]);
        
        NSString * size = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"size"];
        SET_IF_NOT_NULL(size, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"size"]);
        
        NSString * total = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"total"];
        SET_IF_NOT_NULL(total, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"total"]);
        
        NSString * unitprice = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"unitprice"];
        SET_IF_NOT_NULL(unitprice, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"unitprice"]);
        
        [myorderitemsDictionary setObject:cSymbol forKey:@"cSymbol"];
        [myorderitemsDictionary setObject:itemname forKey:@"itemname"];
        [myorderitemsDictionary setObject:itemid forKey:@"itemid"];
        [myorderitemsDictionary setObject:orderImage forKey:@"orderImage"];
        [myorderitemsDictionary setObject:prices forKey:@"price"];
        [myorderitemsDictionary setObject:quantity forKey:@"quantity"];
        [myorderitemsDictionary setObject:seller_id forKey:@"seller_id"];
        [myorderitemsDictionary setObject:seller_img forKey:@"seller_img"];
        [myorderitemsDictionary setObject:seller_name forKey:@"seller_name"];
        [myorderitemsDictionary setObject:seller_username forKey:@"seller_username"];
        [myorderitemsDictionary setObject:shipping_cost forKey:@"shipping_cost"];
        [myorderitemsDictionary setObject:size forKey:@"size"];
        [myorderitemsDictionary setObject:total forKey:@"total"];
        [myorderitemsDictionary setObject:unitprice forKey:@"unitprice"];
        
        
        NSMutableDictionary * shippingDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * address1 = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"address1"];
        SET_IF_NOT_NULL(address1, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"address1"]);
        
        NSString * address2 = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"address2"];
        SET_IF_NOT_NULL(address2, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"address2"]);
        
        NSString * city = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"city"];
        SET_IF_NOT_NULL(city, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"city"]);
        
        NSString * country = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"country"];
        SET_IF_NOT_NULL(country, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"country"]);
        
        NSString * countrycode = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"countrycode"];
        SET_IF_NOT_NULL(countrycode, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"countrycode"]);
        
        NSString * name = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"name"];
        SET_IF_NOT_NULL(name, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"name"]);
        
        NSString * nickname = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"nickname"];
        SET_IF_NOT_NULL(nickname, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"nickname"]);
        
        NSString * phone = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"phone"];
        SET_IF_NOT_NULL(phone, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"phone"]);
        
        NSString * state = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"state"];
        SET_IF_NOT_NULL(state, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"state"]);
        
        NSString * zipcode = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"zipcode"];
        SET_IF_NOT_NULL(zipcode, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"zipcode"]);
        
        [shippingDictionary setObject:address1 forKey:@"address1"];
        [shippingDictionary setObject:address2 forKey:@"address2"];
        [shippingDictionary setObject:city forKey:@"city"];
        [shippingDictionary setObject:country forKey:@"country"];
        [shippingDictionary setObject:countrycode forKey:@"countrycode"];
        [shippingDictionary setObject:name forKey:@"name"];
        [shippingDictionary setObject:nickname forKey:@"nickname"];
        [shippingDictionary setObject:shipping_cost forKey:@"shipping_cost"];
        [shippingDictionary setObject:phone forKey:@"phone"];
        [shippingDictionary setObject:state forKey:@"state"];
        [shippingDictionary setObject:zipcode forKey:@"zipcode"];
        
        
        if ([[resultArray objectAtIndex:i] objectForKey:@"trackingdetails"]) {
            NSMutableDictionary * trackingDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
            
            NSString * trackkey = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"id"];
            SET_IF_NOT_NULL(trackkey, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"id"]);
            
            NSString * shippingdate = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"shippingdate"];
            SET_IF_NOT_NULL(shippingdate, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"shippingdate"]);
            
            NSString * couriername = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"couriername"];
            SET_IF_NOT_NULL(couriername, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"couriername"]);
            
            NSString * courierservice = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"courierservice"];
            SET_IF_NOT_NULL(courierservice, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"courierservice"]);
            
            NSString * trackingid = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"trackingid"];
            SET_IF_NOT_NULL(trackingid, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"trackingid"]);
            
            NSString * notes = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"notes"];
            SET_IF_NOT_NULL(notes, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"notes"]);
            
            [trackingDictionary setObject:trackkey forKey:@"id"];
            [trackingDictionary setObject:shippingdate forKey:@"shippingdate"];
            [trackingDictionary setObject:couriername forKey:@"couriername"];
            [trackingDictionary setObject:courierservice forKey:@"courierservice"];
            [trackingDictionary setObject:trackingid forKey:@"trackingid"];
            [trackingDictionary setObject:notes forKey:@"notes"];
            [itemsDict setObject:trackingDictionary forKey:@"trackingdetails"];
            
        }
        
        
        [itemsDict setObject:transaction_id forKey:@"transaction_id"];
        [itemsDict setObject:status forKey:@"status"];
        [itemsDict setObject:cancel forKey:@"cancel"];
        [itemsDict setObject:saledate forKey:@"saledate"];
        [itemsDict setObject:price forKey:@"price"];

        [itemsDict setObject:review_id forKey:@"review_id"];
        [itemsDict setObject:rating forKey:@"rating"];
        [itemsDict setObject:review_title forKey:@"review_title"];
        [itemsDict setObject:review_des forKey:@"review_des"];
        [itemsDict setObject:created_date forKey:@"created_date"];

        
        [itemsDict setObject:orderid forKey:@"orderid"];
        [itemsDict setObject:deliverydate forKey:@"deliverydate"];
        [itemsDict setObject:payment_type forKey:@"payment_type"];
        [itemsDict setObject:myorderitemsDictionary forKey:@"orderitems"];
        [itemsDict setObject:shippingDictionary forKey:@"shippingaddress"];
        
        [orderArray addObject:itemsDict];
    }
    [myorderDictionary setObject:orderArray forKey:@"result"];
    [myorderDictionary setObject:@"true" forKey:@"status"];
    
    
    return myorderDictionary;
}

- (NSMutableDictionary *) mysaleParsing:(NSMutableDictionary *)mysaleDict{
    NSLog(@"mysaleDict:%@",mysaleDict);
    
    NSMutableDictionary * mysaleDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    
    NSMutableArray * resultArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    if ([mysaleDict objectForKey:@"result"]!=nil&&[mysaleDict objectForKey:@"result"]!=[NSNull null])
    {
        if (![[mysaleDict objectForKey:@"status"]isEqualToString:@"false"])
        {
            if ([[mysaleDict objectForKey:@"result"]isKindOfClass:ArrayClass])
            {
                [resultArray addObjectsFromArray:[mysaleDict objectForKey:@"result"]];
            }
        }
    }
    
    NSMutableArray * orderArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    for (int i=0; i<[resultArray count]; i++)
    {
        NSMutableDictionary * itemsDict = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * claim = [[resultArray objectAtIndex:i]objectForKey:@"claim"];
        SET_IF_NOT_NULL(claim, [[resultArray objectAtIndex:i]objectForKey:@"claim"]);
        
        NSString * deliverydate = [[resultArray objectAtIndex:i]objectForKey:@"deliverydate"];
        SET_IF_NOT_NULL(deliverydate, [[resultArray objectAtIndex:i]objectForKey:@"deliverydate"]);
        
        NSString * orderid = [[resultArray objectAtIndex:i]objectForKey:@"orderid"];
        SET_IF_NOT_NULL(orderid, [[resultArray objectAtIndex:i]objectForKey:@"orderid"]);
        
        NSString * invoice = [[resultArray objectAtIndex:i]objectForKey:@"invoice"];
        SET_IF_NOT_NULL(invoice, [[resultArray objectAtIndex:i]objectForKey:@"invoice"]);

        
        NSString * price = [[resultArray objectAtIndex:i]objectForKey:@"price"];
        SET_IF_NOT_NULL(price, [[resultArray objectAtIndex:i]objectForKey:@"price"]);
        
        NSString * saledate = [[resultArray objectAtIndex:i]objectForKey:@"saledate"];
        SET_IF_NOT_NULL(saledate, [[resultArray objectAtIndex:i]objectForKey:@"saledate"]);
        
        
        NSString * status = [[resultArray objectAtIndex:i]objectForKey:@"status"];
        SET_IF_NOT_NULL(status, [[resultArray objectAtIndex:i]objectForKey:@"status"]);
        
        NSString * transaction_id = [[resultArray objectAtIndex:i]objectForKey:@"transaction_id"];
        SET_IF_NOT_NULL(transaction_id, [[resultArray objectAtIndex:i]objectForKey:@"transaction_id"]);
        
        NSString * payment_type = [[resultArray objectAtIndex:i]objectForKey:@"payment_type"];
        SET_IF_NOT_NULL(payment_type, [[resultArray objectAtIndex:i]objectForKey:@"payment_type"]);
        
        NSString * review_id = [[resultArray objectAtIndex:i]objectForKey:@"review_id"];
        SET_IF_NOT_NULL(review_id, [[resultArray objectAtIndex:i]objectForKey:@"review_id"]);

        NSString * rating = [[resultArray objectAtIndex:i]objectForKey:@"rating"];
        SET_IF_NOT_NULL(rating, [[resultArray objectAtIndex:i]objectForKey:@"rating"]);

        NSString * review_title = [[resultArray objectAtIndex:i]objectForKey:@"review_title"];
        SET_IF_NOT_NULL(review_title, [[resultArray objectAtIndex:i]objectForKey:@"review_title"]);

        NSString * review_des = [[resultArray objectAtIndex:i]objectForKey:@"review_des"];
        SET_IF_NOT_NULL(review_des, [[resultArray objectAtIndex:i]objectForKey:@"review_des"]);
        

        
        NSMutableDictionary * myorderitemsDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * cSymbol = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"cSymbol"];
        SET_IF_NOT_NULL(cSymbol, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"cSymbol"]);
        
        NSString * itemname = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"itemname"];
        SET_IF_NOT_NULL(itemname, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"itemname"]);
        
        NSString * itemid = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"itemid"];
        SET_IF_NOT_NULL(itemid, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"itemid"]);
        
        NSString * orderImage = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"orderImage"];
        SET_IF_NOT_NULL(orderImage, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"orderImage"]);
        
        NSString * prices = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"price"];
        SET_IF_NOT_NULL(prices, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"price"]);
        
        NSString * quantity = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"quantity"];
        SET_IF_NOT_NULL(quantity, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"quantity"]);
        
        NSString * buyer_id = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"buyer_id"];
        SET_IF_NOT_NULL(buyer_id, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"buyer_id"]);
        
        NSString * buyer_img = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"buyer_img"];
        SET_IF_NOT_NULL(buyer_img, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"buyer_img"]);
        
        NSString * buyer_name = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"buyer_name"];
        SET_IF_NOT_NULL(buyer_name, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"buyer_name"]);
        
        NSString * buyer_email = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"buyer_email"];
        SET_IF_NOT_NULL(buyer_email, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"buyer_email"]);

        
        NSString * buyer_username = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"buyer_username"];
        SET_IF_NOT_NULL(buyer_username, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"buyer_username"]);
        
        NSString * shipping_cost = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"shipping_cost"];
        SET_IF_NOT_NULL(shipping_cost, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"shipping_cost"]);
        
        NSString * size = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"size"];
        SET_IF_NOT_NULL(size, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"size"]);
        
        NSString * total = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"total"];
        SET_IF_NOT_NULL(total, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"total"]);
        
        NSString * unitprice = [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"unitprice"];
        SET_IF_NOT_NULL(unitprice, [[[resultArray objectAtIndex:i]objectForKey:@"orderitems"]objectForKey:@"unitprice"]);
        
        [myorderitemsDictionary setObject:cSymbol forKey:@"cSymbol"];
        [myorderitemsDictionary setObject:itemname forKey:@"itemname"];
        [myorderitemsDictionary setObject:itemid forKey:@"itemid"];
        [myorderitemsDictionary setObject:orderImage forKey:@"orderImage"];
        [myorderitemsDictionary setObject:prices forKey:@"price"];
        [myorderitemsDictionary setObject:quantity forKey:@"quantity"];
        [myorderitemsDictionary setObject:buyer_id forKey:@"buyer_id"];
        [myorderitemsDictionary setObject:buyer_img forKey:@"buyer_img"];
        [myorderitemsDictionary setObject:buyer_name forKey:@"buyer_name"];
        [myorderitemsDictionary setObject:buyer_email forKey:@"buyer_email"];
        [myorderitemsDictionary setObject:buyer_username forKey:@"buyer_username"];
        [myorderitemsDictionary setObject:shipping_cost forKey:@"shipping_cost"];
        [myorderitemsDictionary setObject:size forKey:@"size"];
        [myorderitemsDictionary setObject:total forKey:@"total"];
        [myorderitemsDictionary setObject:unitprice forKey:@"unitprice"];
        
        
        NSMutableDictionary * shippingDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * address1 = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"address1"];
        SET_IF_NOT_NULL(address1, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"address1"]);
        
        NSString * address2 = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"address2"];
        SET_IF_NOT_NULL(address2, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"address2"]);
        
        NSString * city = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"city"];
        SET_IF_NOT_NULL(city, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"city"]);
        
        NSString * country = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"country"];
        SET_IF_NOT_NULL(country, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"country"]);
        
        NSString * countrycode = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"countrycode"];
        SET_IF_NOT_NULL(countrycode, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"countrycode"]);
        
        NSString * name = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"name"];
        SET_IF_NOT_NULL(name, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"name"]);
        
        NSString * nickname = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"nickname"];
        SET_IF_NOT_NULL(nickname, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"nickname"]);
        
        NSString * phone = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"phone"];
        SET_IF_NOT_NULL(phone, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"phone"]);
        
        NSString * state = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"state"];
        SET_IF_NOT_NULL(state, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"state"]);
        
        NSString * zipcode = [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"zipcode"];
        SET_IF_NOT_NULL(zipcode, [[[resultArray objectAtIndex:i]objectForKey:@"shippingaddress"]objectForKey:@"zipcode"]);
        
        [shippingDictionary setObject:address1 forKey:@"address1"];
        [shippingDictionary setObject:address2 forKey:@"address2"];
        [shippingDictionary setObject:city forKey:@"city"];
        [shippingDictionary setObject:country forKey:@"country"];
        [shippingDictionary setObject:countrycode forKey:@"countrycode"];
        [shippingDictionary setObject:name forKey:@"name"];
        [shippingDictionary setObject:nickname forKey:@"nickname"];
        [shippingDictionary setObject:shipping_cost forKey:@"shipping_cost"];
        [shippingDictionary setObject:phone forKey:@"phone"];
        [shippingDictionary setObject:state forKey:@"state"];
        [shippingDictionary setObject:zipcode forKey:@"zipcode"];
        
        if ([[resultArray objectAtIndex:i] objectForKey:@"trackingdetails"]) {
            NSMutableDictionary * trackingDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
            
            NSString * trackkey = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"id"];
            SET_IF_NOT_NULL(trackkey, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"id"]);
            
            NSString * shippingdate = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"shippingdate"];
            SET_IF_NOT_NULL(shippingdate, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"shippingdate"]);
            
            NSString * couriername = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"couriername"];
            SET_IF_NOT_NULL(couriername, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"couriername"]);
            
            NSString * courierservice = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"courierservice"];
            SET_IF_NOT_NULL(courierservice, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"courierservice"]);
            
            NSString * trackingid = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"trackingid"];
            SET_IF_NOT_NULL(trackingid, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"trackingid"]);
            
            NSString * notes = [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"notes"];
            SET_IF_NOT_NULL(notes, [[[resultArray objectAtIndex:i]objectForKey:@"trackingdetails"]objectForKey:@"notes"]);
            
            [trackingDictionary setObject:trackkey forKey:@"id"];
            [trackingDictionary setObject:shippingdate forKey:@"shippingdate"];
            [trackingDictionary setObject:couriername forKey:@"couriername"];
            [trackingDictionary setObject:courierservice forKey:@"courierservice"];
            [trackingDictionary setObject:trackingid forKey:@"trackingid"];
            [trackingDictionary setObject:notes forKey:@"notes"];
            [itemsDict setObject:trackingDictionary forKey:@"trackingdetails"];
            
        }
        
        /*
         “review_id” : “12”, // If not rated yet, Give 0
         “rating” : “3.5”, // If not rated yet, Give 0
         “review_title” : “Nice product”, // If not rated yet, Give empty value
         “review_des” : “nice one, good to go”,// If not rated yet, Give empty value
         */

        
        [itemsDict setObject:claim forKey:@"claim"];
        [itemsDict setObject:transaction_id forKey:@"transaction_id"];
        [itemsDict setObject:status forKey:@"status"];
        [itemsDict setObject:saledate forKey:@"saledate"];
        [itemsDict setObject:price forKey:@"price"];
        [itemsDict setObject:orderid forKey:@"orderid"];
        [itemsDict setObject:invoice forKey:@"invoice"];
        [itemsDict setObject:deliverydate forKey:@"deliverydate"];
        [itemsDict setObject:payment_type forKey:@"payment_type"];
        
        [itemsDict setObject:review_id forKey:@"review_id"];
        [itemsDict setObject:rating forKey:@"rating"];
        [itemsDict setObject:review_title forKey:@"review_title"];
        [itemsDict setObject:review_des forKey:@"review_des"];

        
        [itemsDict setObject:myorderitemsDictionary forKey:@"orderitems"];
        [itemsDict setObject:shippingDictionary forKey:@"shippingaddress"];
        
        [orderArray addObject:itemsDict];
    }
    [mysaleDictionary setObject:orderArray forKey:@"result"];
    [mysaleDictionary setObject:@"true" forKey:@"status"];
    
    
    return mysaleDictionary;
}
- (NSMutableDictionary *) myreviewPasrsing:(NSMutableDictionary *)myreviewDict{
    NSMutableDictionary * myorderDictionary = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    NSLog(@"myorderDict:%@",myreviewDict);
    NSMutableArray * resultArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    if ([myreviewDict objectForKey:@"result"]!=nil&&[myreviewDict objectForKey:@"result"]!=[NSNull null])
    {
        if (![[myreviewDict objectForKey:@"status"]isEqualToString:@"false"])
        {
            if ([[myreviewDict objectForKey:@"result"]isKindOfClass:ArrayClass])
            {
                [resultArray addObjectsFromArray:[myreviewDict objectForKey:@"result"]];
            }
        }
    }
    
    NSMutableArray * reviewArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    for (int i=0; i<[resultArray count]; i++)
    {
        NSMutableDictionary * itemsDict = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
        
        NSString * full_name = [[resultArray objectAtIndex:i]objectForKey:@"full_name"];
        SET_IF_NOT_NULL(full_name, [[resultArray objectAtIndex:i]objectForKey:@"full_name"]);
        
        NSString * item_id = [[resultArray objectAtIndex:i]objectForKey:@"item_id"];
        SET_IF_NOT_NULL(item_id, [[resultArray objectAtIndex:i]objectForKey:@"item_id"]);
        
        NSString * item_name = [[resultArray objectAtIndex:i]objectForKey:@"item_name"];
        SET_IF_NOT_NULL(item_name, [[resultArray objectAtIndex:i]objectForKey:@"item_name"]);
        
        NSString * rating = [[resultArray objectAtIndex:i]objectForKey:@"saledate"];
        SET_IF_NOT_NULLIntegerValue(rating, [[resultArray objectAtIndex:i]objectForKey:@"rating"]);
        
        
        NSString * review_des = [[resultArray objectAtIndex:i]objectForKey:@"review_des"];
        SET_IF_NOT_NULL(review_des, [[resultArray objectAtIndex:i]objectForKey:@"review_des"]);
        
        NSString * created_date = [[resultArray objectAtIndex:i]objectForKey:@"created_date"];
        SET_IF_NOT_NULL(created_date, [[resultArray objectAtIndex:i]objectForKey:@"created_date"]);

        
        NSString * review_id = [[resultArray objectAtIndex:i]objectForKey:@"review_id"];
        SET_IF_NOT_NULL(review_id, [[resultArray objectAtIndex:i]objectForKey:@"review_id"]);
        
        
        NSString * review_title = [[resultArray objectAtIndex:i]objectForKey:@"review_title"];
        SET_IF_NOT_NULL(review_title, [[resultArray objectAtIndex:i]objectForKey:@"review_title"]);
        
        NSString * user_id = [[resultArray objectAtIndex:i]objectForKey:@"user_id"];
        SET_IF_NOT_NULL(user_id, [[resultArray objectAtIndex:i]objectForKey:@"user_id"]);
        
        NSString * user_image = [[resultArray objectAtIndex:i]objectForKey:@"user_image"];
        SET_IF_NOT_NULL(user_image, [[resultArray objectAtIndex:i]objectForKey:@"user_image"]);

        
        /*
         "full_name" = Roja;
         "item_id" = 218;
         "item_name" = tfg;
         rating = 3;
         "review_des" = dscxcs;
         "review_id" = 19;
         "review_title" = "";
         "user_id" = 190;
         "user_image" = "https://joysalescript.com/beta/user/resized/150/6780_6jpg";
         
         */
//
        
        
        [itemsDict setObject:full_name forKey:@"full_name"];
        [itemsDict setObject:item_id forKey:@"item_id"];
        [itemsDict setObject:item_name forKey:@"item_name"];
        [itemsDict setObject:rating forKey:@"rating"];
        [itemsDict setObject:review_des forKey:@"review_des"];
        [itemsDict setObject:review_id forKey:@"review_id"];
        [itemsDict setObject:review_title forKey:@"review_title"];
        [itemsDict setObject:user_id forKey:@"user_id"];
        [itemsDict setObject:user_image forKey:@"user_image"];
        [itemsDict setObject:created_date forKey:@"created_date"];

        [reviewArray addObject:itemsDict];
    }
    [myorderDictionary setObject:reviewArray forKey:@"result"];
    [myorderDictionary setObject:@"true" forKey:@"status"];
    
    
    return myorderDictionary;
}
@end
