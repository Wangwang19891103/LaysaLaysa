//
//  FirstViewController.h
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

@import GoogleMobileAds;

#import <UIKit/UIKit.h>
#import "SidebarTableViewController.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>{

    BOOL isTable;
    
    int collectionCount;
}

@property (nonatomic, strong) IBOutlet UITableView* topicTable;
@property (nonatomic, strong) IBOutlet UICollectionView* topicCollection;
@property (nonatomic, strong) IBOutlet UIView* loadingView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;

@property (nonatomic, strong) NSString* topicName;

@property (assign, nonatomic) BOOL isFiveLoading;

@end

