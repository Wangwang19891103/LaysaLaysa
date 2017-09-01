//
//  FirstViewController.m
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "MainViewController.h"
#import "JSONManager.h"
#import "TopicTableViewCell.h"
#import "Topic.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import "TopicDetailsViewController.h"
#import "MBProgressHUD.h"
#import "TopicCollectionCell.h"

#define CellIdentifier @"topicCellID"
#define TopicCellIdentifier @"TopicCollectionCell"

@interface MainViewController (){

    NSMutableArray* topicsArray;
    int pageCount;
    BOOL isLastTopic;
    
    CGPoint _lastContentOffset;
    
    UIRefreshControl* refreshControl;
    UIRefreshControl* collectionRefreshControl;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isTable = YES;
    collectionCount = 0;
    [_topicTable setHidden:!isTable];
    [_topicCollection setHidden:isTable];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    int size = [UIScreen mainScreen].bounds.size.width/2;
    flow.itemSize = CGSizeMake(size - 20, size/1.6);
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    [flow setSectionInset:UIEdgeInsetsMake(15, 15, 0, 0)];
    _topicCollection.collectionViewLayout = flow;
    //init menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [_topicTable setHidden:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:NOTIFICATION_GET_MAIN_RESULTS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:NOTIFICATION_GET_MORE_RESULTS object:nil];
    if (_isFiveLoading){
        [JSONManager callJSONWithParamethers:nil isNew:true];
        self.navigationController.navigationBar.topItem.title = @"News";
    } else {
        //doing first call to server
        [self reloadTopics];
    }
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    self.bannerView.adUnitID = AD_BANNER_ID;
    self.bannerView.rootViewController = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[ @"9fab4848bdff084f127ec91e3fcd43cf" ];
    [self.bannerView loadRequest:request];
    
    pageCount = 1;
    
    // Initialize the refresh control.
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self
                            action:@selector(reloadTopics)
                  forControlEvents:UIControlEventValueChanged];
    collectionRefreshControl = [[UIRefreshControl alloc] init];
    collectionRefreshControl.backgroundColor = [UIColor whiteColor];
    collectionRefreshControl.tintColor = [UIColor blackColor];
    [collectionRefreshControl addTarget:self
                       action:@selector(reloadTopics)
             forControlEvents:UIControlEventValueChanged];
    [_topicTable addSubview:refreshControl];
    [_topicCollection addSubview:collectionRefreshControl];
}

-(void)reloadTopics{
    if (_topicName != nil){
        NSMutableDictionary* paramethers = [[NSMutableDictionary alloc] init];
        [paramethers setObject:_topicName forKey:@"topic_name"];
        [JSONManager callJSONWithParamethers:paramethers isNew:true];
        self.navigationController.navigationBar.topItem.title = _topicName;
    } else {
        [JSONManager callJSONWithParamethers:nil isNew:true];
        self.navigationController.navigationBar.topItem.title = @"News";
    }
}

-(void)notificationRecieved:(NSNotification*)notification{
    if ([[notification name] isEqualToString:NOTIFICATION_GET_MAIN_RESULTS]){
        NSDictionary* topics = (NSDictionary*)[notification object];
        topicsArray = [[NSMutableArray alloc] initWithArray:[self generateTopicsFromDictionary:topics]];
    }
    if ([[notification name] isEqualToString:NOTIFICATION_GET_MORE_RESULTS]){
        
        NSDictionary* topics = (NSDictionary*)[notification object];
        NSArray* moreTopics = [self generateTopicsFromDictionary:topics];
        if (moreTopics.count > 0){
            [topicsArray addObjectsFromArray:moreTopics];
            isLastTopic = false;
        } else {
            isLastTopic = true;
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (isTable){
        [_topicTable setHidden:!(topicsArray.count > 0)];
        [_loadingView setHidden:(topicsArray.count > 0)];
        [_topicTable reloadData];
    } else {
        collectionCount = 0;
        [_topicTable setHidden:!isTable];
        [_topicCollection setHidden:isTable];
        
        [_topicCollection reloadData];
    }
    [refreshControl endRefreshing];
    [collectionRefreshControl endRefreshing];
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

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onTableSelected:(id)sender{
    isTable = YES;
    collectionCount = 0;
    [_topicTable setHidden:!isTable];
    [_topicCollection setHidden:isTable];
    
    [_topicTable reloadData];
}

-(IBAction)onCollectionSelected:(id)sender{
    isTable = NO;
    collectionCount = 0;
    [_topicTable setHidden:!isTable];
    [_topicCollection setHidden:isTable];
    
    [_topicCollection reloadData];
}

#pragma mark UITableview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topicsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Topic* topic = [topicsArray objectAtIndex:indexPath.row];
    TopicTableViewCell *cell = (TopicTableViewCell*)[_topicTable dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setData:topic];
    
    //Load more topics when scroll down
    if (indexPath.row == [topicsArray count] - 1 && !isLastTopic && !_isFiveLoading)
    {
        [self loadMoreTopics];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Topic* topic = [topicsArray objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TopicDetailsViewController* topicDetailsView = [storyboard instantiateViewControllerWithIdentifier:@"topicDetailsView"];
    [topicDetailsView setContent:topic.content];
    [topicDetailsView setTopicTitle:topic.mainTitle];
    [topicDetailsView setImageURL:topic.largeImageURL];
    [topicDetailsView setPageURL:topic.pageURL];
    [topicDetailsView setTopicType:topic.topicCategory];
    [self presentViewController:topicDetailsView animated:YES completion:nil];
}

-(void)loadMoreTopics{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        pageCount++;
        NSMutableDictionary* paramethers = [[NSMutableDictionary alloc] init];
        if (_topicName == nil){
            [paramethers setObject:@"News" forKey:@"topic_name"];
        } else {
            [paramethers setObject:_topicName forKey:@"topic_name"];
        }
        [paramethers setObject:[NSNumber numberWithInt:pageCount] forKey:@"page_number"];
        [JSONManager callJSONWithParamethers:paramethers isNew:false];
    });
}

#pragma UICollectionView delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return topicsArray.count/2 + topicsArray.count%2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TopicCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopicCellIdentifier forIndexPath:indexPath];
    if (collectionCount < topicsArray.count){
        [cell setData:[topicsArray objectAtIndex:collectionCount]];
        cell.tag = collectionCount;
    }
//    if (collectionCount == [topicsArray count] - 1 && !isLastTopic && !_isFiveLoading){
//        [self loadMoreTopics];
//    }
    collectionCount++;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* selected = [_topicCollection indexPathsForSelectedItems];
    NSIndexPath* path = [selected objectAtIndex:0];
    TopicCollectionCell* cell = (TopicCollectionCell*)[collectionView cellForItemAtIndexPath:path];
    Topic* topic = [topicsArray objectAtIndex:cell.tag];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TopicDetailsViewController* topicDetailsView = [storyboard instantiateViewControllerWithIdentifier:@"topicDetailsView"];
    [topicDetailsView setContent:topic.content];
    [topicDetailsView setTopicTitle:topic.mainTitle];
    [topicDetailsView setImageURL:topic.largeImageURL];
    [topicDetailsView setPageURL:topic.pageURL];
    [topicDetailsView setTopicType:topic.topicCategory];
    [self presentViewController:topicDetailsView animated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        [self loadMoreTopics];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
