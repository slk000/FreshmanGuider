//
//  ViewController.m
//  NewsDemo
//
//  Created by Takanashirin on 15/2/9.
//  Copyright (c) 2015年 Takanashirin. All rights reserved.
//



#import "NewsTableViewCell.h"

#import "DataManager.h"
#import "newsRecord.h"

#import "SwitchView.h"
#import "MainViewController.h"
#import "NewsTableViewController.h"
#import "NavViewController.h"
#import "AssistTableViewController.h"
#import "ProfileTableViewController.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIScrollView *scrollView;
    int currentIndex;
    UITableView *newsTableView;
    UITableView *assistTableView;
    UIView *navView;
    UITableView *profileTableView;
    float titleHeight;
    float bgViewHeight;
    SwitchView *switchView;
    
//    NavViewController *newsVC;
    
    NewsTableViewController *newsTableVC; //Tab 1
    NavViewController *navVC;
    AssistTableViewController *assistTableVC;
    ProfileTableViewController *profileVC;
    
    
    
}

@end

@implementation MainViewController
@synthesize isDownloadedNews;
- (void)viewDidLoad {
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadNews) name:@"reloadnews" object:nil];
    isDownloadedNews=10;

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    newsVC = [[NavViewController alloc]init];
    newsTableVC = [[NewsTableViewController alloc]init];
    navVC = [[NavViewController alloc]init];
    assistTableVC = [[AssistTableViewController alloc]init];
    profileVC = [[ProfileTableViewController alloc]init];
    
    
    [self initTitle];
    
    titleHeight=35;
    bgViewHeight=HScreen-64-titleHeight;
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
        
    }
    self.view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
   
    switchView=[[SwitchView alloc] initWithFrame:CGRectMake(0, 0, WScreen, titleHeight)];
    [self.view addSubview:switchView];

    [self initScroll];
    [self initTable];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        while (isDownloadedNews == NO) {
//        [tableView1 reloadData];
        //UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按钮点击提示" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        }
        //[myAlertView show];
        //NSLog(@"tttt");
        
//    });


}
- (void)reloadNews{
    NSLog(@"Notification");
    isDownloadedNews = [[[DataManager sharedDataManager]getNews] count];
    [newsTableView reloadData];
}
-(void)initTitle{
    UILabel *AppTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    AppTitle.backgroundColor = [UIColor clearColor];
    
    AppTitle.font = [UIFont boldSystemFontOfSize:20];
    
    AppTitle.textColor = [UIColor whiteColor];
    
    AppTitle.textAlignment = NSTextAlignmentCenter;
    
    AppTitle.text = @"FreshmanGuider";
    self.navigationItem.titleView = AppTitle;

    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadNews)];
    self.navigationItem.leftBarButtonItem = btn;
}
-(void)initScroll{
 
   
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleHeight, WScreen, bgViewHeight)];
    scrollView.alwaysBounceHorizontal=YES;
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.canCancelContentTouches = NO;//防止scrollview干扰地图拖放
    [self.view addSubview:scrollView];
    
    [scrollView setContentSize:CGSizeMake(WScreen * (4), bgViewHeight)];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [scrollView scrollRectToVisible:CGRectMake(0,0,WScreen,bgViewHeight) animated:NO];
    
}

-(void)initTable{
    
    
//    tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WScreen, bgViewHeight) style:UITableViewStylePlain];
    newsTableView = newsTableVC.tableView;
    newsTableVC.view.frame = CGRectMake(0, 0, WScreen, bgViewHeight);
    
    [scrollView addSubview:newsTableView];
    newsTableView.showsVerticalScrollIndicator = NO;
    [newsTableView setDelegate:self];
    [newsTableView setDataSource:self];
//    tableView1.dataSource=self;
//    tableView1.delegate=self;
    newsTableView.tag=11;
    newsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UIImageView *newsTabHeadImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WScreen, 185)];
    newsTabHeadImage.image=[UIImage imageNamed:@"image1.jpg"];
    [newsTableView setTableHeaderView:newsTabHeadImage];
    
    
    switchView.ButtonActionBlock=^(int buttonTag){
        
        currentIndex=buttonTag-100;
        [scrollView scrollRectToVisible:CGRectMake(WScreen * (currentIndex-1),0,WScreen,bgViewHeight) animated:NO];
        [scrollView setContentOffset:CGPointMake(WScreen* (currentIndex-1),0)];
        
        if (currentIndex==1) {
            
            
        }else if (currentIndex==2){
            if (assistTableView==nil) {
//                tableView2=[[UITableView alloc] initWithFrame:CGRectMake(WScreen, 0, WScreen, bgViewHeight) style:UITableViewStylePlain];
                assistTableView=assistTableVC.tableView;
                assistTableVC.view.frame = CGRectMake(WScreen, 0, WScreen, bgViewHeight);
                [self addChildViewController:newsTableVC];
                

//                tableView2.frame = CGRectMake(WScreen, 0, WScreen, bgViewHeight);
//                [tableView2 registerClass:[newsTableVC.tableView  forCellReuseIdentifier:@"reuseIdentifier"];
                [scrollView addSubview:assistTableView];
                
//                [vct didMoveToParentViewController:scrollView];
//
//                tableView2.showsVerticalScrollIndicator = NO;
////
                assistTableView.tag=12;
//                [assistTableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:@"newscell"];


//                tableView2.dataSource=newsTableVC;
//                tableView2.delegate=newsTableVC;
                assistTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                
                
            }

        }else if (currentIndex==3){
            if (navView==nil) {
                
                navView = navVC.view;
                navVC.view.frame = CGRectMake(WScreen*2, 0, WScreen, bgViewHeight);
                [scrollView addSubview:navView];
                navView.tag = 13;
                
                
            }

        }else if (currentIndex==4){
            if (profileTableView==nil) {
//                profileTableView=[[UITableView alloc] initWithFrame:CGRectMake(WScreen*3, 0, WScreen, bgViewHeight) style:UITableViewStylePlain];
                profileTableView = profileVC.tableView;
                profileVC.view.frame=CGRectMake(WScreen*3, 0, WScreen, bgViewHeight);
                [scrollView addSubview:profileTableView];
                profileTableView.showsVerticalScrollIndicator = NO;

                UIImageView *title4=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WScreen, 185)];
                title4.image=[UIImage imageNamed:@"image1.jpg"];
                [profileTableView setTableHeaderView:title4];
                
                
                profileTableView.tag=14;
                
//                profileTableView.dataSource=self;
//                profileTableView.delegate=self;
                profileTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                
            }

        }
        
        
    };
    
    currentIndex=1;
    
    
}


