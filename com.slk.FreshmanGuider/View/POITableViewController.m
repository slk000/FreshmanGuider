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
    NSMutableDictionary *_result;
    NSMutableArray *_data;
    UISearchController *_searchController;
}
@end
@implementation POITableViewController
@synthesize parentVC;
-(void) viewDidLoad
{
    for (NSString *ele in [self.pois allKeys]) {
        NSLog(@"%@", ele);
    }
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
    _result = [[NSMutableDictionary alloc]init];

    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"poicell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"poicell"];
    }
    
    NSString *keyName = [[self.pois allKeys]objectAtIndex:indexPath.section];
    
    if (_searchController.active) {
        NSString *resultName = [[_result objectForKey:keyName]objectAtIndex:indexPath.row];
        cell.textLabel.text = resultName;
    }
    else{
        NSString *poiName = [[self.pois objectForKey:keyName]objectAtIndex:indexPath.row];
        if (!poiName) {
            poiName = @"233";
        }
        cell.textLabel.text = poiName;
    }
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *keyName = [[self.pois allKeys]objectAtIndex:section];

    if (_searchController.active) {
        long resultSumInSection = [[_result objectForKey:keyName]count];
        if (!resultSumInSection) {
            resultSumInSection=0;
        }
        return resultSumInSection;
    }
    
    long poiSumInSection = [[self.pois objectForKey:keyName]count];
    if (!poiSumInSection) {
        poiSumInSection = 5;
    }

    NSLog(@"numberOfRowsInSection%ld:%lu",(long)section,(unsigned long)(_searchController.active?[_result count]:poiSumInSection));
    
    return poiSumInSection;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.pois) {
        NSLog(@"numberOfSections:%lu", (unsigned long)[[self.pois allKeys]count]);
        return [[self.pois allKeys]count];
    }
    return 5;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.pois) {
        NSString *sectionName = [[self.pois allKeys]objectAtIndex:section];
        if ([sectionName compare:@""] == 0) {
            sectionName = @"其他";
        }
        return sectionName;
    }
    
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
    NSLog(@"searchingString:%@", searchString);
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    NSLog(@"*preicate:%@", preicate);
    

    //过滤数据
    NSArray *sectionNames = [self.pois allKeys];
    for (int i = 0; i < [self.pois count]; i++) {
        if ([_result objectForKey:sectionNames[i]]!= nil) {
            [[_result objectForKey:sectionNames[i]] removeAllObjects];
        }
        
        
        if (![[_result allKeys]containsObject:sectionNames[i]]){
            [_result setObject:[[NSMutableArray alloc]init] forKey:sectionNames[i]];
        }
        NSArray *sectionArr = [self.pois objectForKey:sectionNames[i]];
        NSLog(@"searcing %@ in:", searchString);
        for (NSString *name in sectionArr) {
            NSLog(@"%@", name);
        }
        NSLog(@"preicate:%@", preicate);
        NSArray *foundPOI = [sectionArr filteredArrayUsingPredicate:preicate];
        [[_result objectForKey:sectionNames[i]] addObjectsFromArray:foundPOI];
       // [_result objectForKey:sectionNames[i]]  [NSMutableArray arrayWithArray:foundPOI];
    }
    //_result= [NSMutableArray arrayWithArray:[_data filteredArrayUsingPredicate:preicate]];
    
    [self.tableView reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"touched");
    if (_searchController.active) [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
//
    }];
    NSLog(@"p:%@", self.parentVC);
    NSString *keyName = [[self.pois allKeys]objectAtIndex:indexPath.section];
    NSString *poiName = [[self.pois objectForKey:keyName]objectAtIndex:indexPath.row];
    if (!poiName) {
        poiName = @"233";
    }
    [parentVC mapSearchBound:poiName];
//    [self.navigationController popViewControllerAnimated:YES];
//    self.parentViewController
}

@end