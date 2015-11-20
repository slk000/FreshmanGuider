//
//  POITableViewController.h
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/15.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"

@interface POITableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate,UISearchResultsUpdating>
@property (retain, nonatomic) NavViewController *parentVC;
@end
