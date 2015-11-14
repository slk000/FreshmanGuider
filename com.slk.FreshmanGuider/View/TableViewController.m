//
//  TableViewController.m
//  NewsDemo
//
//  Created by Takanashirin on 15/11/6.
//  Copyright © 2015年 Takanashirin. All rights reserved.
//

#import "TableViewController.h"
//#import "MyCell.h"
#import "DataManager.h"
#import "newsRecord.h"

@interface TableViewController ()
@end

@implementation TableViewController
//@synthesize tableView = _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;

    self.view.backgroundColor = [UIColor redColor];


    
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按钮点击提示" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    
//    [myAlertView show];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void) didMoveToParentViewController:(UIViewController *)parent{
    
}
- (void) willMoveToParentViewController:(UIViewController *)parent{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按钮点击提示" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [myAlertView show];
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = @"2333";
    if ([(((DataManager *)[DataManager sharedDataManager]).newsList) count] >1) {
        newsRecord *rec = ((newsRecord *)((DataManager *)[DataManager sharedDataManager]).newsList[indexPath.row]);
        cell.textLabel.text = rec.title;
    }
    
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

@end
