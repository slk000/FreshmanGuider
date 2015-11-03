////
////  ListEditViewController.m
////  com.slk.FreshmanGuider
////
////  Created by Takanashirin on 15/10/11.
////  Copyright © 2015年 孙凌昆. All rights reserved.
////
//
//#import "ListEditViewController.h"
//
//@interface ListEditViewController ()
//
//@end
//
//@implementation ListEditViewController
//@synthesize preViewController;
//@synthesize selection;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [_editText becomeFirstResponder]; //TODO: a
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if ([preViewController respondsToSelector:@selector(setEditedSelecion:)]) {
//        [_editText endEditing:YES];
//        NSIndexPath *indexPath = [selection objectForKey:@"indexPath"];
//        id object = _editText.text;
//        NSDictionary *editedSelection = [NSDictionary dictionaryWithObjectsAndKeys:indexPath,@"indexPath",object,@"object", nil];
//        [preViewController setValue:editedSelection forKey:@"editedSelection"];
//    }
//}
//
//@end
