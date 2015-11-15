//
//  POITableViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/15.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "POITableViewController.h"

@implementation POITableViewController

-(void) viewDidLoad
{
    UISearchBar *b = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.tableView.tableHeaderView = b;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [NSString stringWithFormat:@"%d-%d", indexPath.section,indexPath.row];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *classify = [[NSArray alloc]initWithObjects:@"cl",@"ea",@"aa",@"tr",@"pla", nil];

    return classify[section];
}
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    
//    NSArray *classify = [[NSArray alloc]initWithObjects:@"cl",@"ea",@"aa",@"tr",@"pla", nil];
//    
//    return classify;
//    //通过key来索引
//}

@end