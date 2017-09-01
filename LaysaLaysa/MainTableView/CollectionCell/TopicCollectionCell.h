//
//  TopicCollectionCell.h
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface TopicCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView* topicImage;
@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
//@property (strong, nonatomic) IBOutlet UILabel* subTitleLabel;

-(void)setData:(Topic*)topic;

@end
