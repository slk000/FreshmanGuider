//
//  dataManager.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/10/12.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "DataManager.h"
#import "newsRecord.h"
@class newsRecord;
@implementation DataManager
@synthesize newsList;
+ (id)sharedDataManager {
    static DataManager *sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataManager = [[self alloc] init];
    });
    return sharedDataManager;
}

- (id)init {
    if (self = [super init]) {
        newsRecord *start = [[newsRecord alloc]init];
        start.title = @"start title";
        start.newsDate = @"start date";
        newsList = [[NSMutableArray alloc]initWithObjects:start, nil];
    }
    return self;
}

- (NSMutableArray *)getNews{
    return newsList;
}
+ (void)insertRecordWithTitle:(NSString *)ti Date:(NSString *)da{
    newsRecord *re = [[newsRecord alloc]init];
    re.title = ti;
    re.newsDate = da;
    [[[DataManager sharedDataManager]getNews] addObject:re];
                                                NSLog(@"nothing start");
}
- (void)dealloc {
    // 永远不要调用这个方法
}
@end
