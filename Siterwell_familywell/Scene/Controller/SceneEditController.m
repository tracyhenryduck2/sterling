//
//  SceneEditController.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SceneEditController.h"
@interface SceneEditController()



@end

@implementation SceneEditController{
    int dsa;
}

#pragma -mark life
-(void)viewDidLoad{
     [super viewDidLoad];
    self.title = NSLocalizedString(@"编辑情景", nil);
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

-(void)viewDidAppear:(BOOL)animated{
    
}


#pragma -mark method
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
