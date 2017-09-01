//
//  HomeViewController.h
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//
@import GoogleMobileAds;

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

@interface HomeViewController : UIViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, UITableViewDelegate, UITableViewDataSource>{

    BOOL isFbCellAdded;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *topicTable;

@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;

@end
