//
//  dataManager.h
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/10/12.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
@property (nonatomic, copy) NSMutableArray *newsList;

+ (id)sharedDataManager;
- (NSMutableArray *)getNews;
+ (void)insertRecordWithTitle:(NSString *)ti Date:(NSString *)da;

@end
