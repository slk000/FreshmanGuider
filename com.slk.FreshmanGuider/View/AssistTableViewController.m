//
//  AssistTableViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/14.
//  Copyright © 2015年 Takanashirin. All rights reserved.
//

#import "AssistTableViewController.h"
#import "ChatViewController.h"
@implementation AssistTableViewController
-(void)viewDidLoad{
    _chatBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(show)];

}
-(void)show{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *chatVC = [sb instantiateViewControllerWithIdentifier:@"chatview"];
//    [self.navigationController pushViewController:chatVC animated:YES];
    [self presentViewController:chatVC animated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
