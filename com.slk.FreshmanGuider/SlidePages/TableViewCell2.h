//
//  TableViewCell2.h
//  FDSlideBarDemo
//
//  Created by Takanashirin on 15/11/4.
//  Copyright © 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell2 : UITableViewCell
@property (strong, nonatomic) NSString *text;
@property (weak, nonatomic) IBOutlet UITableView *table;
//@property NSInteger width;
//@property NSInteger height;
@property UIViewController *superview;
@end
