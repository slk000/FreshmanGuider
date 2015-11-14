//
//  AppDelegate.h
//  NewsDemo
//
//  Created by apple on 15/2/9.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class ListViewController;
@class newsRecord;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *newsRecords;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSURLConnection *newsFeedConnection;
@property (strong, nonatomic) NSMutableData *newsData;
@property long long totalSize;
@property long long downloadSize;


@end

