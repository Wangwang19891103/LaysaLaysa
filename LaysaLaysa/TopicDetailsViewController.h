//
//  SecondViewController.h
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

@import GoogleMobileAds;

#import <UIKit/UIKit.h>

@interface TopicDetailsViewController : UIViewController <UIScrollViewDelegate>{

    IBOutlet UIImageView* imageView;
    IBOutlet UILabel* topicTitleLabel;
    IBOutlet UIWebView* contentView;
    IBOutlet UIScrollView* scrollView;
    
    IBOutlet UIView* shareView;
}

@property (nonatomic, strong) NSString* topicTitle;
@property (nonatomic, strong) NSString* imageURL;
@property (nonatomic, strong) NSString* pageURL;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* topicType;

@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;


@end

