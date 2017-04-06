//
//  SecondViewController.m
//  TransparentNavigationBar
//
//  Created by jinyu on 2017/4/5.
//  Copyright © 2017年 jinyu. All rights reserved.
//

#import "SecondViewController.h"
#import "UINavigationController+CodeFragments.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarBgAlpha = 1.0;
    self.navigationBarTintColor = [UIColor greenColor];
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
