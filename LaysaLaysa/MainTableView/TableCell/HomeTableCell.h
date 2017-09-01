//
//  HomeTableCell.h
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface HomeTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView* topImage;
@property (nonatomic, strong) IBOutlet UILabel* topLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

-(void)setData:(Topic*)topic;

@end
