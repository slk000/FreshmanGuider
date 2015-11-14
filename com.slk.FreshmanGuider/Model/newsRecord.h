//
//  RssReader.h
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/10/11.
//  Copyright © 2015年 Takanashirin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface newsRecord : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *newsDate;
- (NSString *) getTitle;
@end
