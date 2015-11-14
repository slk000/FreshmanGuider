//
//  RssReader.h
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/10/11.
//  Copyright © 2015年 Takanashirin. All rights reserved.
//
#import <Foundation/Foundation.h>
@class newsRecord;
typedef void (^ArrayBlock)(NSArray *);
typedef void (^ErrorBlock)(NSError *);


@interface RssReader : NSOperation <NSXMLParserDelegate>
//{
//@private
//    ArrayBlock  completionHandler;
//    ErrorBlock  errorHandler;
//    NSData  *dataToParse;
//    NSMutableArray  *workingPropertyString;
//    NSArray *elementsToParse;
//    BOOL    storingCharacterData;
//}

@property (copy, nonatomic) ErrorBlock errorHandler;
- (id)initWithData:(NSData *)data completionHandler:(ArrayBlock)handler;

@end
