//
//  Topic.h
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Topic : NSObject

@property (nonatomic, strong) NSString* imageURL;
@property (nonatomic, strong) NSString* largeImageURL;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) NSString* pageURL;
@property (nonatomic, strong) NSString* mainTitle;
@property (nonatomic, strong) NSString* subTitle;
@property (nonatomic, strong) NSString* createdDate;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* topicCategory;

@end
