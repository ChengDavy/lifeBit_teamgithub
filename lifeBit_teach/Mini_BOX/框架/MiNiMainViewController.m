//
//  MiNiMainViewController.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/8/24.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "MiNiMainViewController.h"

@interface MiNiMainViewController ()<GPDockItemDelegate>{
    MiNiStartViewController   * _start;
    MiNiSetViewController     * _set;
    MiNiRealViewController    * _real;
    MiNiSportsStViewController* _sportsSt;
    MiNiHistoryViewController * _history;
    MiNiCoachSetViewController* _coachSet;
    GPDock * _dock;
    
}

@end

@implementation MiNiMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor greenColor];
    
    [self addVc];
    
    self.tabBar.hidden=YES;
    
    //加入侧边栏Dock
    _dock=[[GPDock alloc]initWithFrame:CGRectMake(0, 0,GPDockItemWidth, self.view.frame.size.height)];
    
    _dock.dockDelegate=self;
    
    [self.view addSubview:_dock];
    
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpToHistory:) name:KAddTestSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpToTest:) name:kMiBeginAction object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)jumpToHistory:(NSNotification*)not{
    
    [_dock jumpToViewByTag:3];
}

- (void)jumpToTest:(NSNotification*)not{
    
    [_dock jumpToViewByTag:1];
    
}

- (void)addVc{
    
    // 开始介绍
    _start = [[MiNiStartViewController alloc] init];
   
    UINavigationController *_startNaVC = [[UINavigationController alloc] initWithRootViewController:_start];
    
    // 实时情况
    _real = [[MiNiRealViewController alloc] init];
    
    UINavigationController *_realTiNaVC = [[UINavigationController alloc] initWithRootViewController:_real];
    
    // 运动统计
    _sportsSt = [[MiNiSportsStViewController alloc] init];
    
    UINavigationController *_sportsStNaVC = [[UINavigationController alloc] initWithRootViewController:_sportsSt];
    
    // 历史记录
    _history = [[MiNiHistoryViewController alloc] init];
    UINavigationController *_historyNaVC = [[UINavigationController alloc] initWithRootViewController:_history];
    
    // 设置
    _set = [[MiNiSetViewController alloc] init];
    UINavigationController *_setNaVC = [[UINavigationController alloc] initWithRootViewController:_set];
    
    // 教练设置
    _coachSet = [[MiNiCoachSetViewController alloc] init];
    UINavigationController *_coachsetNaVC = [[UINavigationController alloc] initWithRootViewController:_coachSet];
    
    self.viewControllers = [NSArray arrayWithObjects:_startNaVC,_realTiNaVC, _sportsStNaVC,_historyNaVC,_setNaVC,_coachsetNaVC, nil];
}

-(void)switchMainByTabItem:(GPDock *)gpdock originalTab:(int)start destinationTab:(int)end{
    
    self.selectedIndex = end;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
