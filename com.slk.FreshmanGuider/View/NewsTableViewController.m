//
//  NewsTableViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/6.
//  Copyright © 2015年 Takanashirin. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsTableViewCell.h"
#import "DataManager.h"
#import "newsRecord.h"

#import "NewsDetailViewController.h"
@interface NewsTableViewController (){
    NSMutableArray *data;
    int abcd;
}

@end

@implementation NewsTableViewController

- (void)viewWillAppear:(BOOL)animated{
    abcd = 10;
//    self.view.frame = CGRectMake(WScreen, 0, 100, 100);
    
;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    data = ((DataManager *)[DataManager sharedDataManager]).newsList;

    self.view.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        abcd++;
        [self.tableView reloadData];
        newsRecord *newRec = [[newsRecord alloc]init];
        newRec.title = [NSString stringWithFormat:@"%d title",50-[data count]];
        newRec.newsDate = [NSString stringWithFormat:@"%d detail",50-[data count]];
        
        [data insertObject:newRec atIndex:0];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        abcd++;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];

}
    
- (void)headerRefresh{
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按钮点击提示" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
//    [myAlertView show];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if ([data count] <=1 ) {
        return 1;
    }
    return abcd;
}


- (NewsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:@"newscell"];
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newscell" forIndexPath:indexPath];

    // Configure the cell...
    if ([data count] <= 1) {
        cell.mainLabel.text=[NSString stringWithFormat:@"加载中..."];
        cell.detailLabel.text=[NSString stringWithFormat:@""];
//        cell.mainIV.image=[UIImage imageNamed:@"l1"];

    }
    else{
        cell.mainLabel.text=[NSString stringWithFormat:@"%@",((newsRecord *)data[indexPath.row+1]).title];
        cell.detailLabel.text=[NSString stringWithFormat:@"%@",((newsRecord *)data[indexPath.row+1]).newsDate];
        cell.mainIV.image=[UIImage imageNamed:@"l1"];
    }
    

    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsDetailViewController *newsDetailVC = [sb instantiateViewControllerWithIdentifier:@"NewsDetail"];
    newsDetailVC.URL = ((newsRecord *)data[indexPath.row+1]).link;
    newsDetailVC.title = ((newsRecord *)data[indexPath.row+1]).title;
    NSLog(@"newstable parentVC:%@", NSStringFromClass([self.parentViewController class]));
    [self.parentViewController.navigationController pushViewController:newsDetailVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
