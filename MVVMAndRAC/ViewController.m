//
//  ViewController.m
//  MVVMAndRAC
//
//  Created by 黄 嘉群 on 2023/10/10.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ExampleViewController.h"
#import "HomeViewController.h"
/*
MVVM介绍
模型(M):保存视图数据。
视图+控制器(V):展示内容 + 如何展示
视图模型(VM):处理展示的业务逻辑，包括视图事件的处理，数据的请求和解析等等。
通过绑定和信号将V和VM连接起来。
每个控制器对应一个VM模型。VM里面最好不要包括V。事件都封装到RACCommand处理。
控制器内获取RACCommand数据
 */


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //学习框架首要之处：先要搞清楚框架中常用的类，在 RAC 中最核心的类 RACSiganl，会用这个类就能用 ReactiveCocoa 开发了。 RACSiganl：信号类，表示将来有数据传递，只要有数据改变，信号内部接收到数据，就会马上发出数据。
    //信号类（RACSiganl），只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
    //默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
    // 如何订阅信号：调用信号 RACSignal 的 subscribeNext 就能订阅。
    // 三步骤:创建信号，订阅信号，发送信号
    
    // 1.创建信号
    //使用_Nullable关键字的主要目的是在代码中明确表明某个对象或变量可以为nil，以提高代码的可执行性和类型安全性。
    //使用_Nonnull帮助编译器确保subscriber参数不会为nil，因为在使用它的代码中假设它不为空。
    [self otherRACfunction];
    //[self command];
    
    
    //ReactiveCocoa + MVVM 实战一：登录界面
    /* 需求：1.监听两个文本框的内容，有内容才允许按钮点击
     2.默认登录请求.
     
     用MVVM：实现，之前界面的所有业务逻辑
     分析：1.之前界面的所有业务逻辑都交给控制器做处理
     2.在MVVM架构中把控制器的业务全部搬去VM模型，也就是每个控制器对应一个VM模型.
     
     步骤：1.创建LoginViewModel类，处理登录界面业务逻辑.
     2.这个类里面应该保存着账号的信息，创建一个账号Account模型
     3.LoginViewModel应该保存着账号信息Account模型。
     4.需要时刻监听Account模型中的账号和密码的改变，怎么监听？
     5.在非RAC开发中，都是习惯赋值，在RAC开发中，需要改变开发思维，由赋值转变为绑定，可以在一开始初始化的时候，就给Account模型中的属性绑定，并不需要重写set方法。
     6.每次Account模型的值改变，就需要判断按钮能否点击，在VM模型中做处理，给外界提供一个能否点击按钮的信号.
     7.这个登录信号需要判断Account中账号和密码是否有值，用KVO监听这两个值的改变，把他们聚合成登录信号.
     8.监听按钮的点击，由VM处理，应该给VM声明一个RACCommand，专门处理登录业务逻辑.
     9.执行命令，把数据包装成信号传递出去
     10.监听命令中信号的数据传递
     11.监听命令的执行时刻
     */
    
    
    
}
#pragma mark - Other
- (void)otherRACfunction{
    
    //RAC(TARGET, [KEYPATH, [NIL_VALUE]])：用于给某个对象的某个属性绑定。
    
    //RACObserve(self, name)：监听某个对象的某个属性，返回的是信号。
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 只要文本框文字改变，就会修改label的文字
    RAC(self.labelView,text) = _textField.rac_textSignal;
    
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@10,@20);
    NSLog(@"tuple = %@",tuple);
    
    // 把参数中的数据包装成元组
    RACTuple *tuple1 = RACTuplePack(@"ZKQ",@25);
    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
    // name = @"ZKQ" age = @25
    RACTupleUnpack(NSString *name,NSNumber *age) = tuple1;
    NSLog(@"name = %@,age = %@",name,age);
    
    //rac_signalForSelector：用于代替代理。
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5"];
    [[array rac_signalForSelector:@selector(objectAtIndex:)]
     subscribeNext:^(id x) {
        NSLog(@"做额外操作");
    }];
    NSLog(@"NSArray index_3:%@",[array objectAtIndex:3]);
    
    //代替KVO  rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
    [[self.blueView rac_valuesAndChangesForKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"%@",x);
    }];
    [self.blueView setBackgroundColor:[UIColor redColor]];
    
    //监听事件: rac_signalForControlEvents：用于监听某个事件。
    // 监听事件
    [[self.bt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        HomeViewController *ctrl = [[HomeViewController alloc]init];
        
       // ExampleViewController *ctrl = [[ExampleViewController alloc]initWithNibName:@"ExampleViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
        NSLog(@"点击了按扭");
    }];
    
    //监听文本框文字改变:
    //rac_textSignal：只要文本框发出改变就会发出这个信号。
    //使用 @weakify(self); 和 @strongify(self); 解决循环引用问题。
    @weakify(self);
    [self.textField.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"%@",x);
        self.labelView.text = x;
    }];
    
    
   // ReactiveCocoa来达到谓词的筛选效果…
    [[self.textField.rac_textSignal filter:^BOOL(NSString * value) {
            return value.length >3;
        }] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    
//    ReactiveCocoa来达到映射的效果…
//    代码解释: ReactiveCocoa的map方法就是起到了映射的效果.
    [[[self.textField.rac_textSignal map:^id(NSString * value) {
           return @(value.length);
       }] filter:^BOOL(NSNumber *value) {
           return [value integerValue]>3;
       }] subscribeNext:^(id x) {
           NSLog(@"%@",x);
       }];
    
    
    //通知使用 ReactiveCocoa也是能够代替的.而且使用ReactiveCocoa做广播的时候,不需要我们delloc我们的通知中心的观察者.
    //添加通知中心
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"dongGe" object:nil] subscribeNext:^(id x) {
            NSLog(@"吼吼!!");
        }];
        
        //发送消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dongGe" object:nil];
    
    
    //自定义信号，首先我们先创建三个小管道. switchSinal就是开关,然后就是铺设管道,铺设完之后我们就需要往其中注水.然后就会从管道中流出.
    //1.关键字
       RACSubject *dongGe = [RACSubject subject];
       RACSubject *maincode = [RACSubject subject];
    
       RACSubject *signalOfSignal = [RACSubject subject];
       //2.开关是怎么设置的
       RACSignal * switchSinal = [signalOfSignal switchToLatest];
       //铺设管道.
       [switchSinal subscribeNext:^(id x) {
           NSLog(@"%@",x);
       }];
       
       //3.为信号添加数据
       [signalOfSignal sendNext:dongGe];
       [dongGe sendNext:@"dongGe"];
    
       [signalOfSignal sendNext:maincode];
       [maincode sendNext:@"www.maincode.com"];
    
}

