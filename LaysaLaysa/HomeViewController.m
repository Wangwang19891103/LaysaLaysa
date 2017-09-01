//
//  HomeViewController.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "HomeViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"
#import "JSONManager.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import "TopicDetailsViewController.h"
#import "FacebookAccount.h"
#import "GalleriesViewController.h"
#import "MainViewController.h"
#import "HomeTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"
#define FB_CELL_IDENTIFIER @"FB_WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

#define HOME_CELL_ID @"HomeCellIdentifier"

@interface HomeViewController (){

    int countOfcalls;
    UIRefreshControl* refreshControl;
}

@property (nonatomic, strong) NSArray *cellSizes;
@property (nonatomic, strong) NSArray *topics;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    countOfcalls = 0;
    _topics = [[NSArray alloc] init];
    [_topicTable setHidden:YES];
    [JSONManager callHomePage];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:NOTIFICATION_GET_HOME_RESULTS object:nil];
    //init menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.navigationController.navigationBar.topItem.title = @"Home";
    
    self.bannerView.adUnitID = AD_BANNER_ID;
    self.bannerView.rootViewController = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[ @"9fab4848bdff084f127ec91e3fcd43cf" ];
    [self.bannerView loadRequest:request];
    [self.view bringSubviewToFront:self.bannerView];
    
    // Initialize the refresh control.
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self
                       action:@selector(reloadTopics)
             forControlEvents:UIControlEventValueChanged];
    [_topicTable addSubview:refreshControl];
}

-(void)reloadTopics{
    NSArray* shuffledArray = [self shuffle:[[NSMutableArray alloc] initWithArray:_topics]];
    _topics = shuffledArray;
    [_topicTable setHidden:_topics.count <= 0];
    [_topicTable reloadData];
    [refreshControl endRefreshing];
}

-(void)notificationRecieved:(NSNotification*)notification{
    countOfcalls++;
    NSDictionary* topicsDic = (NSDictionary*)[notification object];
    NSArray* newTopics = [self generateTopicsFromDictionary:topicsDic];
    if (_topics.count == 0){
        NSMutableArray* tops = [[NSMutableArray alloc] initWithArray:_topics];
        [tops addObjectsFromArray:newTopics];
        _topics = tops;
    } else {
        if (newTopics.count > 0){
            NSMutableArray* tops = [[NSMutableArray alloc] initWithArray:_topics];
            [tops addObjectsFromArray:newTopics];
//            if (tops.count > 2 && !isFbCellAdded){
//                FacebookAccount* fbAccount = [[FacebookAccount alloc] init];
//                [tops insertObject:fbAccount atIndex:2];
//                isFbCellAdded = YES;
//            }
            _topics = tops;
        }
    }
    if (countOfcalls == 6){
//        [_collectionView setHidden:_topics.count <= 0];
//        [_collectionView reloadData];
        NSArray* shuffledArray = [self shuffle:[[NSMutableArray alloc] initWithArray:_topics]];
        _topics = shuffledArray;
        [_topicTable setHidden:_topics.count <= 0];
        [_topicTable reloadData];
    }
}

-(NSArray*)generateTopicsFromDictionary:(NSDictionary*) topicsDictionary{
    NSMutableArray* topics = [[NSMutableArray alloc] init];
    NSDictionary* tops = [topicsDictionary objectForKey:TOPIC_DICTIONARY];
    NSArray* posts = [tops objectForKey:@"posts"];
    for (NSDictionary* dic in posts){
        Topic* newTopic = [[Topic alloc] init];
        [newTopic setMainTitle:[dic valueForKey:@"title"]];
        NSDictionary* thumbnailsDic = [dic objectForKey:@"thumbnail_images"];
        [newTopic setImageURL:[[thumbnailsDic objectForKey:@"medium_large"] valueForKey:@"url"]];//thumbnail
        [newTopic setLargeImageURL:[[thumbnailsDic objectForKey:@"medium_large"] valueForKey:@"url"]];//large
        NSDictionary* authorDic = [dic objectForKey:@"author"];
        [newTopic setSubTitle:[authorDic valueForKey:@"name"]];
        [newTopic setCreatedDate:[dic valueForKey:@"date"]];
        [newTopic setPageURL:[dic valueForKey:@"url"]];
        [newTopic setContent:[dic valueForKey:@"content"]];
        [newTopic setTopicCategory:[topicsDictionary objectForKey:TOPIC_CATEGORY]];
        [topics addObject:newTopic];
    }
    return topics;
}

