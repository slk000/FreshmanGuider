//
//  ListViewController.h
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/10/11.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *Button;
@property (weak, nonatomic) NSMutableArray *newsArray;//存储从网络获得的信息条目
@end
