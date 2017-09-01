//
//  TopicCollectionCell.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "TopicCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TopicCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setData:(Topic*)topic{
    NSString* mainTitle = [self trimName:topic.mainTitle];
    _titleLabel.text = mainTitle;
    [_titleLabel setHidden:NO];
//    NSString* timeAgo = [self getTimeAgo:topic.createdDate];
//    _subTitleLabel.text = [NSString stringWithFormat:@"%@ \n%@", topic.subTitle, timeAgo];
    [self loadImageAsync:topic];
}

-(void)loadImageAsync:(Topic*)topic{
    _topicImage.contentMode = UIViewContentModeScaleToFill;
    NSString* imageURL = topic.largeImageURL;
    if (![imageURL isKindOfClass:[NSNull class]]){
        [_topicImage sd_setImageWithURL:[NSURL URLWithString:imageURL]
                       placeholderImage:[UIImage imageNamed:@"no-thumb.png"]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  //                                     [self setNeedsLayout];
                              }];
    }
}

-(NSString*)trimName:(NSString*)mainTitle{
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8211" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8216" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8217" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@";" withString:@""];
    return mainTitle;
}

@end
