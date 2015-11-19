//
//  ChatViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/18.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//
#if TARGET_IPHONE_SIMULATOR
#define TOUSERNAME @"slk001"
#elif TARGET_OS_IPHONE
#define TOUSERNAME @"slk000"
#endif
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
@property  CGRect viewRect;
@end

@implementation ChatViewController
static NSInteger kPageSize = 5;
-(void)viewDidLoad{
if (1)
{
    [[[UIAlertView alloc]initWithTitle:@"t" message:@"m" delegate:nil cancelButtonTitle:@"c" otherButtonTitles: nil] show];
    _imClient = [[AVIMClient alloc] init];
   
//    [AVOSCloud setAllLogsEnabled:YES];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _sendText.delegate = self;
    _tableview.frame = CGRectMake(0, 0, self.view.width, self.view.height);
//
    _messages = [[NSMutableArray alloc]initWithCapacity:10];
//    _imClient = [AVIMClient defaultClient];
    [_imClient openWithClientId:[AVUser currentUser].username callback:^(BOOL succeeded, NSError *error) {//there

    _imClient.delegate = self;

    AVIMConversationQuery *query = [[AVIMConversationQuery alloc]init];
    query = [_imClient conversationQuery];
    [query whereKey:@"m" containsAllObjectsInArray:@[@"slk000", @"slk001"]];
    [query whereKey:@"m" sizeEqualTo:2];
    [query whereKey:AVIMAttr(@"customConversationType")  equalTo:@(1)];
    query.cachePolicy = kAVCachePolicyNetworkOnly;
////    // 执行查询
////    
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        NSLog(@"queryRes:%@", error);
        if(objects.count == 0){
            NSLog(@"didnt find hostory chat");
            NSDictionary *attributes = @{ @"customConversationType": @(1) };

            [_imClient createConversationWithName:@"ask" clientIds:@[TOUSERNAME] attributes:attributes options:AVIMConversationOptionNone callback:^(AVIMConversation *conversation, NSError *error) {

                NSLog(@"creat chat error:%@",error);
                //                [self performSegueWithIdentifier:@"toSingleChat" sender:conversation];
                _currentConversation = conversation;
                NSLog(@"currentConv:%@", _currentConversation);
            }];
        }
        else{
            _currentConversation = [objects objectAtIndex:0];
            // 查询最近的 10 条聊天记录
            [_currentConversation queryMessagesWithLimit:kPageSize callback:^(NSArray *objects, NSError *error) {
                // 刷新 Tabel 控件，为其添加数据源
                NSLog(@"fetchHistoryError:%@", error);
                [_messages addObjectsFromArray:objects];
                [_tableview reloadData];
            }];
        }
        [self.tableview reloadData];
    }];
        }];//here
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_tableview addGestureRecognizer:tapGestureRecognizer];
    UISwipeGestureRecognizer *swipDownGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeChat)];
    swipDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipDownGestureRecognizer];
    
    
}
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
                if(isMe) {
                    cell.textLabel.textAlignment = NSTextAlignmentRight;
                }
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
    
//    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"收到新的消息" message:((AVIMTypedMessage *) message).text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [view show];
    
    if ([message.conversationId isEqualToString:self.currentConversation.conversationId]) {
        [_messages addObject:message];
        [_tableview reloadData];
    }
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
//            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发送成功！" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            AVIMTextMessage *sentMsg = [[AVIMTextMessage alloc]init];
            sentMsg.text = _sendText.text;
            sentMsg.clientId = [AVUser currentUser].username;
            [_messages addObject:sentMsg];
            _sendText.text = @"";
//            self.messageSentBlock(textMessage);
//            [view show];
            [_tableview reloadData];
        }
    }];
}
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    CGFloat offset = self.view.frame.size.height - (_sendText.frame.origin.y + _sendText.frame.size.height + 216 + 50);
//    if (offset <= 0){
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect frame = self.view.frame;
//            frame.origin.y = offset;
//            self.view.frame = frame;
//        }];
//    }
//    return YES;
//}
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect frame = self.view.frame;
//        frame.origin.y = 0.0;
//        self.view.frame = frame;
//    }];
//    return YES;
//}
- (void)keyboardWillShow:

(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSTimeInterval animationDuration = [[userInfo
//                                         
//                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat offset = self.view.frame.size.height - (_sendText.frame.origin.y + _sendText.frame.size.height + keyboardRect.size.height + 10);
    if (offset <= 0){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];

    [UIView commitAnimations];  
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [_imClient closeWithCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"close chat success");
        }
        else{
            NSLog(@"close chat failed:%@", error);
        }
    }];
}
- (IBAction)keyboardReturnClicked:(id)sender {
    [sender resignFirstResponder];
    [sender endEditing:YES];
}

-(void)hideKeyboard{
    NSLog(@"touch tbv");
//    [self resignFirstResponder];
    [_sendText endEditing:YES];
}
-(void)closeChat{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_messages removeAllObjects];
    [_tableview reloadData];
}
@end
