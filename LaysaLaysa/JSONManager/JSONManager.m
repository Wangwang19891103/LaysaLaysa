//
//  JSONManager.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//
#import "JSONManager.h"
#import "Constants.h"

@implementation JSONManager

//call this method
+ (void)callJSONWithParamethers:(NSDictionary*)paramethers isNew:(BOOL) isNew
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *urlString = [NSString stringWithFormat:@"http://laysalaysa.com/api/?json=get_category_posts&id=24&page=1&count=5"];
    if (paramethers != nil){
        int pageNumber = isNew ? 1 : [[paramethers valueForKey:@"page_number"] intValue];
        NSString* topicName = [paramethers valueForKey:@"topic_name"];
        if ([topicName isEqualToString:@"Gallaries"]){
            urlString = @"http://laysalaysa.com/category/galleryapps";
        } else {
            int topicID = [self getTopicIDByName:topicName];
            urlString = [NSString stringWithFormat:@"http://laysalaysa.com/api/?json=get_category_posts&id=%i&page=%i&count=10", topicID, pageNumber];
        }
    }
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]                          completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError)
     {
         if (data)
         {
             id myJSON;
             @try {
                 myJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             }
             @catch (NSException *exception) {
             }
             @finally {
             }
             NSArray* jsonArray = (NSArray *)myJSON;
             
             NSLog(@"RESULT from server - %@",jsonArray);
             
             NSMutableDictionary* topicDict = [[NSMutableDictionary alloc] init];
             [topicDict setObject:jsonArray forKey:TOPIC_DICTIONARY];
             NSString* topicName = [paramethers valueForKey:@"topic_name"];
             topicName = topicName == nil ? @"News" : topicName;
             [topicDict setObject:topicName forKey:TOPIC_CATEGORY];
             
             if (isNew){
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_MAIN_RESULTS object:topicDict];
             } else {
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_MORE_RESULTS object:topicDict];
             }
             
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         }
     }];
}

+ (void)callHomePage{
    NSArray* topicsName = [[NSArray alloc] initWithObjects:@"News", @"Reviews", @"Interviews", @"Galleries", @"Trailers", @"Movies", nil];
    for (NSString* name in topicsName){
        int topicID = [self getTopicIDByName:name];
        NSString *urlString = [NSString stringWithFormat:@"http://laysalaysa.com/api/?json=get_category_posts&id=%i&page=1&count=3", topicID];
        [self callURL:urlString andCategory:name];
    }

}

+(void)callURL:(NSString*)url andCategory:(NSString*)category{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]                          completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError)
     {
         if (data)
         {
             id myJSON;
             @try {
                 myJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             }
             @catch (NSException *exception) {
             }
             @finally {
             }
             NSArray* jsonArray = (NSArray *)myJSON;
             
             
             NSMutableDictionary* topicDict = [[NSMutableDictionary alloc] init];
             [topicDict setObject:jsonArray forKey:TOPIC_DICTIONARY];
             [topicDict setObject:category forKey:TOPIC_CATEGORY];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_HOME_RESULTS object:topicDict];
             
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         }
     }];
}

+(int)getTopicIDByName:(NSString*)topicName{
    if ([topicName isEqualToString:@"News"]){
        return 24;
    }
    if ([topicName isEqualToString:@"Reviews"]){
        return 26;
    }
    if ([topicName isEqualToString:@"Interviews"]){
        return 62;
    }
    if ([topicName isEqualToString:@"Galleries"]){
        return 23;
    }
    if ([topicName isEqualToString:@"Trailers"] || [topicName isEqualToString:@"Videos"]){
        return 28;
    }
    if ([topicName isEqualToString:@"Movies"]){
        return 27;
    }
    return 24;
}

+ (void)sendDeviceTokenToServer:(NSString*)deviceToken{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *urlString = [NSString stringWithFormat:@"http://laysalaysa.com/insert_device_token.php"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSString* parameters = [NSString stringWithFormat:@"device_token=%@&os=IOS&lang=en_US&user_id=1234", deviceToken];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]                          completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError)
     {
         if (data)
         {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         }
     }];
}

@end
