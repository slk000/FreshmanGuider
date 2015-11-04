//
//  AppDelegate.m
//  FreshmanGuider
//
//  Created by Takanashirin on 15/10/11.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "AppDelegate.h"
//#import "ListViewController.h"
#import "RssReader.h"
#import <CFNetwork/CFNetwork.h>
#import "DataManager.h"
#import "newsRecord.h"
#import "TableViewCell2.h"

@class ListViewController;


static NSString *const TopPaidAppsFeed = @"http://news.qq.com/newsgn/rss_newsgn.xml";
//static NSString *const TopPaidAppsFeed = @"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=100/xml";
@interface AppDelegate (){
//    //列表的VC 用于设置其数据源
//    ListViewController  *listViewController;
//    
//    //存储信息的记录
//    NSMutableArray      *newsRecords;
//    
//    //解析数据时的队列
//    NSOperationQueue    *queue;
//    
//    //http请求链接对象
//    NSURLConnection     *newsFeedConnection;
//    NSMutableData       *newsData;
//    long long           totalSize;
//    long long           downloadSize;
}
@end

@implementation AppDelegate
@synthesize listViewController, newsRecords, queue, newsFeedConnection, newsData;
@synthesize totalSize, downloadSize;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"in function applictionDidFinishLanunching\n");
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:TopPaidAppsFeed]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    self.newsFeedConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    listViewController.newsArray = self.newsRecords;
//    DataManager *dataManager;
//    [dataManager init];
    [self.newsRecords initWithCapacity:1];
    
    return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application{
 

}

#pragma mark 网络链接的委托方法

//	网络链接错误
- (void)handleError:(NSError *)error
{
    
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"链接网络请求出错！"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
//    [alertView release];
}

//连接网络
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response{
    
    NSLog(@"in function connection:didReceiveResponse\n");
    
    self.newsData = [NSMutableData data];
    
    NSHTTPURLResponse *httpResopnse = (NSHTTPURLResponse *)response;
    
    //TODO:
    if (httpResopnse && [httpResopnse respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *httpResopnseHeaderFields = [httpResopnse allHeaderFields];
        
        NSLog(@"Content-Length: %lld\n", [[httpResopnseHeaderFields objectForKey:@"Content-Length"] longLongValue]);
        
        self.totalSize = [[httpResopnseHeaderFields objectForKey:@"Content-Length"] longLongValue]*6;
        
    }
}

//接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data{
    [newsData appendData:data];
    
    self.downloadSize = newsData.length;
    NSLog(@"downloadSize: %lld", self.downloadSize);
    
}

//接收数据完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"in function connectionDidFinishLoading\n");
    self.newsFeedConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.queue = [[NSOperationQueue alloc] init];
    
    RssReader *task = [[RssReader alloc] initWithData:newsData
                                    completionHandler:^(NSArray *newsList) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            NSLog(@"newslist: %@", newsList);
//                                            NSLog(@"shared:%@",[[DataManager sharedDataManager]getNews]);

//                                            [[[DataManager sharedDataManager]getNews]addObjectsFromArray:newsList];
//                                            [[DataManager ] addObjectsFromArray:newsList];
                                            

                                            
//                                            [((DataManager *)[DataManager sharedDataManager]).newsList addObjectsFromArray:newsList];
                                            for (newsRecord *rec in newsList) {
                                                NSLog(@"add: %@", rec);
                                                
                                                [((DataManager *)[DataManager sharedDataManager]).newsList addObject:rec];
                                            }
                                            printf("db add in delegate: %p", [DataManager sharedDataManager]);
                                            
//
                                            
                                        });

                                                                            
                                        self.queue = nil;
                                    }];
    
    task.errorHandler = ^(NSError *taskError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleError:taskError];
        });
    };
    
    [queue addOperation:task];
    self.newsData = nil;
//    [((DataManager *)[DataManager sharedDataManager]).newsList addObjectsFromArray:self.newsRecords];
    
}

//连接失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"in function connection:didFailWithError:\n");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([error code] == kCFURLErrorNotConnectedToInternet)
    {
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"无法连接"
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                         code:kCFURLErrorNotConnectedToInternet
                                                     userInfo:userInfo];
        [self handleError:noConnectionError];
    }
    else
    {
        
        [self handleError:error];
    }
    
    self.newsFeedConnection = nil;   //释放http请求链接
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
