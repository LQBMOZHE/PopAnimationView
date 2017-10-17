//
//  ViewController.m
//  LQBAnimationPopView
//
//  Created by 刘庆兵 on 2017/9/28.
//  Copyright © 2017年 Qingbing Liu. All rights reserved.
//

#import "ViewController.h"
#import "LQBAnimationPopView.h"
#import "AlterView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong)  id customView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataAndSubViews];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"LQBAnimationPopViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
//    cell.textLabel.text = _dataList[indexPath.row][@"title"];
    if (indexPath.row >= 0 && indexPath.row < _dataList.count) {
        NSDictionary *dict = _dataList[indexPath.row];
        cell.textLabel.text = dict[@"title"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= 0 && indexPath.row < _dataList.count) {
        NSDictionary *dict = _dataList[indexPath.row];
        NSInteger style = ((NSNumber *)dict[@"style"]).integerValue;
        [self showPopAnimationWithAnimationStyle:style];
    }
}

#pragma mark 显示弹框
- (void)showPopAnimationWithAnimationStyle:(NSInteger)style
{
    _customView = [AlterView xib];

    LQBAnimationPopStyle popStyle = (style == 8) ? LQBAnimationPopStyleCardDropFromLeft : (LQBAnimationPopStyle)style;
    LQBAnimationDismissStyle dismissStyle = (LQBAnimationDismissStyle)style;
    
    // 1.初始化
    LQBAnimationPopView *popView = [[LQBAnimationPopView alloc] initWithCustomView:_customView popStyle:popStyle dismissStyle:dismissStyle];
    
    // 2.设置属性，可不设置使用默认值，见注解
    // 2.1 显示时点击背景是否移除弹框
    popView.isClickBGDismiss = YES;//![_customView isKindOfClass:[SlideSelectCardView class]];
    // 2.2 显示时背景的透明度
    popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    popView.isObserverOrientationChange = YES;
    // 2.4 显示时动画时长
    //    popView.popAnimationDuration = 0.8f;
    // 2.5 移除时动画时长
    //    popView.dismissAnimationDuration = 0.8f;
    
    // 2.6 显示完成回调
    popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    
    // 3.处理自定义视图操作事件
    [self handleCustomActionEnvent:popView];
    
    // 4.显示弹框
    [popView pop];
}

#pragma mark 处理自定义视图操作事件
- (void)handleCustomActionEnvent:(LQBAnimationPopView *)popView
{
     __weak typeof(popView) weakPopView = popView;
    AlterView *alterView = _customView;

    alterView.canceSureActionBlock = ^(BOOL isSure) {
        [weakPopView dismiss];
        NSLog(@"点击了%@", isSure ? @"确定" : @"取消");
    };
}
- (void)initDataAndSubViews
{
    _dataList = @[@{@"title" : @"卡片式掉落动画(从左侧)", @"style" : @6},
                  @{@"title" : @"卡片式掉落动画(从右侧)", @"style" : @7},
                  @{@"title" : @"卡片式掉落动画(往顶部平滑消失)", @"style" : @8},
                  @{@"title" : @"从顶部掉落晃动动画", @"style" : @2},
                  @{@"title" : @"从底部掉落晃动动画", @"style" : @3},
                  @{@"title" : @"从左侧掉落晃动动画", @"style" : @4},
                  @{@"title" : @"从右侧掉落晃动动画", @"style" : @5},
                  @{@"title" : @"缩放动画", @"style" : @1},
                  @{@"title" : @"无动画", @"style" : @0}];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
