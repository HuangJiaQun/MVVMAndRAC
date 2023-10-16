//
//  RequestViewModel.h
//  MVVMAndRAC
//
//  Created by 黄 嘉群 on 2023/10/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface Book :NSObject
@property (nonatomic, strong)NSString* subtitle;
@property (nonatomic, strong)NSString* title;
@end


@interface RequestViewModel : NSObject<UITableViewDataSource>
// 请求命令
@property (nonatomic, strong, readonly) RACCommand *reuqesCommand;
//模型数组
@property (nonatomic, strong, readonly) NSArray *models;
// 控制器中的view
@property (nonatomic, weak) UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
