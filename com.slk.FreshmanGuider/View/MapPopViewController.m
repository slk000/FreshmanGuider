//
//  MapPopViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/24.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "MapPopViewController.h"
#import "NavViewController.h"

@implementation MapPopViewController
@synthesize poiTitleLabel;
- (void) viewDidLoad{
    [super viewDidLoad];
}
- (IBAction)onClickTo:(id)sender {
    [((NavViewController *)self.parentViewController) onClickWalkSearch:poiTitleLabel.text];
}

@end
