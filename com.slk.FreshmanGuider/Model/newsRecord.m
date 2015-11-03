//
//  RssReader.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/10/11.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "newsRecord.h"

@implementation newsRecord
@synthesize title=_title;
@synthesize link;
@synthesize newsDate;


- (NSString *)description{
    return [NSString stringWithFormat:@"Title: %@, Date: %@\n", self.title, self.newsDate];
}
- (NSString *)getTitle {
    return _title;
}
@end
