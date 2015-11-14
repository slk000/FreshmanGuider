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
    
//    self.view.backgroundColor = [UIColor redColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    data = ((DataManager *)[DataManager sharedDataManager]).newsList;
//    data = [[NSMutableArray alloc]initWithCapacity:50];
//    for (int i = 0; i < 50; i++) {
//        [data addObject:[NSString stringWithFormat:@"%d", i]];
//    }
//    [data addObject:nil];
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
    return abcd;
}


- (NewsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:@"newscell"];
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newscell" forIndexPath:indexPath];

    
    // Configure the cell...

    cell.mainLabel.text=[NSString stringWithFormat:@"%@ title",((newsRecord *)data[indexPath.row]).title];
    cell.detailLabel.text=[NSString stringWithFormat:@"%@ detail",((newsRecord *)data[indexPath.row]).newsDate];
    cell.mainIV.image=[UIImage imageNamed:@"l1"];

    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
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
