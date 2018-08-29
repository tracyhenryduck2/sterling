//
//  SceneEditController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SceneEditController.h"
#import "DBSceneManager.h"
#import "SceneListItemData.h"

@interface SceneEditController()

@property (nonatomic,strong) UITextField *titleTextFiled;
@property (nonatomic,copy) NSString *initcode;
@property (nonatomic,strong) NSMutableArray <SceneListItemData*>* inputList;
@property (nonatomic,strong) NSMutableArray <SceneListItemData*>* outputList;
@property (nonatomic,copy) NSString *trigger_style;
@end

@implementation SceneEditController{
    int dsa;
}

#pragma -mark life
-(void)viewDidLoad{
     [super viewDidLoad];
    UITextField * enterTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width-60, 30)];
    enterTextField.backgroundColor = RGB(242, 242, 245);
    enterTextField.layer.cornerRadius = 15.0f;
    enterTextField.placeholder = NSLocalizedString(@"请输入自定义情景名称", nil);
    CGRect frame = enterTextField.frame;
    frame.size.width = 20;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    enterTextField.leftViewMode = UITextFieldViewModeAlways;
    enterTextField.leftView = leftview;
    _titleTextFiled = enterTextField;
    self.navigationItem.titleView = enterTextField;
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:ThemeColor];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(backfinish) image:@"back_icon" highImage:nil withTintColor:[UIColor blackColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)initdata{
    NSUserDefaults *config2 = [NSUserDefaults standardUserDefaults];
    NSString * currentgateway2 = [config2 objectForKey:[NSString stringWithFormat:CurrentGateway,[config2 objectForKey:@"UserName"]]];
    
    if(_mid==nil){
        _inputList = [NSMutableArray new];
        _outputList = [NSMutableArray new];
        _trigger_style = @"00";
        SceneListItemData *ds = [[SceneListItemData alloc] init];
        [ds setType:@"add"];
        [_inputList addObject:ds];
        [_outputList addObject:ds];
    }else{
       SceneModel *model = [[DBSceneManager sharedInstanced] querySceneModel:_mid withDevTid:currentgateway2];
        _inputList = [model getInDeviceArray:currentgateway2];
        _outputList = [model getOutDeviceArray:currentgateway2];
        _trigger_style = [model getSelectType];
        SceneListItemData *ds = [[SceneListItemData alloc] init];
        [ds setType:@"add"];
        [_inputList addObject:ds];
        [_outputList addObject:ds];
    }
    
    
}

#pragma -mark method
-(void)backfinish{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
