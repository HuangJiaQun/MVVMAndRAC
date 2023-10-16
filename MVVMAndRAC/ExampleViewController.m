//
//  ExampleViewController.m
//  MVVMAndRAC
//
//  Created by 黄 嘉群 on 2023/10/12.
//

#import "ExampleViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (LoginViewModel *)loginViewModel
{
    if (_loginViewModel == nil) {
        
        _loginViewModel = [[LoginViewModel alloc] init];
    }
    return _loginViewModel;
}

// 视图模型绑定
- (void)bindModel{
    // 给模型的属性绑定信号
    // 只要账号文本框一改变，就会给account赋值
    RAC(self.loginViewModel.account,account) = _accountField.rac_textSignal;
    RAC(self.loginViewModel.account, pwd) = _pwdField.rac_textSignal;
    // 绑定登录按钮
    RAC(self.loginBtn,enabled) = self.loginViewModel.enableLoginSignal;
    // 监听登录按钮点击
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 执行登录事件
        [self.loginViewModel.LoginCommand execute:nil];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindModel];
}


@end
