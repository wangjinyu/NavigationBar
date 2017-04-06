//
//  UINavigationController+CodeFragments.h
//  TransparentNavigationBar
//
//  Created by jinyu on 2017/4/5.
//  Copyright © 2017年 jinyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CodeFragments) <UINavigationBarDelegate>

- (UIStatusBarStyle)preferredStatusBarStyle;

@end


@interface UIViewController (CMTransition)

@property (nonatomic, assign) CGFloat    navigationBarBgAlpha;
@property (nonatomic, strong) UIColor   *navigationBarTintColor;

@end
