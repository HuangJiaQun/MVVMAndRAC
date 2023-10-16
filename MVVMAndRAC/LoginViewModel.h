//
//  LoginViewModel.h
//  MVVMAndRAC
//
//  Created by 黄 嘉群 on 2023/10/12.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface Account : NSObject
@property (nonatomic, strong)NSString* account;
@property (nonatomic, strong)NSString* pwd;
@end


@interface LoginViewModel : NSObject

@property (nonatomic, strong) Account *account;


@property (nonatomic, strong, readonly) RACSignal *enableLoginSignal;//绑定触摸事件
@property (nonatomic, strong, readonly) RACCommand *LoginCommand;// 执行登录事件


@end

NS_ASSUME_NONNULL_END
