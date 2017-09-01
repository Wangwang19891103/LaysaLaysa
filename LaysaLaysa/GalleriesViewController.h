//
//  GalleriesViewController.h
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

@import GoogleMobileAds;

#import <UIKit/UIKit.h>

@interface GalleriesViewController : UIViewController

@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UIWebView* webView;

@end
