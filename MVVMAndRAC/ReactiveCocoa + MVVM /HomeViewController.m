//
//  HomeViewController.m
//  MVVMAndRAC
//
//  Created by 黄 嘉群 on 2023/10/14.
//

#import "HomeViewController.h"
#import "RequestViewModel.h"


@interface HomeViewController ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) RequestViewModel *requesViewModel;

@end

@implementation HomeViewController

- (RequestViewModel *)requesViewModel
{
    if (_requesViewModel == nil) {
        _requesViewModel = [[RequestViewModel alloc] init];
    }
    return _requesViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
/*
    需求：请求豆瓣图书信息，url:https://api.douban.com/v2/book/search?q=基础
    分析：请求一样，交给VM模型管理
    步骤:1.控制器提供一个视图模型（requesViewModel），处理界面的业务逻辑
        2.VM提供一个命令，处理请求业务逻辑
        3.在创建命令的block中，会把请求包装成一个信号，等请求成功的时候，就会把数据传递出去。
        4.请求数据成功，应该把字典转换成模型，保存到视图模型中，控制器想用就直接从视图模型中获取。
    5.假设控制器想展示内容到tableView，直接让视图模型成为tableView的数据源，把所有的业务逻辑交给视图模型去做，这样控制器的代码就非常少了。
*/
    // 创建tableView
       UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
       tableView.dataSource = self.requesViewModel;
    tableView.backgroundColor = [UIColor blueColor];
       self.requesViewModel.tableView = tableView;
       [self.view addSubview:tableView];
       // 执行请求
       [self.requesViewModel.reuqesCommand execute:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
