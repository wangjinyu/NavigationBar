//
//  ViewController.m
//  TransparentNavigationBar
//
//  Created by jinyu on 2017/4/5.
//  Copyright © 2017年 jinyu. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+CodeFragments.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarBgAlpha = 1.0;
    self.navigationBarTintColor = [UIColor blackColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
