//
//  MainTableViewController.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "SidebarTableViewController.h"
#import "MainViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SidebarTableViewController ()

@end

@implementation SidebarTableViewController{
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[@"Logo", @"Home", @"News", @"Reviews", @"Interviews", @"Galleries", @"Trailers", @"Movies", @"Settings", @"Login"];
}

-(IBAction)facebookLogInOut{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"is_fb_login"]){
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"] fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Error FB");
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                } else {
                                    NSLog(@"Logged in");
                                    NSUserDefaults* userdef = [NSUserDefaults standardUserDefaults];
                                    [userdef setBool:YES forKey:@"is_fb_login"];
                                    FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
                                    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
                                    
                                    [connection addRequest:request completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                        
                                        if(result)
                                        {
                                            if ([result objectForKey:@"name"]) {
                                                
                                                NSLog(@"First Name : %@",[result objectForKey:@"name"]);
                                                [userdef setObject:[result objectForKey:@"name"] forKey:@"fb_login_name"];
                                                
                                            }
                                            if ([result objectForKey:@"id"]) {
                                                
                                                NSLog(@"User id : %@",[result objectForKey:@"id"]);
                                                [userdef setObject:[result objectForKey:@"name"] forKey:@"fb_login_id"];
                                                
                                            }
                                            [self performSegueWithIdentifier:@"homeView" sender:self];
                                        }
                                        
                                    }];
                                    
                                    [connection start];
                                    [userdef synchronize];
                                }
                                [self updateList];
                                [self.tableView reloadData];
                            }];
    } else {
        [self fbLogOut];
    }
}

-(void)fbLogOut{
    FBSDKLoginManager* manager = [[FBSDKLoginManager alloc] init];
    [manager logOut];
    NSUserDefaults* userdef = [NSUserDefaults standardUserDefaults];
    [userdef setBool:NO forKey:@"is_fb_login"];
    [userdef removeObjectForKey:@"fb_login_name"];
    [userdef synchronize];
    NSLog(@"Logged out!");
    [self updateList];
    [self.tableView reloadData];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Info" message:@"You are logged out!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([CellIdentifier isEqualToString:@"Login"]){
        UIButton* fbButton = (UIButton*)[cell viewWithTag:1];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_fb_login"]){
            [fbButton setTitle:@"Log out" forState:UIControlStateNormal];
        } else {
            [fbButton setTitle:@"Log in" forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

-(void)updateList{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_fb_login"]){
        menuItems = @[@"Logo", @"Home", @"News", @"Reviews", @"Interviews", @"Galleries", @"Trailers", @"Movies", @"Settings", @"Login"];
    } else {
        menuItems = @[@"Logo", @"Home", @"News", @"Reviews", @"Interviews", @"Galleries", @"Trailers", @"Movies", @"Login"];
    }
}

-(IBAction)laysalaysaButtonClick:(id)sender{
    [self performSegueWithIdentifier:@"homeView" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"topicView"]) {
        UINavigationController *navController = segue.destinationViewController;
        MainViewController *mainController = [navController childViewControllers].firstObject;
        NSString *topicName = [menuItems objectAtIndex:indexPath.row];
        if ([topicName isEqualToString:@"Trailers"]){
            [mainController setTopicName:@"Videos"];
        } else {
            [mainController setTopicName:topicName];
        }
    }
}

@end
