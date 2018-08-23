//
//  UIViewController+HomeVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/2/23.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DeviceVC.h"
#import "BookShelfMainView.h"
#import "ItemData.h"
#import "ArrayTool.h"
#import "DBDeviceManager.h"
#import "AddDeviceVC.h"

@interface DeviceVC ()
@property (nonatomic, strong) NSMutableArray *modelSource;
@property (nonatomic, weak)   BookShelfMainView *bookShelfMainView;
@end


@implementation DeviceVC


#pragma mark -life
-(void)viewDidLoad{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"updateDeviceSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:@"pauseRecv" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countine) name:@"countineRecv" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopScynDevice) name:@"updateDeviceOver" object:nil];
    
    self.title = NSLocalizedString(@"设备", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(adddevice) Title:NSLocalizedString(@"新增",nil) withTintColor:RGB(53, 167, 255)];
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 144)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIView *red = [[UIView alloc] init];
    red.backgroundColor = [UIColor redColor];
    [self.view addSubview:red];
    [red mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(-30);
        make.height.equalTo(12);
        make.width.equalTo(25);
        make.top.equalTo(12+64);
    }];
    
    UILabel *redLb = [[UILabel alloc] init];
    redLb.textAlignment = NSTextAlignmentCenter;
    redLb.text = NSLocalizedString(@"触发", nil);
    redLb.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:redLb];
    [redLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20);
        make.left.equalTo(red.mas_right).offset(10);
        make.centerY.equalTo(red);
    }];
    
    UILabel *greenLb = [[UILabel alloc] init];
    greenLb.text = NSLocalizedString(@"正常", nil);
    greenLb.textAlignment = NSTextAlignmentCenter;
    greenLb.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:greenLb];
    [greenLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(redLb);
        make.right.equalTo(red.mas_left).offset(-10);
    }];
    
    UIView *green = [[UIView alloc] init];
    green.backgroundColor = [UIColor greenColor];
    [self.view addSubview:green];
    [green mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(red);
        make.right.equalTo(greenLb.mas_left).offset(-10);
    }];
    
    UIView *gray = [[UIView alloc] init];
    gray.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:gray];
    [gray makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redLb.mas_right).offset(10);
        make.top.height.width.equalTo(red);
    }];
    
    UILabel *grayLb = [[UILabel alloc] init];
    grayLb.textAlignment = NSTextAlignmentCenter;
    grayLb.text = NSLocalizedString(@"离线", nil);
    grayLb.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:grayLb];
    [grayLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gray.mas_right).offset(10);
        make.centerY.equalTo(gray);
    }];
    
    //添加 分组组建
    BookShelfMainView *bookShelfView = [BookShelfMainView loadFromNib];
    bookShelfView.subVC = self;
    bookShelfView.delegate = [RACSubject subject];
    //@weakify(self)
    [bookShelfView.delegate subscribeNext:^(id x) {
        //同步
        //@strongify(self)

    }];
    [self.view addSubview:bookShelfView];
    self.bookShelfMainView = bookShelfView;
    WS(ws)
    [bookShelfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left);
        make.right.equalTo(ws.view.mas_right);
        make.top.equalTo(44+64);
        make.bottom.equalTo(ws.view.mas_bottom);
    }];
    
    [bookShelfView initWithData:self.modelSource];
    [self.bookShelfMainView.model addObserver:self forKeyPath:@"itemsDataArr" options:NSKeyValueObservingOptionNew context:nil];
    
}


-(void)viewWillAppear:(BOOL)animated{
        [self loadData];
        [self countine];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self pause];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma -mark method

-(void)adddevice{
    AddDeviceVC *wl = [[AddDeviceVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wl];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)loadData{
  
//    if(!_initdataArray){
//        _initdataArray = [[NSMutableArray<ItemData *> alloc] init];
//        ItemData * itemdata = [[ItemData alloc] initWithTitle:@"dsa" DevID:1 DevType:@"0300" Code:@"04645501"];
//        ItemData * itemdata2 = [[ItemData alloc] initWithTitle:@"dsa" DevID:2 DevType:@"0006" Code:@"04645501"];
//        ItemData * itemdata3 = [[ItemData alloc] initWithTitle:@"dsa" DevID:3 DevType:@"0109" Code:@"04645501"];
//
//        [_initdataArray addObject:itemdata];
//        [_initdataArray addObject:itemdata2];
//        [_initdataArray addObject:itemdata3];
//    }
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    NSMutableArray * _initdataArray = [[DBDeviceManager sharedInstanced] queryAllDevice:currentgateway2];
    if (!self.modelSource) {
        self.modelSource = [[NSMutableArray alloc]init];

    }
    
    
    self.modelSource  = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@_%@_devices.archiver",[config2 objectForKey:@"UserName"],currentgateway2]]];
    
    self.modelSource = [ArrayTool addJudgeArr:self.modelSource UpdateArr:_initdataArray];
    self.modelSource = [ArrayTool deletJundgeArr:self.modelSource UpdateArr:_initdataArray];
    self.modelSource = [ArrayTool updateJundgeArr:self.modelSource UpdateArr:_initdataArray];
    
    [self.bookShelfMainView initWithData:self.modelSource];
    [self.bookShelfMainView reloadData];
}


/**
 KVO
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    [NSKeyedArchiver archiveRootObject:_bookShelfMainView.model.itemsDataArr toFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@_%@_devices.archiver",[config2 objectForKey:@"UserName"],currentgateway2]]];
}

/**
 暂停接受消息
 */
- (void)pause{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDeviceSuccess" object:nil];
}

/**
 继续接受消息
 */
- (void)countine{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"updateDeviceSuccess" object:nil];
}

@end
