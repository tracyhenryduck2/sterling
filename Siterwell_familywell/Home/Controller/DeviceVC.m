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

@interface DeviceVC ()
@property (nonatomic, strong) NSMutableArray *modelSource;
@property (nonatomic, weak)   BookShelfMainView *bookShelfMainView;
@end


@implementation DeviceVC


#pragma mark -life
-(void)viewDidLoad{
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:nil Title:NSLocalizedString(@"新增",nil) withTintColor:RGB(53, 167, 255)];
    
    self.title = NSLocalizedString(@"设备",nil);
    
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
        //        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        //        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        //氦氪云接口获取设备状态
        //[self deviceSycn];
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
    
}


-(void)viewWillAppear:(BOOL)animated{
        [self loadData];
}


-(void)dealloc{
   
}

#pragma -mark method

-(void)loadData{
  
    if (!self.modelSource) {
        self.modelSource = [[NSMutableArray alloc]init];
        ItemData * itemdata = [[ItemData alloc] initWithTitle:@"dsa" DevID:[@1 integerValue] DevType:@"0300" Code:@"04645501"];
                ItemData * itemdata2 = [[ItemData alloc] initWithTitle:@"dsa" DevID:[@2 integerValue] DevType:@"0006" Code:@"04645501"];
                ItemData * itemdata3 = [[ItemData alloc] initWithTitle:@"dsa" DevID:[@3 integerValue] DevType:@"0109" Code:@"04645501"];
        
        [self.modelSource addObject:itemdata];
              [self.modelSource addObject:itemdata2];
              [self.modelSource addObject:itemdata3];
    }
    
    
    [self.bookShelfMainView initWithData:self.modelSource];
    [self.bookShelfMainView reloadData];
}

@end
