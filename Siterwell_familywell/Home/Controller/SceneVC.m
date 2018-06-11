//
//  UIViewController+HomeVC.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/2/23.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SceneVC.h"

@implementation SceneVC

#pragma -mark life

-(void)viewDidLoad{
        NSLog(@"viewDidLoad");
    
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
@end
