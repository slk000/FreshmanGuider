//
//  ChatViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/18.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "ChatViewController.h"
//#import <AVOSCloud/AVOSCloud.h>
@interface ChatViewController() <UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic, strong) AVIMClient *imClient;
@property (nonatomic,strong) AVIMConversation *currentConversation;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextField *sendText;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, copy) void (^messageSentBlock)(AVIMMessage*);
@end

@implementation ChatViewController

-(void)viewDidLoad{
    
    _imClient = [[AVIMClient alloc] init];
    
    // Tom 用自己的名字作为 ClientId 打开 client
    [_imClient openWithClientId:[AVUser currentUser].username callback:^(BOOL succeeded, NSError *error) {
        // Tom 建立了与 Jerry 的会话
#if TARGET_IPHONE_SIMULATOR
        [_imClient createConversationWithName:@"猫和老鼠" clientIds:@[@"slk001"] callback:^(AVIMConversation *conversation, NSError *error)
#elif TARGET_OS_IPHONE
        [_imClient createConversationWithName:@"猫和老鼠" clientIds:@[@"slk000"] callback:^(AVIMConversation *conversation, NSError *error)
#endif
         {
            // Tom 发了一条消息给 Jerry
             _currentConversation = conversation;
            [conversation sendMessage:[AVIMTextMessage messageWithText:@"耗子，起床！" attributes:nil] callback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"发送成功！");
                }
            }];
        }];
    }];
//    _imClient = [[AVIMClient alloc] init];
//    
//    [_imClient openWithClientId:[AVUser currentUser].username callback:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"开启client成功");
//        }
//        else{
//            NSLog(@"开启client失败:%@", error);
//        }
//    }];
//    
//    
//    
//    [AVOSCloud setAllLogsEnabled:YES];
    _tableview.delegate = self;
    _tableview.dataSource = self;
//
    _messages = [[NSMutableArray alloc]initWithCapacity:10];
//    _imClient = [AVIMClient defaultClient];
    _imClient.delegate = self;
//
////    AVIMConversationQuery *query2 = [[AVIMClient defaultClient] conversationQuery];
//////    [query2 whereKey:@"m" containsAllObjectsInArray:@[[AVIMClient defaultClient].clientId]];
////    [query2 whereKey:@"m" containsAllObjectsInArray:@[[AVUser currentUser].username]];
////    [query2 whereKey:@"m" sizeEqualTo:2];
////    [query2 whereKey:AVIMAttr(@"customConversationType")  equalTo:@(1)];
////    query2.cachePolicy = kAVCachePolicyNetworkOnly;
////    // 执行查询
////    
////    [query2 findConversationsWithCallback:^(NSArray *objects, NSError *error) {
////        NSLog(@"queryRes:%@", error);
////        if(objects.count == 0){
////            NSLog(@"didnt find hostory chat");
////            NSDictionary *attributes = @{ @"customConversationType": @(1) };
////            
////            [_imClient createConversationWithName:@"" clientIds:@[@"slk000"] attributes:attributes options:AVIMConversationOptionNone callback:^(AVIMConversation *conversation, NSError *error) {
////                NSLog(@"creat chat error:%@",error);
////                //                [self performSegueWithIdentifier:@"toSingleChat" sender:conversation];
////                _currentConversation = conversation;
////                NSLog(@"currentConv:%@", _currentConversation);
////            }];
////        }
////        else{
////            //            [self performSegueWithIdentifier:@"toSingleChat" sender:[objects objectAtIndex:0]];
////            _currentConversation = [objects objectAtIndex:0];
////        }
////        [self.tableview reloadData];
////    }];
//    
//    /////////////////////////////////////////
//    [_imClient createConversationWithName:@"chat" clientIds:@[@"slk000"] callback:^(AVIMConversation *conversation, NSError *error) {
//        NSLog(@"creatConv:%@", error);
//        _currentConversation = conversation;
////        [conversation sendMessage:[AVIMTextMessage messageWithText:@"耗子，起床！" attributes:nil] callback:^(BOOL succeeded, NSError *error) {
////            if (succeeded) {
////                NSLog(@"发送成功！");
////            }
////        }];
//    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_messages count];
//    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messagecell"];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    /**
     * 绘画 Tabel View Cell 控件
     */
    AVIMMessage *message= self.messages[indexPath.row];
    // 判断是否为当前 ClientId 发送的消息，如果是，则该条消息会出现在列表的右侧
    BOOL isMe= [_imClient.clientId isEqualToString:message.clientId];
    if ([message isKindOfClass:[AVIMTypedMessage class]]) {
        AVIMTypedMessage *typedMessage=(AVIMTypedMessage*)message;
        switch (typedMessage.mediaType) {
            case  kAVIMMessageMediaTypeText: {
                
                AVIMTextMessage *textMessage=(AVIMTextMessage*)typedMessage;
//                TextMessageTableViewCell *textCell=[TextMessageTableViewCell cellWithTableView:tableView isMe:isMe];
                if(isMe) cell.backgroundColor = [UIColor grayColor];
                cell.textLabel.text = textMessage.text;
                return cell;
            }
                break;
            default:
                break;
        }
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messagecell"];
    }
    if(message){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@", message.clientId, @"当前版本暂不支持显示此消息类型。"];
        return cell;
    }

    return cell;
}

- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"收到新的消息" message:((AVIMTypedMessage *) message).text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [view show];
    
//    if ([message.conversationId isEqualToString:self.currentConversation.conversationId]) {
        [_messages addObject:message];
        [_tableview reloadData];
//    }
}

- (IBAction)sendBtnClicked:(id)sender {
//    NSLog(@"messages:%@",((AVIMTypedMessage *)_messages).text);
//    [_tableview reloadData];
    NSLog(@"send %@ with %@", _sendText.text, _currentConversation);
    AVIMTextMessage *textMessage = [AVIMTextMessage messageWithText:_sendText.text attributes:nil];
    [_currentConversation sendMessage:textMessage callback:^(BOOL succeeded, NSError *error) {
        if (error) {
            // 出错了，可能是网络问题无法连接 LeanCloud 云端，请检查网络之后重试。
            // 此时聊天服务不可用。
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"聊天不可用！" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [view show];
        }
        else{
            //[self.messages addObject:textMessage];
            //[self.messageTableView reloadData];
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发送成功！" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            self.sendText.text = @"";
//            self.messageSentBlock(textMessage);
            [view show];
        }
    }];
}

@end
