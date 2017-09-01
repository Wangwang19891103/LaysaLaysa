//
//  SettingsViewController.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController.h"
#import "JTMaterialSwitch.h"
#import "Constants.h"

@interface SettingsViewController (){

    NSDate* fromDate;
    NSDate* toDate;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"Settings";
    
    self.bannerView.adUnitID = AD_BANNER_ID;
    self.bannerView.rootViewController = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[ @"9fab4848bdff084f127ec91e3fcd43cf" ];
    [self.bannerView loadRequest:request];
    [self.view bringSubviewToFront:self.bannerView];
    
    fromDate = [[NSDate alloc] init];
    NSDate* fromDateSaved = [self getTimeForKey:@"From_Time"];
    if (fromDateSaved){
        fromDate = fromDateSaved;
    } else {
        NSDate *date = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
        [components setHour: 22];
        [components setMinute: 00];
        fromDate = [gregorian dateFromComponents: components];
    }
    
    NSDate* toDateSaved = [self getTimeForKey:@"To_Time"];
    if (toDateSaved){
        toDate = toDateSaved;
    } else {
        NSDate *date = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
        date = [NSDate date];
        [components setHour: 7];
        [components setMinute: 00];
        toDate = [gregorian dateFromComponents: components];
    }
    _fromTimeLabel.text = [NSString stringWithFormat:@"From %@", [self getTimeString:fromDate]];
    _fromTimeLabelTop.text = [self getTimeString:fromDate];
    _toTimeLabel.text = [NSString stringWithFormat:@"From %@", [self getTimeString:toDate]];
    _toTimeLabelTop.text = [self getTimeString:toDate];
    
    [_timePicker addTarget:self action:@selector(timeIsChanged:) forControlEvents:UIControlEventValueChanged];
    
    //init menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [_pushSwitch setOn:[[UIApplication sharedApplication] isRegisteredForRemoteNotifications]];
    //Init switch
    JTMaterialSwitch *jswStatus = [[JTMaterialSwitch alloc] init];
    jswStatus.center = [_pushSwitch center];
    [jswStatus setOn:_pushSwitch.isOn animated:YES];
    [jswStatus addTarget:self action:@selector(onUserTypeSelected:) forControlEvents:UIControlEventValueChanged];
    if (!_pushSwitch.isOn){
        jswStatus.thumbOnTintColor = [UIColor redColor];
        jswStatus.thumbOffTintColor = [UIColor redColor];
        jswStatus.trackOnTintColor = [UIColor redColor];
        jswStatus.trackOffTintColor = [UIColor redColor];
    } else {
        [self initSwitchProperty:jswStatus];
    }
    _pushSwitch.hidden = YES;
    [self.view addSubview:jswStatus];
    UITapGestureRecognizer* fromDateTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fromDateSelected)];
    [fromDateTapGesture setNumberOfTapsRequired:1];
    UITapGestureRecognizer* toDateTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toDateSelected)];
    [toDateTapGesture setNumberOfTapsRequired:1];
    [_fromTimeView addGestureRecognizer:fromDateTapGesture];
    [_toTimeView addGestureRecognizer:toDateTapGesture];
    
}

- (void) initSwitchProperty:(JTMaterialSwitch*) jtSwitch {
    jtSwitch.thumbOnTintColor = [UIColor greenColor];
    jtSwitch.thumbOffTintColor = [UIColor redColor];
    jtSwitch.trackOnTintColor = [UIColor greenColor];
    jtSwitch.trackOffTintColor = [UIColor redColor];
}

-(void)onUserTypeSelected:(id)sender{
    JTMaterialSwitch *userType = sender;
    [self initSwitchProperty:userType];
    [self pushEnabled:userType.getSwitchState];
    [_timeView setHidden:!userType.getSwitchState];
}

-(void)pushEnabled:(BOOL)isEnabled{

    if (isEnabled){//turn on
        if ([[UIApplication sharedApplication]respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // For iOS 8 and above
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            // For iOS < 8
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
    } else {//turn off
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

-(void)fromDateSelected{
    isTimeSelected = YES;
    isFromDate = YES;
    [_fromTimeView setBackgroundColor:[UIColor lightGrayColor]];
    [_toTimeView setBackgroundColor:[UIColor whiteColor]];
    [_timePicker setDate:fromDate];
}

-(void)toDateSelected{
    isTimeSelected = YES;
    isFromDate = NO;
    [_fromTimeView setBackgroundColor:[UIColor whiteColor]];
    [_toTimeView setBackgroundColor:[UIColor lightGrayColor]];
    [_timePicker setDate:toDate];
}

- (void)timeIsChanged:(id)sender{
    if (!isTimeSelected)return;
    if (isFromDate){
        fromDate = _timePicker.date;
        _fromTimeLabel.text = [NSString stringWithFormat:@"From %@", [self getTimeString:fromDate]];
        _fromTimeLabelTop.text = [self getTimeString:fromDate];
        [self saveTime:fromDate forKey:@"From_Time"];
    } else {
        toDate = _timePicker.date;
        _toTimeLabel.text = [NSString stringWithFormat:@"To %@", [self getTimeString:toDate]];
        _toTimeLabelTop.text = [self getTimeString:toDate];
        [self saveTime:toDate forKey:@"To_Time"];
    }
}

-(BOOL)is12Hours{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    
    if([[dateFormatter dateFormat] rangeOfString:@"a"].location != NSNotFound) {
        // user prefers 12 hour clock
        return YES;
    } else {
        // user prefers 24 hour clock
        return NO;
    }
}

-(NSString*)getTimeString:(NSDate*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [self is12Hours] ? [dateFormat setDateFormat:@"HH:mm"] : [dateFormat setDateFormat:@"HH:mm a"];
    return [dateFormat stringFromDate:date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveTime:(NSDate*)date forKey:(NSString*)key{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:date forKey:key];
    [userDef synchronize];
}

-(NSDate*)getTimeForKey:(NSString*)key{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSDate* date = [userDef objectForKey:key];
    [userDef synchronize];
    return date;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
