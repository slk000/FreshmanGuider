//
//  LoginViewController.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/11/17.
//  Copyright © 2015年 孙凌昆. All rights reserved.
//

#import "LoginViewController.h"
#import "InputText.h"
#import "DeformationButton.h"
#import <AVOSCloud/AVOSCloud.h>
@interface LoginViewController(){
    DeformationButton *loginBtn;
}
@property (nonatomic, weak)UITextField *idText;
@property (nonatomic, weak)UILabel *idTextName;
@property (nonatomic, weak)UITextField *emailText;
@property (nonatomic, weak)UILabel *emailTextName;
@property (nonatomic, weak)UITextField *passwordText;
@property (nonatomic, weak)UILabel *passwordTextName;
@property (nonatomic, weak)DeformationButton *loginBtn;
@property (nonatomic, assign) BOOL chang;

@end
@implementation LoginViewController
-(void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg.jpg" ]];
    
    CGFloat centerX = self.view.width * 0.5;
    
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = 100;
    UITextField *idText = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    idText.delegate = self;
    self.idText = idText;
    [idText setReturnKeyType:UIReturnKeyNext];
    [idText addTarget:self action:nil forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:idText];
    UILabel *idTextName = [self setupTextName:@"学号/准考证号" frame:idText.frame];
    idTextName.textColor = idText.textColor = [UIColor whiteColor];
    self.idTextName = idTextName;
    [self.view addSubview:idTextName];
    
    CGFloat emailY = CGRectGetMaxY(idText.frame) + 30;
    UITextField *emailText = [inputText setupWithIcon:nil textY:emailY centerX:centerX point:nil];
    emailText.keyboardType = UIKeyboardTypeEmailAddress;
    [emailText setReturnKeyType:UIReturnKeyNext];
    emailText.delegate = self;
    self.emailText = emailText;
    [emailText addTarget:self action:nil forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:emailText];
    UILabel *emailTextName = [self setupTextName:@"邮箱" frame:emailText.frame];
    emailTextName.textColor = emailText.textColor = [UIColor whiteColor];
    self.emailTextName = emailTextName;
    [self.view addSubview:emailTextName];
    
    CGFloat passwordY = CGRectGetMaxY(emailText.frame) + 30;
    UITextField *passwordText = [inputText setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText setSecureTextEntry:YES];
    passwordText.delegate = self;
    self.passwordText = passwordText;
    [passwordText addTarget:self action:nil forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"密码" frame:passwordText.frame];
    passwordTextName.textColor = passwordText.textColor = [UIColor whiteColor];
    self.passwordTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    UIButton *signUpBtn = [[UIButton alloc] init];
    signUpBtn.width = 200;
    signUpBtn.height = 30;
    signUpBtn.centerX = self.view.width * 0.5;
    signUpBtn.y = CGRectGetMaxY(passwordText.frame) + 100;
    [signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
    [signUpBtn setBackgroundColor:[UIColor whiteColor]];

    signUpBtn.enabled = YES;
   
    [signUpBtn addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpBtn];
    
    
    loginBtn = [[DeformationButton alloc]initWithFrame:CGRectMake(self.view.width * 0.5, CGRectGetMaxY(passwordText.frame) + 30, 100, 50) withColor: [UIColor orangeColor]];
    loginBtn.centerX = self.view.width * 0.5;
    
    [self.view addSubview:loginBtn];
    
    [loginBtn.forDisplayButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.forDisplayButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [loginBtn.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [loginBtn.forDisplayButton setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeBtnClicked:)];
    [swip setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swip];
    
    NSLog(@"classname:%@", NSStringFromClass([self.parentViewController class]));
    

}
-(void) viewWillAppear:(BOOL)animated{
    self.parentViewController.navigationItem.leftBarButtonItem = self.parentViewController.navigationItem.rightBarButtonItem = nil;
}
-(void)signUp{
    AVUser *user = [AVUser user];
    user.username = _idText.text;
    user.password =  _passwordText.text;
    user.email = _emailText.text;
//    [user setObject:@"186-1234-0000" forKey:@"phone"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"signup success");
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            loginBtn.isLoading = YES;
            [self loginBtnClicked];
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            NSLog(@"singup failed for: %@", error);
        }
    }];
}
- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}
//
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.idText) {
        [self diminishTextName:self.idTextName];
        [self restoreTextName:self.emailTextName textField:self.emailText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.emailText) {
        [self diminishTextName:self.emailTextName];
        [self restoreTextName:self.idTextName textField:self.idText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.idTextName textField:self.idText];
        [self restoreTextName:self.emailTextName textField:self.emailText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.idText) {
        return [self.emailText becomeFirstResponder];
    } else if (textField == self.emailText){
        return [self.passwordText becomeFirstResponder];
    } else {
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        return [self.passwordText resignFirstResponder];
    }
}
- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -16);
        label.font = [UIFont systemFontOfSize:9];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:16];
        }];
    }
}
- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}
- (void)textFieldDidChange
{
    if (self.idText.text.length != 0 && self.emailText.text.length != 0 && self.passwordText.text.length != 0) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}
#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self restoreTextName:self.idTextName textField:self.idText];
    [self restoreTextName:self.emailTextName textField:self.emailText];
    [self restoreTextName:self.passwordTextName textField:self.passwordText];
}
- (void)loginBtnClicked
{
//    deformationBtn.isLoading = YES;
//    AVUser *loginuser
    [self performSelector:@selector(checkLogin) withObject:nil afterDelay:2.0f];
    
    _idText.enabled = NO;
    _passwordText.enabled = NO;
    _emailText.enabled = NO;
    loginBtn.enabled = NO;

    NSLog(@"登录中...%@,%@,%@", self.idText.text,self.emailText.text,self.passwordText.text);
}

-(void)checkLogin{
    [AVUser logInWithUsernameInBackground:_idText.text password:_passwordText.text block:^(AVUser *user, NSError *error) {
        loginBtn.isLoading = NO;
        loginBtn.enabled = YES;
        _idText.enabled = YES;
        _emailText.enabled = YES;
        _passwordText.enabled = YES;
        if (user != nil)
        {
            NSLog(@"success");
            [self dismissViewControllerAnimated:YES completion:^{
                self.parentViewController.navigationItem.leftBarButtonItem = self.parentViewController.navigationItem.rightBarButtonItem = nil;
                
            }];
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            NSLog(@"failed%@", error);
        }
    }];
}

- (IBAction)closeBtnClicked:(id)sender {
    loginBtn.isLoading = NO;
    [self dismissViewControllerAnimated:YES completion:^{
        self.parentViewController.parentViewController.navigationItem.leftBarButtonItem = self.parentViewController.parentViewController.navigationItem.rightBarButtonItem = nil;
    }];
}


@end
