//
//  ViewController.m
//  demo01_NSThread
//
//  Created by LuoShimei on 16/5/11.
//  Copyright © 2016年 罗仕镁. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark========系统方法=========
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark=====放于 线程中执行任务的 代码====
/** 模拟下载任务 */
- (void)download{
    //在控制台打印输出当前任务所在的线程信息
    NSLog(@"[thread info]:%@",[NSThread currentThread]);
    for (int i = 0; i <= 100; i++) {
        if (i == 5) {
            //类方法：会自动退出当前方法所在线程
            [NSThread exit];
        }
    }
}

#pragma mark========关联方法========
/** performSelector开启线程 */
- (IBAction)performMethod:(id)sender {
    //iOS9之后，apple公司认为这种方式是不安全的，故不推荐使用
    [self performSelectorInBackground:@selector(download) withObject:nil];
}

/** 类方法开启线程 */
- (IBAction)classMethod:(id)sender {
    //此类方法好处：方便快捷，调用之后直接创建子线程
    //坏处：但是无法定义线程的名字和优先级等。无法决定线程开启的时机。
    [NSThread detachNewThreadSelector:@selector(download) toTarget:self withObject:nil];
}

/** 对象方法开启线程 */
- (IBAction)objectMethod:(id)sender {
    //创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(download) object:nil];
    
    //定义线程的名字
    thread.name = @"downloadThread";
    
    /**
     * 设置线程的优先级：线程的优先级是在多个线程在同时启动的时候才起作用，这时
     * 内部会根据线程的优先级先后开启线程，优先级高的优先开启
     * 优先级的取值范围是0~1.0之间，数值越大，优先级越高
     
     * 关于优先级 iOS8之后 使用新的枚举类型 qualityOfService
     * NSQualityOfService{
     * NSQualityOfServiceUserInteractive = 0x21,
     * NSQualityOfServiceUserInitiated = 0x19,
     * NSQualityOfServiceUtility = 0x11,
     * NSQualityOfServiceBackground = 0x09,
     * NSQualityOfServiceDefault = -1}
     * NSQualityOfService有以下5个枚举值，以从高到低排列
     * UserInteractive:和图形处理有关的，例如滚动和动画。 优先级最高
     * UserInitiaed:用户请求的任务，例如用户点开某个App,或者用户使用某个功能
     * Uility:周期性操作，例如邮件App设定每五分钟接收一次邮件。
     * BackGround:后台任务,用户察觉不到的
     * Default:最低
    */
    thread.threadPriority = 0.6;
    
    //线程占用多大的栈空间，单位为B(字节)
    NSInteger stackSize = thread.stackSize;
    NSLog(@"名字为downloadThread的线程占用的空间大小为%ldB，%ldKB，%.2lfMB",stackSize,stackSize/1024,stackSize/1024.0/1024.0);
    
    //定线程
    [thread start];
}
@end
