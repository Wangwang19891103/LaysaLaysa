//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"
#import "NSDate+NVTimeAgo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CHTCollectionViewWaterfallCell


-(void)setData:(Topic*)topic{
    self.backgroundColor = [UIColor blackColor];
    if (_titleLabel != nil){
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    if (_topicLabel != nil){
        [_topicLabel removeFromSuperview];
        _topicLabel = nil;
    }
    if (_timeAgo != nil){
        [_timeAgo removeFromSuperview];
        _timeAgo = nil;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2.5, self.frame.size.width-5, self.frame.size.height/2)];
    [_titleLabel setNumberOfLines:3];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.shadowColor = [UIColor blackColor];
    _titleLabel.shadowOffset = CGSizeMake(0,1);
//    [self addSubview:_titleLabel];
    NSString* mainTitle = [self trimName:topic.mainTitle];
    _titleLabel.text = mainTitle;
    
    _topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, topic.topicCategory.length + 55, 15)];
    [_topicLabel setNumberOfLines:3];
    [_topicLabel setFont:[UIFont systemFontOfSize:12]];
    [_topicLabel setTextAlignment:NSTextAlignmentCenter];
    _topicLabel.textColor = [UIColor whiteColor];
    _topicLabel.text = topic.topicCategory;
    if ([topic.topicCategory isEqualToString:@"News"]){
        [_topicLabel setBackgroundColor:[UIColor colorWithRed:100/255.0 green:115/255.0 blue:188/255.0 alpha:1]];
    }
    if ([topic.topicCategory isEqualToString:@"Galleries"]){
        [_topicLabel setBackgroundColor:[UIColor colorWithRed:104/255.0 green:159/255.0 blue:212/255.0 alpha:1]];
    }
    if ([topic.topicCategory isEqualToString:@"Interviews"]){
        [_topicLabel setBackgroundColor:[UIColor colorWithRed:190/255.0 green:81/255.0 blue:223/255.0 alpha:1]];
    }
    if ([topic.topicCategory isEqualToString:@"Reviews"]){
        [_topicLabel setBackgroundColor:[UIColor colorWithRed:127/255.0 green:217/255.0 blue:89/255.0 alpha:1]];
    }
    if ([topic.topicCategory isEqualToString:@"Trailers"]){
        [_topicLabel setBackgroundColor:[UIColor colorWithRed:104/255.0 green:159/255.0 blue:212/255.0 alpha:1]];
    }
    if ([topic.topicCategory isEqualToString:@"Movies"]) {
        [_topicLabel setBackgroundColor:[UIColor colorWithRed:104/255.0 green:159/255.0 blue:212/255.0 alpha:1]];
    }
    
    [self addSubview:_topicLabel];
    
    _timeAgo = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 20, self.frame.size.width, 15)];
    [_timeAgo setNumberOfLines:0];
    [_timeAgo setFont:[UIFont systemFontOfSize:12]];
    [_timeAgo setTextAlignment:NSTextAlignmentLeft];
    _timeAgo.textColor = [UIColor colorWithRed:173/255.0 green:37/255.0 blue:63/255.0 alpha:1];
    _timeAgo.text = [self getTimeAgo:topic.createdDate];
//    [self addSubview:_timeAgo];

//    [self loadImageAsync:topic.largeImageURL];
}

-(void)loadImageAsync:(NSString*) imageURL{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView setNeedsLayout];
    //    self.imageView.clipsToBounds = YES;
    if (![imageURL isKindOfClass:[NSNull class]]){
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                          placeholderImage:[UIImage imageNamed:@"no-thumb.png"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     [self setNeedsLayout];
                                 }];
    }
}

-(NSString*)getTimeAgo:(NSString*)createdTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:createdTime];
    return [date formattedAsTimeAgo];
}

-(NSString*)trimName:(NSString*)mainTitle{
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8211" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8216" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8217" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@";" withString:@""];
    return mainTitle;
}

#pragma mark - Accessors
- (UIImageView *)imageView {
  if (!_imageView) {
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _imageView.contentMode = UIViewContentModeScaleAspectFit;
  }
  return _imageView;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self.contentView addSubview:self.imageView];
  }
  return self;
}

@end