- (NSArray*)shuffle:(NSMutableArray*)itemsArray
{
    NSUInteger count = [itemsArray count];
    if (count < 1) return nil;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [itemsArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return itemsArray;
}

#pragma mark UITableview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableCell *cell = (HomeTableCell*)[_topicTable dequeueReusableCellWithIdentifier:HOME_CELL_ID];
    cell.topImage.tag = indexPath.row;
    Topic* topic = [_topics objectAtIndex:indexPath.row];
    [cell setData:topic];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectTopic:)];
    [tapGesture setNumberOfTapsRequired:1];
    [cell.topImage addGestureRecognizer:tapGesture];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height/3;
}

-(void)didSelectTopic:(UITapGestureRecognizer*)sender{
    if (!sender) return;
    //    if ([[_topics objectAtIndex:indexPath.row] isKindOfClass:[FacebookAccount class]]){
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        MainViewController* mainView = [storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    //        [mainView setIsFiveLoading:YES];
    //        [self presentViewController:mainView animated:YES completion:nil];
    //    } else {
    UIImageView *theTappedImageView = (UIImageView *)sender.view;
    Topic* topic = [_topics objectAtIndex:theTappedImageView.tag];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([topic.topicCategory isEqualToString:@"Galleries"]){
        GalleriesViewController* galleriesView = [storyboard instantiateViewControllerWithIdentifier:@"galleriesView"];
        [self presentViewController:galleriesView animated:YES completion:nil];
    } else{
        TopicDetailsViewController* topicDetailsView = [storyboard instantiateViewControllerWithIdentifier:@"topicDetailsView"];
        [topicDetailsView setContent:topic.content];
        [topicDetailsView setTopicTitle:topic.mainTitle];
        [topicDetailsView setImageURL:topic.largeImageURL];
        [topicDetailsView setPageURL:topic.pageURL];
        [topicDetailsView setTopicType:topic.topicCategory];
        [self presentViewController:topicDetailsView animated:YES completion:nil];
    }
    //    }
}

- (NSArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = @[
//                       [NSValue valueWithCGSize:CGSizeMake(400, 550)],
//                       [NSValue valueWithCGSize:CGSizeMake(1000, 665)],
                       [NSValue valueWithCGSize:CGSizeMake(1024, 689)],
                       [NSValue valueWithCGSize:CGSizeMake(640, 427)]
                       ];
    }
    return _cellSizes;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"COUNT - %i", (int)_topics.count);
    return _topics.count;//CELL_COUNT;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ROW - %i", (int)indexPath.row);
//    if ([[_topics objectAtIndex:indexPath.row] isKindOfClass:[FacebookAccount class]]){
//        FacebookCollectionViewCell* cell = (FacebookCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:FB_CELL_IDENTIFIER
//                                                                                                                       forIndexPath:indexPath];
//        
//        return cell;
//    } else {
        CHTCollectionViewWaterfallCell *cell =
        (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                    forIndexPath:indexPath];
        Topic* topic = [_topics objectAtIndex:indexPath.row];
        [cell setData:topic];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:topic.largeImageURL] placeholderImage:[UIImage imageNamed:@"no-thumb.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                if (!CGSizeEqualToSize(topic.imageSize, image.size)) {
//                    if (indexPath.row == _topics.count-2){
//                        topic.imageSize = CGSizeMake(image.size.height, image.size.width - image.size.width/10);
//                    } else {
                        topic.imageSize = image.size;
//                    }
                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            }
        }];
        return cell;
//    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_topics objectAtIndex:indexPath.row] isKindOfClass:[FacebookAccount class]]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController* mainView = [storyboard instantiateViewControllerWithIdentifier:@"mainView"];
        [mainView setIsFiveLoading:YES];
        [self presentViewController:mainView animated:YES completion:nil];
    } else {
        Topic* topic = [_topics objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TopicDetailsViewController* topicDetailsView = [storyboard instantiateViewControllerWithIdentifier:@"topicDetailsView"];
        [topicDetailsView setContent:topic.content];
        [topicDetailsView setTopicTitle:topic.mainTitle];
        [topicDetailsView setImageURL:topic.largeImageURL];
        [topicDetailsView setPageURL:topic.pageURL];
        [topicDetailsView setTopicType:topic.topicCategory];
        [self presentViewController:topicDetailsView animated:YES completion:nil];
    }
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[_topics objectAtIndex:indexPath.row] isKindOfClass:[FacebookAccount class]]){
        return CGSizeMake(400, 550);//400, 550
    } else {
        Topic* topic = [_topics objectAtIndex:indexPath.row];
        if (!CGSizeEqualToSize(topic.imageSize, CGSizeZero)) {
            return topic.imageSize;
        }
        return CGSizeMake(150, 150);
    }
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
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
