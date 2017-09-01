//
//  SecondViewController.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

@import SafariServices;

#import "TopicDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Social/Social.h>
#import <GooglePlus/GooglePlus.h>
#import "PDKPin.h"
#import "Constants.h"

static NSString * const kClientId = @"573180852941-lsb5sdijnntvdbl0c1lc71i6kkr7kj3g.apps.googleusercontent.com";

@interface TopicDetailsViewController () <SFSafariViewControllerDelegate>

@end

@implementation TopicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [scrollView setScrollEnabled:YES];
    contentView.scrollView.scrollEnabled = NO;
    if (_imageURL != nil){
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imageURL]
                              placeholderImage:[UIImage imageNamed:@"no-thumb.png"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         [imageView setNeedsLayout];
                                     }];

    }
    if (_topicTitle != nil){
        topicTitleLabel.text = [self trimName:_topicTitle];
    }
    if (_content != nil){
        if ([_content rangeOfString:@"https://www.youtube.com/"].location != NSNotFound
            || [_content rangeOfString:@"http://www.youtube.com/"].location != NSNotFound){
            contentView.scalesPageToFit = YES;
            if ([UIScreen mainScreen].bounds.size.width < 400){
                _content = [_content stringByReplacingOccurrencesOfString:@"1170" withString:[NSString stringWithFormat:@"%f", self.view.frame.size.width*2.6 - 5]];
            }
//            _content = [_content stringByReplacingOccurrencesOfString:@"658" withString:[NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.height/3 + 50]];//self.view.frame.size.width
            [contentView setFrame:CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height/3 + 50)];//200
        } else {
            if (_topicType != nil && [_topicType isEqualToString:@"Galleries"]){
                [contentView setFrame:CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, self.view.frame.size.width, _content.length/11)];
                contentView.scalesPageToFit = YES;
            } else {
                [contentView setFrame:CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, self.view.frame.size.width, _content.length/2.0+25)];
                contentView.scalesPageToFit = NO;
            }
        }
        [contentView loadHTMLString:_content baseURL:nil];
        
        [shareView setFrame:CGRectMake(shareView.frame.origin.x, contentView.frame.origin.y + contentView.frame.size.height + 30, shareView.frame.size.width, shareView.frame.size.height)];
        [scrollView setContentSize:CGSizeMake(contentView.frame.size.width, contentView.frame.size.height + imageView.frame.size.height + shareView.frame.size.height + 120)];
    }
    
    self.bannerView.adUnitID = AD_BANNER_ID;
    self.bannerView.rootViewController = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[ @"9fab4848bdff084f127ec91e3fcd43cf" ];
    [self.bannerView loadRequest:request];
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//----------------------- SOCIAL NETWORKS METHODS -----------------------------------------------

- (IBAction)postToTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setTitle:_topicTitle];
        if (_pageURL != nil){
            [tweetSheet addURL:[NSURL URLWithString:_pageURL]];
        }
        [tweetSheet addImage:imageView.image];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction)postToFacebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setTitle:_topicTitle];
        if (_pageURL != nil){
            [controller addURL:[NSURL URLWithString:_pageURL]];
        }
        [controller addImage:imageView.image];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (IBAction)shareGooglePlusButton:(id)sender {
//    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
//    
//    // This line will fill out the title, description, and thumbnail from
//    // the URL that you are sharing and includes a link to that URL.
//    [shareBuilder setURLToShare:[NSURL URLWithString:_pageURL]];
//    
//    [shareBuilder open];
    // Construct the Google+ share URL
    NSURLComponents* urlComponents = [[NSURLComponents alloc]
                                      initWithString:@"https://plus.google.com/share"];
    urlComponents.queryItems = @[[[NSURLQueryItem alloc]
                                  initWithName:@"url"
                                  value:_pageURL]];
    NSURL* url = [urlComponents URL];
    
    if ([SFSafariViewController class]) {
        // Open the URL in SFSafariViewController (iOS 9+)
        SFSafariViewController* controller = [[SFSafariViewController alloc]
                                              initWithURL:url];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        // Open the URL in the device's browser
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (IBAction)postToPinterest:(id)sender {
    [PDKPin pinWithImageURL:[NSURL URLWithString:_imageURL]
                       link:[NSURL URLWithString:_pageURL]
         suggestedBoardName:_topicTitle
                       note:@""
                withSuccess:^
     {
         NSLog(@"successfully pinned pin");
     }
                 andFailure:^(NSError *error)
     {
         NSLog(@"pin it failed");;
     }];
//    PinIt.getInstance().initClientId(PINTEREST_CLIENT_ID);
//    PinIt.getInstance().createPin(_imageURL, _pageURL, _topicTitle);
}

//--------------------------------- END -----------------------------------------------

-(NSString*)trimName:(NSString*)mainTitle{
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8211" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8216" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8217" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
    mainTitle = [mainTitle stringByReplacingOccurrencesOfString:@";" withString:@""];
    return mainTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
