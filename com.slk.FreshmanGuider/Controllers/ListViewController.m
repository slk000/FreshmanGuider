//
//  ListViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/10/11.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "ListViewController.h"
#import "newsRecord.h"
#import "DataManager.h"
#import "NewsCell.h"
@interface ListViewController ()
@property (strong, nonatomic) NSDictionary *editedSelection;
//@property (strong, nonatomic) IBOutlet UITableView *abcd


@end

@implementation ListViewController
@synthesize newsArray;
@synthesize editedSelection;

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.Button setTitle:@"233" forState:UIControlStateNormal];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Horse",@"Sheep",@"Pig",@"Dog",@"Cat",@"Chicken",@"Duck",@"Goose",@"Tree",@"Flower",@"Grass",@"Fence",@"House",@"Table",@"Chair",@"Book",@"Swing", nil];
    
    //self.newsArray = array;
    newsArray = [[DataManager sharedDataManager]getNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    NSLog(@"newsArrayCoun: %lu\n", (unsigned long)[newsArray count]);
    NSInteger newsCount = [newsArray count];
    return newsCount?newsCount:8;
}



- (NewsCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger newsCount = [newsArray count];
    NSUInteger row = [indexPath row];
    NSString *identifier = @"NewsCell";
    //(row%2==0)?identifier = @"RedIdentifier":@"GreenIdentifier";
//    if (row%2==0) {
//        identifier = @"RedIdentifier";
//    }
//    else {
//        identifier = @"GreenIdentifier";
//    }
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RedIdentifier"];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GreenIdentifier"];
    
    NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    tableView.rowHeight = 66;
//    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
//    UILabel *dateLabel = (UILabel *)[cell viewWithTag:2];
//    UIButton *tmpButton = (UIButton *)[cell viewWithTag:0];
//    cell.titleLabel.tag=row;
    newsRecord *tmp = [newsArray objectAtIndex:row];
    NSLog(@"t: %@", tmp.title);
    cell.titleLabel.text = tmp.title;
    cell.dateLabel.text = tmp.newsDate;
//    cell.dateLabel.backgroundColor = [UIColor redColor];
    // Configure the cell...
    
    //从网络得到数据并处理后
//    if (newsCount > 0) {
//        NSLog(@"show news\n");
//        newsRecord *currentNews = [self.newsArray objectAtIndex:indexPath.row];
//        cellLabel.text = currentNews.title;
//    }
    
    return cell;
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    UIViewController *destination = [segue destinationViewController];
//    
//    if ([destination respondsToSelector:@selector(setPreviewController:)]) {
//        [destination setValue:self forKey:@"preViewController"];
//    }
//    if ([destination respondsToSelector:@selector(setSelection:)]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        id object = [self.newsArray objectAtIndex:indexPath.row];
//        NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys:indexPath, @"indexPath",object,@"object", nil];
//        [destination setValue:selection forKey:@"selection"];
//    }
//}
//
//- (void)setEditedSelection:(NSDictionary *)dict{
//    if (![dict isEqual:editedSelection]) {
//        editedSelection = dict;
//        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
//        id newValue = [dict objectForKey:@"object"];
//        [newsArray replaceObjectAtIndex:indexPath.row withObject:newValue];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//    }
//}
- (IBAction)t:(id)sender {
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按钮点击提示" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
//    [myAlertView show];
//    [self.newsArray addObject:@"1"];
    
//    NSLog(@"%@", self.newsArray);
//    NSLog(@"slk:%@", self.newsArray);
//    for (newsRecord *rec in [[DataManager sharedDataManager]getNews]) {
//        NSLog(@"%@", rec);
//    }
    newsRecord *tmp = [[newsRecord alloc]init];
    tmp.title = @"tmp title";
    tmp.newsDate = @"tmp date";
    [((DataManager *)[DataManager sharedDataManager]).newsList addObject:tmp];
    NSLog(@"%@", ((DataManager *)[DataManager sharedDataManager]).newsList);
                                                printf("db add in view: %p", [DataManager sharedDataManager]);
    
    [self.tableView reloadData];
    
    
    
}

@end
