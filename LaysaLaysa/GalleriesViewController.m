//
//  GalleriesViewController.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "GalleriesViewController.h"
#import "Constants/Constants.h"
#import "SWRevealViewController.h"

@implementation GalleriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView.adUnitID = AD_BANNER_ID;
    self.bannerView.rootViewController = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[ @"9fab4848bdff084f127ec91e3fcd43cf" ];
    [self.bannerView loadRequest:request];
    [self.view bringSubviewToFront:self.bannerView];
    
    self.navigationController.navigationBar.topItem.title = @"Galleries";
    
    //init menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //load Galleries url
    NSURL*url=[NSURL URLWithString:@"http://laysalaysa.com/category/galleryapps/"];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
    
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
