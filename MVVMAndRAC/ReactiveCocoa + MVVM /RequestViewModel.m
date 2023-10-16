//
//  RequestViewModel.m
//  MVVMAndRAC
//
//  Created by 黄 嘉群 on 2023/10/14.
//

#import "RequestViewModel.h"
#import <MJExtension/MJExtension.h>

@implementation Book

@end


#import <AFNetworking/AFNetworking.h>

@implementation RequestViewModel

- (instancetype)init
{
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}

- (void)initialBind{
    
    _reuqesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableDictionary*paramaters = [NSMutableDictionary dictionary];
            paramaters[@"q"]= @"基础";
            //把字典转换成json
            NSError *error;
            AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
            httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
            httpManager.requestSerializer.timeoutInterval = 20;
            httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramaters options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [httpManager GET:@"https://api.douban.com/v2/book/search" parameters:jsonString headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 请求成功调用
                // 把数据用信号传递出去
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            return nil;
        }];
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(NSDictionary *value) {
            NSMutableArray *dictArr = value[@"books"];
            // 字典转模型，遍历字典中的所有元素，全部映射成模型，并且生成数组
            NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                return [Book mj_setKeyValues:value];
            }] array];
            return modelArr;
        }];
    }];
    
    
    
    
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    Book *book = self.models[indexPath.row];
    cell.detailTextLabel.text = book.subtitle;
    cell.textLabel.text = book.title;
    return cell;
}

@end
