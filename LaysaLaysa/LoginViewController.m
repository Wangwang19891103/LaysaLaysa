//
//  LoginViewController.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//
#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _getStartedButton.clipsToBounds = YES;
    _getStartedButton.layer.cornerRadius = 4.0;
    _getStartedButton.layer.borderColor = [UIColor blueColor].CGColor;
    _getStartedButton.layer.borderWidth = 2.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
