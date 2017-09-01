//
//  UICollectionViewWaterfallCell.h
//  Demo
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface CHTCollectionViewWaterfallCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* topicLabel;
@property (nonatomic, strong) UILabel* timeAgo;

-(void)setData:(Topic*)topic;

@end
