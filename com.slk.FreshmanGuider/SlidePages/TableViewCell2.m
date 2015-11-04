//
//  TableViewCell2.m
//  FDSlideBarDemo
//
//  Created by Takanashirin on 15/11/4.
//  Copyright © 2015年 fergusding. All rights reserved.
//

#import "TableViewCell2.h"
#import "DataManager.h"
#import "ViewController.h"
#import "newsRecord.h"

@interface TableViewCell2 () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
//@property (retain, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (strong ,nonatomic) NSMutableArray *arr;
//@property (weak, nonatomic) IBOutlet UILabel *label;
//@property (weak, nonatomic) ViewController *vc;
@end

@implementation TableViewCell2

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _table.delegate = self;
    _table.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"Cell" bundle:nil];
    [_table registerNib:nib forCellReuseIdentifier:@"abcde"];
    
    _table.frame = CGRectMake(0, 0,375, 540);//600*375
//    NSLog(@"he:%lf, wi:%lf",CGRectGetHeight(self.view.frame), CGRectGetWidth(self.frame));
    newsRecord *start = [[newsRecord alloc]init];
    start.title = @"start title";
    start.newsDate = @"start date";
    _arr = [[NSMutableArray alloc]initWithObjects:start, nil];


}
- (IBAction)btn:(id)sender {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按钮点击提示" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [myAlertView show];
    
    _arr = ((DataManager *)[DataManager sharedDataManager]).newsList;
    [self.table reloadData];
    NSLog(@"%@", _arr);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"selected");
   

    // Configure the view for the selected state
}
- (void)backView{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"按钮点击提示" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [myAlertView show];
}
//- (void)setText:(NSString *)text{
//    _text = text;
//    self.label.text = text;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath{
    
   
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abcde"];
    
    NSMutableArray *_arrr =  [[NSMutableArray alloc]initWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"6",@"7",@"8",@"1", @"2",@"3",@"4",@"5",@"6",@"6",@"7",@"8", nil];
    if([_arr count]==1)
        cell.text = ((newsRecord *)[_arr objectAtIndex:0]).title;
    else{
        cell.text = ((newsRecord *)[_arr objectAtIndex:indexPath.row]).title;
    }
    
    return cell;
}

@end
