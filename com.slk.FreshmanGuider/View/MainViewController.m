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
//@synthesize isDownloadedNews;
- (void)viewDidLoad {

//    isDownloadedNews=10;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadNews) name:@"reloadnews" object:nil];

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
//    isDownloadedNews = [[[DataManager sharedDataManager]getNews] count];
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
    
    [self addChildViewController:newsTableVC];
    [scrollView addSubview:newsTableView];
    newsTableView.showsVerticalScrollIndicator = NO;

    newsTableView.dataSource=newsTableVC;
    newsTableView.delegate=newsTableVC;
    
    newsTableView.tag=11;
//    newsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UIImageView *newsTabHeadImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WScreen, 185)];
    newsTabHeadImage.image=[UIImage imageNamed:@"image1.jpg"];
    [newsTableView setTableHeaderView:newsTabHeadImage];
    
    
    switchView.ButtonActionBlock=^(int buttonTag){
        
        currentIndex=buttonTag-100;
        [scrollView scrollRectToVisible:CGRectMake(WScreen * (currentIndex-1),0,WScreen,bgViewHeight) animated:NO];
        [scrollView setContentOffset:CGPointMake(WScreen* (currentIndex-1),0)];
        
        if (currentIndex==1) {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
            
        }else if (currentIndex==2){
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
            if (assistTableView==nil) {
                assistTableView=assistTableVC.tableView;
                assistTableVC.view.frame = CGRectMake(WScreen, 0, WScreen, bgViewHeight);
                [self addChildViewController:newsTableVC];
                

                [scrollView addSubview:assistTableView];

                assistTableView.tag=12;

                assistTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                
                
            }

        }else if (currentIndex==3){
            
            UIBarButtonItem *poiListBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(alert)];
            poiListBtn.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem = poiListBtn;
            
            UIBarButtonItem *poiSearchBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(alert)];
            poiSearchBtn.tintColor = [UIColor whiteColor];
            
            self.navigationItem.leftBarButtonItem = poiSearchBtn;
            
            if (navView==nil) {
                
         
                
                navView = navVC.view;
                navVC.view.frame = CGRectMake(WScreen*2, 0, WScreen, bgViewHeight);
                [scrollView addSubview:navView];
                navView.tag = 13;
                
                
            }

        }else if (currentIndex==4){
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)alert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"title" message:@"meddage" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
    [alert show];
}
@end