#pragma mark scrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    CGFloat pagewidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pagewidth/ (4)) / pagewidth) + 1;
    
    if (currentPage==0)
    {
 
        [scrollView scrollRectToVisible:CGRectMake(0,0,WScreen,bgViewHeight) animated:NO];
        [scrollView setContentOffset:CGPointMake(0,0)];
    }
    else if (currentPage==(3))
    {
    
        [scrollView scrollRectToVisible:CGRectMake(WScreen * 3,0,WScreen,bgViewHeight) animated:NO];
        [scrollView setContentOffset:CGPointMake(WScreen* 3,0)];
    }
   
    currentIndex=currentPage+1;
  
    [switchView swipeAction:(100+currentPage+1)];
    
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==11) {
        return isDownloadedNews;
    }else if (tableView.tag==12){
        return 1;
        
    }else if (tableView.tag==13){
        return 41;
        
    }else if (tableView.tag==14){
        
        return 21;
    }
    return 11;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView.tag==11) {
  
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id1"];
        
        
        if (cell == nil) {
            cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id1"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
        }
        // Configure the cell...
        cell.mainIV.image=[UIImage imageNamed:@"l1"];
        cell.mainLabel.text=@"塞浦路斯将为俄供海外基地";
        cell.detailLabel.text=@"该基地距离英军安克罗蒂里空军基地仅50公里。";

        if ([(((DataManager *)[DataManager sharedDataManager]).newsList) count] >1) {
            newsRecord *rec = ((newsRecord *)((DataManager *)[DataManager sharedDataManager]).newsList[indexPath.row]);
            cell.mainLabel.text = rec.title;
            cell.detailLabel.text=rec.newsDate;
        }
        
        return cell;
        
    }else if (tableView.tag==12){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id2"];
            cell.contentView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WScreen, 8)];
            [cell.contentView addSubview:lineView];
            lineView.backgroundColor=[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
        }
        // Configure the cell...
        cell.textLabel.text=@"我小时偷西瓜，爪农来了。大一点的跑了，我也要跑，可太小跳不过水沟，刚哭，爪农就说不要跳，小心掉下去。后来还是爪农抱我过去，还把我偷的不熟西瓜拿了，换了个好的给我。谢谢了哈";
        cell.textLabel.numberOfLines=0;
        return cell;
        
        
        
    }else if (tableView.tag==13){
        
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id1"];
        
        
        if (cell == nil) {
            cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id1"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
        }
        // Configure the cell...
        cell.mainIV.image=[UIImage imageNamed:@"l2"];
        cell.mainLabel.text=@"日：疑似朝5枚导弹坠入日本海";
        cell.detailLabel.text=@"该导弹发射前无需注入燃料，外界事前较难掌握动向。";
        return cell;
        
        
        
    }else if (tableView.tag==14){
        
        
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id1"];
        
        
        if (cell == nil) {
            cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id1"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
        }
        // Configure the cell...
        cell.mainIV.image=[UIImage imageNamed:@"l3"];
        cell.mainLabel.text=@"美公布高超声速武器失败原因";
        cell.detailLabel.text=@"调查组认为用于调节发动机温度的设备发生故障。";
        return cell;
        
        
        
    }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==11) {
        return 100;
    }else if (tableView.tag==12){
        return 170;
        
    }else if (tableView.tag==13){
        return 100;
        
    }else if (tableView.tag==14){
        
        return 100;
    }
    return 11;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
