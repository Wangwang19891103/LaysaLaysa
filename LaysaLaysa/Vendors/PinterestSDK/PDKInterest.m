//
//  PDKInterest.m
//  Pods
///
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "PDKInterest.h"

@implementation PDKInterest

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _name = dictionary[@"name"];
        _identifier = dictionary[@"id"];
    }
    return self;
}

+ (instancetype)interestFromDictionary:(NSDictionary *)dictionary
{
    return [[PDKInterest alloc] initWithDictionary:dictionary];
}

@end