#pragma mark - RACSignal
- (void)RACsignal {
    // 三步骤:创建信号，订阅信号，发送信号
    
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        // 3.发送信号
        [subscriber sendNext:@1];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"默认信号发送完毕被取消");
        }];
    }];
    
    // 2.订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    // 取消订阅
    [disposable dispose];
}

#pragma mark - RACSubject
- (void)RACSubject {
    // 信号提供者，自己可以充当信号，又能发送信号。
    
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者一%@",x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者二%@",x);
    }];
    
    // 发送信号
    [subject sendNext:@"111"];
}


//ACReplaySubject 的简单使用
//创建信号 [RACSubject subject]，跟 RACSiganl 不一样，创建信号时没有 block。
//可以先订阅信号，也可以先发送信号。
#pragma mark - RACReplaySubject
- (void)RACReplaySubject {
    // 创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 发送信号
    [replaySubject sendNext:@"222"];
    [replaySubject sendNext:@"333"];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    
    // 如果想一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
}

//RACTuple：元组类，类似 NSArray，用来包装值。
//RACSequence：RAC 中的集合类，用于代替 NSArray，NSDictionary，可以使用它来快速遍历数组和字典。
- (void)ArrayTuple {
    NSArray *array = @[@1,@2,@3];
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

- (void)DictionaryTuple {
    NSDictionary *dict = @{@"name":@"张三",@"age":@"20",@"sex":@"男"};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        // RACTupleUnpack 这是个宏，后面会介绍
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"%@---%@",key,value);
        /*
         相当于：
         NSString *key = x[0];
         NSString *value = x[1];
         */
    }];
}

//使用场景：字典转模型
- (void)DictionaryToModel {
    // RAC高级写法:
    //    [AFNHelper get:kUrl parameter:nil success:^(id responseObject) {
    //        NSArray *array = responseObject;
    //        // map:映射的意思，目的：把原始值 value 映射成一个新值
    //        // array: 把集合转换成数组
    //        // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    //      NSArray *musicArray =[[array.rac_sequence map:^id(id value) {
    //          Music *music = [Music fetchMusicModelWithDict:value ];
    //            return music;
    //        }] array];
    //        NSLog(@"--------%@",musicArray);
    //    } faliure:^(id error) {
    //        NSLog(@"%@",error);
    //    }];
}



//RACMulticastConnection：用于当一个信号被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的 block造成副作用，可以使用这个类处理。
//使用注意：RACMulticastConnection 通过 RACSignal 的 -publish 或者 -muticast: 方法创建。

- (void)RACMulticastConnection {
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        NSLog(@"请求一次");
        //5.发送信号
        [subscriber sendNext:@"2"];
        return nil;
    }];
    // 2.把信号转化为连接类
    RACMulticastConnection *connection = [signal publish];
    
    // 注意：订阅的不再是之前的信号，而是连接的信号。
    // 3.订阅连接类信号
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第三个订阅者%@",x);
    }];
    
    // 4.链接信号
    [connection connect];
    
    
    
}


//RACCommand：RAC 中用于处理事件的类，可以把事件如何处理，事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。 >
//使用场景：监听按钮点击，网络请求。 >
- (void)command {
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        //        1.在 RAC 开发中，通常会把网络请求封装到 RACCommand，直接执行某个 RACCommand 就能发送请求。
        //
        //        2.当 RACCommand 内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过 signalBlock 返回的信号传递了。
        // 命令内部传递的参数
        NSLog(@"input===%@",input);
        // 2.返回一个信号，可以返回一个空信号 [RACSignal empty];
        return [RACSignal createSignal:^RACDisposable *(id subscriber) {
            NSLog(@"发送数据");
            // 发送信号
            [subscriber sendNext:@"22"];
            // 注意：数据传递完，最好调用 sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // 拿到返回信号方式二：
    // command.executionSignals 信号中的信号 switchToLatest 转化为信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"拿到信号的方式二%@",x);
    }];
    
    // 拿到返回信号方式一：
    RACSignal *signal =  [command execute:@"11"];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"拿到信号的方式一%@",x);
    }];
    
    // 3.执行命令
    [command execute:@"11"];
    
    // 监听命令是否执行完毕
    [command.executing subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            NSLog(@"命令正在执行");
        }
        else {
            NSLog(@"命令完成/没有执行");
        }
    }];
}





@end
