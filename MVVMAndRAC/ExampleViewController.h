//
//  ExampleViewController.h
//  MVVMAndRAC
//
//  Created by 黄 嘉群 on 2023/10/12.
//

#import "ViewController.h"
#import "LoginViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExampleViewController : ViewController

@property (nonatomic, strong) LoginViewModel *loginViewModel;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;



@end

NS_ASSUME_NONNULL_END
