//
//  HomeTableCell.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "HomeTableCell.h"
#import "FacebookAccount.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation HomeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setData:(Topic*)topic{
    [self setImageForTopic:topic andImage:_topImage];
    [self setupLabel:_topLabel topic:topic];
    NSString* mainTitle = [self trimName:topic.mainTitle];
    _titleLabel.text = mainTitle;
}

-(void)setImageForTopic:(Topic*) topic andImage:(UIImageView*) imageView{
    if ([topic isKindOfClass:[FacebookAccount class]]) return;
    [imageView sd_setImageWithURL:[NSURL URLWithString:topic.largeImageURL] placeholderImage:[UIImage imageNamed:@"no-thumb.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

-(void)setupLabel:(UILabel*)label topic:(Topic*) topic{
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = [UIColor whiteColor];
    label.text = topic.topicCategory;
    if ([topic.topicCategory isEqualToString:@"News"]){
        [label setBackgroundColor:[UIColor colorWithRed:100/255.0 green:115/255.0 blue:188/255.0 alpha:1]];
    }
    if ([topic.topicCategory isEqualToString:@"Galleries"]){
        [label setBackgroundColor:[UIColor colorWithRed:104/255.0 green:159/255.0 blue:212/255.0 alpha:1]];
    }
    if ([topic.topicCategory isEqualToString:@"Interviews"]){
        [label setBackgroundColor:[UIColor colorWithRed:190/255.0 green:81/255.0 blue:223/255.0 alpha:1]];
    }
    if ([topic.topicCategory isEqualToString:@"Reviews"]){
        [label setBackgroundColor:[UIColor colorWithRed:127/255.0 green:217/255.0 blue:89/255.0 alpha:1]];
    }
    if ([topic.topicCategory isEqualToString:@"Trailers"]){
        [label setBackgroundColor:[UIColor colorWithRed:104/255.0 green:159/255.0 blue:212/255.0 alpha:1]];
        label.text = @"Videos";
    }
    if ([topic.topicCategory isEqualToString:@"Movies"]) {
        [label setBackgroundColor:[UIColor colorWithRed:104/255.0 green:159/255.0 blue:212/255.0 alpha:1]];
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
