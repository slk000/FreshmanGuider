//
//  NewsDetailViewController.h
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/14.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) NSString *URL;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end
