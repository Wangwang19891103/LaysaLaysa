//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "PDKImageInfo.h"

@interface PDKImageInfo()

@property (nonatomic, assign, readwrite) CGFloat width;
@property (nonatomic, assign, readwrite) CGFloat height;
@property (nonatomic, copy, readwrite) NSURL *url;
@end

@implementation PDKImageInfo

+ (instancetype)imageFromDictionary:(NSDictionary *)dictionary
{
    PDKImageInfo *image = [[PDKImageInfo alloc] init];
    image.width = [dictionary[@"width"] floatValue];
    image.height = [dictionary[@"height"] floatValue];
    if ([dictionary[@"url"] isKindOfClass:[NSString class]]) {
        image.url = [NSURL URLWithString:dictionary[@"url"]];
    }
    return image;
}

@end
