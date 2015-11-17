//
//  ProfileTableViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/14.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "LoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface ProfileTableViewController (){

    IBOutlet UITableView *tableview;
    AVUser *currentUser;
    LoginViewController *loginVC;
}

@end
@implementation ProfileTableViewController

-(void) viewDidLoad
{
    currentUser = [AVUser currentUser];
    
    
    [super viewDidLoad];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    loginVC = [sb instantiateViewControllerWithIdentifier:@"loginview"];

    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource=self;
    
    
}
-(void) viewWillAppear:(BOOL)animated{
//    [[[UIAlertView alloc]initWithTitle:@"T" message:@"m" delegate:nil cancelButtonTitle:@"c" otherButtonTitles: nil]show];
    self.parentViewController.navigationItem.leftBarButtonItem = self.parentViewController.navigationItem.rightBarButtonItem = nil;
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 2:
            return 1;
            break;
        default:
            return 3;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 100;
            break;
        
        default:
            return 44;
            break;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%ld",(long)section];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            if (!currentUser)
                [self presentViewController:loginVC animated:YES completion:nil];

            break;
        }
        case 2:
        {
            bool oldStatus = (bool)currentUser;
            [AVUser logOut];  //清除缓存用户对象
            currentUser = [AVUser currentUser];
            [self.tableView reloadData];
            if (oldStatus && !currentUser) {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"注销成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }
            
        }
            
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc]init];
    currentUser = [AVUser currentUser];
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profilecell"];

    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = (currentUser==nil?@"请登录":[NSString stringWithFormat:@"欢迎%@使用", currentUser.username]);
            break;
            
        default:
            cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section,(long)indexPath.row];
            break;
    }
    return cell;
}
@end
