//
//  FacebookCollectionViewCell.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "FacebookTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FacebookTableViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [UIColor colorWithRed:173/255.0 green:37/255.0 blue:63/255.0 alpha:1];
    
    UIImageView* personIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [personIcon setImage:[UIImage imageNamed:@"fb_person_icon.png"]];
    
    //Load image from FB
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                NSURL *url = [[NSURL alloc] initWithString:imageStringOfLoginUser];
                NSData* imageData = [[NSData alloc] initWithContentsOfURL:url];
                [personIcon setImage:[UIImage imageWithData:imageData]];
                personIcon.layer.borderColor = [UIColor whiteColor].CGColor;
                personIcon.layer.borderWidth = 3.0f;
                personIcon.layer.cornerRadius = personIcon.frame.size.height/2;
                [personIcon.layer setMasksToBounds:YES];
            }
        }];
    }
    
    UILabel* helloLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, personIcon.frame.size.height + 20, self.frame.size.width - 20, 40)];
    NSString* fbName = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_login_name"];
    fbName = fbName != nil ? fbName : @"";
    [helloLabel setText:[NSString stringWithFormat:@"Hello %@,", fbName]];
    [helloLabel setNumberOfLines:2];
    [helloLabel setTextColor:[UIColor whiteColor]];
    [helloLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    UILabel* picksLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, helloLabel.frame.origin.y + helloLabel.frame.size.height, self.frame.size.width, 20)];
    [picksLabel setText:@"Today's picks"];
    [picksLabel setTextColor:[UIColor whiteColor]];
    [picksLabel setFont:[UIFont systemFontOfSize:16]];
    
    UILabel* latestUpdatesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2 + 20, self.frame.size.width, 60)];
    [latestUpdatesLabel setText:@"Your Latest Updates."];
    [latestUpdatesLabel setNumberOfLines:2];
    [latestUpdatesLabel setTextColor:[UIColor whiteColor]];
    [latestUpdatesLabel setFont:[UIFont systemFontOfSize:24]];
    
    UIButton* itemsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 20)];
    [itemsButton setTitle:@"5 items in your feed." forState:UIControlStateNormal];
    itemsButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [itemsButton.titleLabel setTextAlignment: NSTextAlignmentLeft];
    
    [self addSubview:personIcon];
    [self addSubview:helloLabel];
    [self addSubview:picksLabel];
    [self addSubview:latestUpdatesLabel];
    [self addSubview:itemsButton];
}

@end
