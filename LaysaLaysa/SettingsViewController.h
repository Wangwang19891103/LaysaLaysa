//
//  SettingsViewController.h
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//
@import GoogleMobileAds;

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController{

    BOOL isTimeSelected;
    BOOL isFromDate;
}

@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UISwitch* pushSwitch;

@property (strong, nonatomic) IBOutlet UIView* timeView;
@property (strong, nonatomic) IBOutlet UIView* fromTimeView;
@property (strong, nonatomic) IBOutlet UIView* toTimeView;

@property (strong, nonatomic) IBOutlet UIDatePicker* timePicker;

@property (strong, nonatomic) IBOutlet UILabel* fromTimeLabelTop;
@property (strong, nonatomic) IBOutlet UILabel* toTimeLabelTop;
@property (strong, nonatomic) IBOutlet UILabel* fromTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel* toTimeLabel;

@end
