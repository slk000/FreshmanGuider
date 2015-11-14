//
//  AssistTableViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/14.
//  Copyright © 2015年 Takanashirin. All rights reserved.
//

#import "AssistTableViewController.h"

@implementation AssistTableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    // Configure the cell...
    
    cell.textLabel.text = @"2333";
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
@end
