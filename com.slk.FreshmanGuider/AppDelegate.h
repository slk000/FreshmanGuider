//
//  AppDelegate.h
//  FreshmanGuider
//
//  Created by Takanashirin on 15/10/11.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListViewController;
@class newsRecord;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ListViewController *listViewController;

@property (strong, nonatomic) NSMutableArray *newsRecords;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSURLConnection *newsFeedConnection;
@property (strong, nonatomic) NSMutableData *newsData;
@property long long totalSize;
@property long long downloadSize;

@end

