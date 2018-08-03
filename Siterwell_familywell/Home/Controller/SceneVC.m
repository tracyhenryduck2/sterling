//
//  UIViewController+HomeVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/2/23.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SceneVC.h"
#import "SystemSceneCell.h"

@interface SceneVC() <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *table_scene;

@end
@implementation SceneVC

#pragma -mark life

-(void)viewDidLoad{
        NSLog(@"viewDidLoad");
    self.title = NSLocalizedString(@"情景", nil);
    [self table_scene];
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated{
     NSLog(@"viewWillDisappear");
}


-(void)viewDidDisappear:(BOOL)animated{
     NSLog(@"viewDidDisappear");
}

#pragma -mark lazy

- (UITableView *)table_scene {
    if (!_table_scene) {
        _table_scene = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table_scene.dataSource = self;
        _table_scene.delegate = self;
        _table_scene.rowHeight = 60;
        _table_scene.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _table_scene.backgroundColor = RGB(239, 239, 243);
        _table_scene.tableFooterView = [UIView new];
        [self.view addSubview:_table_scene];
        [_table_scene mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _table_scene;
}

#pragma -mark delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SystemSceneCell";
    SystemSceneCell *cell = (SystemSceneCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SystemSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.titleLabel.text = @"Testing";
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


@end
