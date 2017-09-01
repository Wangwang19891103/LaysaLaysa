//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//
#import "PDKBoard.h"

#import "PDKClient.h"
#import "PDKImageInfo.h"
#import "PDKUser.h"

@interface PDKBoard()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *descriptionText;
@property (nonatomic, strong, readwrite) PDKUser *creator;

@property (nonatomic, assign, readwrite) NSUInteger followers;
@property (nonatomic, assign, readwrite) NSUInteger pins;
@property (nonatomic, assign, readwrite) NSUInteger collaborators;

@end

@implementation PDKBoard

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _name = dictionary[@"name"];
        _descriptionText = dictionary[@"description"];
        _creator = [PDKUser userFromDictionary:dictionary[@"creator"]];
        
        _followers = [self.counts[@"followers"] unsignedIntegerValue];
        _pins = [self.counts[@"pins"] unsignedIntegerValue];
        _collaborators = [self.counts[@"collaborators"] unsignedIntegerValue];
    }
    return self;
}

+ (instancetype)boardFromDictionary:(NSDictionary *)dictionary
{
    return [[PDKBoard alloc] initWithDictionary:dictionary];
}

@end
