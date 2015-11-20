//
//  POITableViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/15.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "POITableViewController.h"
@interface POITableViewController(){
//    UISearchBar *_searchBar;
    NSMutableArray *_result;
    NSMutableArray *_data;
    UISearchController *_searchController;
}
@end
@implementation POITableViewController
@synthesize parentVC;
-(void) viewDidLoad
{

//   self setParentViewController:
    NSLog(@"POI parentVC:%@", self.parentVC);
    /////////////////////////////////
    /// init search controller
    /////////////////////////////////
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    _searchController.searchResultsUpdater = self;
    
    _searchController.dimsBackgroundDuringPresentation = NO;
    
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    _searchController.searchBar.frame = CGRectMake(_searchController.searchBar.frame.origin.x, _searchController.searchBar.frame.origin.y, _searchController.searchBar.frame.size.width, 44.0);
    [_searchController.searchBar setPlaceholder:@"seaerch~"];
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    /////////////////////////////////
    _data = [[NSMutableArray alloc]initWithCapacity:40];
    for (int i = 0; i < 40; i++) {
        [_data addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _result = [[NSMutableArray alloc]initWithCapacity:10];

    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"poicell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"poicell"];
    }
    cell.textLabel.text = _searchController.active?_result[indexPath.row]:_data[indexPath.row];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchController.active?[_result count]:[_data count];
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


#pragma mark - Search
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
    
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [_searchController.searchBar text];
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
    if (_result!= nil) {
        [_result removeAllObjects];
    }
    //过滤数据
    _result= [NSMutableArray arrayWithArray:[_data filteredArrayUsingPredicate:preicate]];
    
    [self.tableView reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:^{
//
    }];
    NSLog(@"p:%@", self.parentVC);
    [parentVC mapSearchBound:@"宿舍"];
//    [self.navigationController popViewControllerAnimated:YES];
//    self.parentViewController
}

@end