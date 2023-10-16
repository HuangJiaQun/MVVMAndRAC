//
//  LoginViewModel.m
//  MVVMAndRAC
//
//  Created by 黄 嘉群 on 2023/10/12.
//

#import "LoginViewModel.h"
@implementation Account

@end
@implementation LoginViewModel
- (Account *)account
{
    if (_account == nil) {
        _account = [[Account alloc] init];
    }
    return _account;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}

// 初始化绑定
- (void)initialBind
{
    // 监听账号的属性值改变，把他们聚合成一个信号。
    _enableLoginSignal = [RACSignal combineLatest:@[RACObserve(self.account, account),RACObserve(self.account, pwd)] reduce:^id (NSString *account,NSString *pwd){
        NSLog(@"账号的属性值改变:account=%@,pwd=%@",account,pwd);
        return @(pwd.length &&account.length);
    }];
    
    // 处理登录业务逻辑
    _LoginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"点击了登录");
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            // 模仿网络延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"登陆成功"];//发出登陆成功的信号
                // 数据传送完毕，必须调用完成，否则命令永远处于执行状态
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    // 监听登录产生的数据
    [_LoginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"x = %@",x);
        if([x isEqualToString:@"登录成功"]){
            NSLog(@"登录成功");
        }
    }];
    
    [[_LoginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"x = %@",x);
        if ([x isEqualToNumber:@(YES)]) {
            NSLog(@"正在登录...");
        }else{
            NSLog(@"登录成功");
        }
    }];
    
}


@end
