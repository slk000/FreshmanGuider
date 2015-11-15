//
//  ProfileTableViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/14.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "ProfileTableViewController.h"

@interface ProfileTableViewController (){

    IBOutlet UITableView *tableview;
}

@end
@implementation ProfileTableViewController

-(void) viewDidLoad
{
    
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource=self;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profilecell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section,(long)indexPath.row];
    return cell;
}
@end
