//
//  AppDelegate.m
//  NewsDemo
//
//  Created by Takanashirin on 15/10/9.
//  Copyright (c) 2015年 Takanashirin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import "RssReader.h"
#import <CFNetwork/CFNetwork.h>
#import "DataManager.h"
#import "newsRecord.h"
static NSString *const RSS_URL = @"http://news.qq.com/newsgn/rss_newsgn.xml";

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize  newsRecords, queue, newsFeedConnection, newsData;
@synthesize totalSize, downloadSize;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
///////////////////////////////////////////////
//  Init Leancloud SDK
///////////////////////////////////////////////
    [AVOSCloud setApplicationId:LEANCLOUD_ID
                      clientKey:LEANCLOUD_KEY];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

///////////////////////////////////////////////
//  Change the color of text in the status bar
///////////////////////////////////////////////
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
///////////////////////////////////////////////
//  Init MainView
///////////////////////////////////////////////
    MainViewController *VC=[[MainViewController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:VC];
    self.window.rootViewController=nav;
    [nav.navigationBar setBarTintColor:[UIColor colorWithRed:0.86 green:0.2 blue:0.22 alpha:1]];
///////////////////////////////////////////////
//  Init Internet Connection
///////////////////////////////////////////////
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:RSS_URL]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    self.newsFeedConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //    listViewController.newsArray = self.newsRecords;
    //    DataManager *dataManager;
    //    [dataManager init];
    [self.newsRecords initWithCapacity:1];
    return YES;
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
    // Saves changes in the application's managed object context before the application terminates.
//    [self saveContext];
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
                                            for (newsRecord *rec in newsList) {
                                                NSLog(@"add: %@", rec);
                                                
                                                [((DataManager *)[DataManager sharedDataManager]).newsList addObject:rec];
                                            }
                                            printf("db add in delegate: %p", [DataManager sharedDataManager]);
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadnews" object:self];
                                            
                                            
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


#pragma mark - Core Data stack
//
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "coderyi.NewsDemo" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NewsDemo" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NewsDemo.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//
//
//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] init];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

@end
