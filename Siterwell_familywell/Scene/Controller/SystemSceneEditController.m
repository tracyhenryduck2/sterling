//
//  SystemSceneEditController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SystemSceneEditController.h"

@interface SystemSceneEditController()

@property (nonatomic,strong) UITextField *titleTextFiled;

@end

@implementation SystemSceneEditController

#pragma -mark life

-(void)viewDidLoad{
    [super viewDidLoad];
    UITextField * enterTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width-60, 30)];
    enterTextField.backgroundColor = RGB(242, 242, 245);
    enterTextField.layer.cornerRadius = 15.0f;
    enterTextField.placeholder = NSLocalizedString(@"请输入情景模式名称", nil);
    CGRect frame = enterTextField.frame;
    frame.size.width = 20;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    enterTextField.leftViewMode = UITextFieldViewModeAlways;
    enterTextField.leftView = leftview;
    _titleTextFiled = enterTextField;
    if ( [self.scene_type intValue] <= 2 && _edit == YES) {
        _titleTextFiled.enabled = NO;
        switch ([_scene_type intValue]) {
            case 0:
                _titleTextFiled.text = NSLocalizedString(@"在家", nil);
                break;
            case 1:
                _titleTextFiled.text = NSLocalizedString(@"离家", nil);
                break;
            case 2:
                _titleTextFiled.text = NSLocalizedString(@"睡眠", nil);
                break;
            default:
                break;
        }
    }else{
        _titleTextFiled.enabled = YES;
    }
    self.navigationItem.titleView = enterTextField;
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:ThemeColor];
}


@end
