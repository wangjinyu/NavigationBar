//
//  UINavigationController+CodeFragments.m
//  TransparentNavigationBar
//
//  Created by jinyu on 2017/4/5.
//  Copyright © 2017年 jinyu. All rights reserved.
//

#import "UINavigationController+CodeFragments.h"
#include <objc/runtime.h>
#import <Availability.h>

@implementation UINavigationController (CodeFragments)

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController) {
        return self.topViewController.preferredStatusBarStyle;
    }
    return UIStatusBarStyleDefault;
}

- (instancetype)init {
    if (self = [super init]) {
        self.navigationBar.translucent = YES;
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.navigationBar.translucent = YES;
}

+ (void)initialize {
    if (self == [UINavigationController class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *interactiveTransitionString = @"cm_updateInteractiveTransition:";
            NSString *popToString = @"cm_popToViewController:animated:";
            NSString *popString = @"cm_popViewControllerAnimated:";
            NSString *popToRootString = @"cm_popToRootViewControllerAnimated:";
            
            SEL interactiveSEL = NSSelectorFromString(@"_updateInteractiveTransition:");
            SEL popToSEL         = @selector(popToViewController:animated:);
            SEL popSEL         = @selector(popViewControllerAnimated:);
            SEL popToRootSEL   = @selector(popToRootViewControllerAnimated:);
            
            method_exchangeImplementations(class_getInstanceMethod([self class], interactiveSEL), class_getInstanceMethod([self class], NSSelectorFromString(interactiveTransitionString)));
            
            method_exchangeImplementations(class_getInstanceMethod([self class], popToSEL), class_getInstanceMethod([self class], NSSelectorFromString(popToString)));
            
            method_exchangeImplementations(class_getInstanceMethod([self class], popSEL), class_getInstanceMethod([self class], NSSelectorFromString(popString)));
            
            method_exchangeImplementations(class_getInstanceMethod([self class], popToRootSEL), class_getInstanceMethod([self class], NSSelectorFromString(popToRootString)));
        });
    }
}

- (void)cm_updateInteractiveTransition:(CGFloat)percentComplete {
    if (self.topViewController) {
        UIViewController *topViewController = self.topViewController;
        id <UIViewControllerTransitionCoordinator> transitionCoordinator = topViewController.transitionCoordinator;
        
        UIViewController *fromViewController = [transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        
        // bg alpha.
        CGFloat fromViewControllerAlpha = fromViewController.navigationBarBgAlpha;
        CGFloat toViewControllerAlpha = toViewController.navigationBarBgAlpha;
        CGFloat newAlpha = fromViewControllerAlpha + (toViewControllerAlpha - fromViewControllerAlpha) * percentComplete;
        
        [self setNeedsnavigationBarBackgroundAlpha:newAlpha];
        
        //TInt Color.
        
        UIColor *fromColor = fromViewController.navigationBarTintColor;
        UIColor *toColor = toViewController.navigationBarTintColor;
        UIColor *newColor = [self averageColorFromColor:fromColor toColor:toColor percent:percentComplete];
        self.navigationBar.barTintColor = newColor;
        if (toViewController.navigationBarBgAlpha == 0) {
            if ([self colorBrigntness:toViewController.view.backgroundColor] > 0.5) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            } else {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            }
        } else {
            if ([self colorBrigntness:newColor] > 0.5) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            } else {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            }
        }
        [self cm_updateInteractiveTransition:percentComplete];
    } else {
        [self cm_updateInteractiveTransition:percentComplete];
        return;
    }
}
- (nullable NSArray<UIViewController *> *)cm_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self setNeedsnavigationBarBackgroundAlpha:viewController.navigationBarBgAlpha];
    self.navigationBar.barTintColor = viewController.navigationBarTintColor;
    if (viewController.navigationBarBgAlpha == 0) {
        if ([self colorBrigntness:viewController.view.backgroundColor] > 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    } else {
        if ([self colorBrigntness:viewController.navigationBarTintColor] > 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }

    return [self cm_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)cm_popToRootViewControllerAnimated:(BOOL)animated {
    [self setNeedsnavigationBarBackgroundAlpha:[self.viewControllers.firstObject navigationBarBgAlpha]];
    self.navigationBar.barTintColor = [self.viewControllers.firstObject navigationBarTintColor];
    if (self.viewControllers.firstObject.navigationBarBgAlpha == 0) {
        if ([self colorBrigntness:self.viewControllers.firstObject.view.backgroundColor] > 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    } else {
        if ([self colorBrigntness:[self.viewControllers.firstObject navigationBarTintColor]] > 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }

    return [self cm_popToRootViewControllerAnimated:animated];
}

- (UIViewController*)cm_popViewControllerAnimated:(BOOL)animated {
    [self setNeedsnavigationBarBackgroundAlpha:[self.viewControllers.firstObject navigationBarBgAlpha]];
    self.navigationBar.barTintColor = [self.viewControllers.firstObject navigationBarTintColor];
    if (self.viewControllers.firstObject.navigationBarBgAlpha == 0) {
        if ([self colorBrigntness:self.viewControllers.firstObject.view.backgroundColor] > 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    } else {
        if ([self colorBrigntness:[self.viewControllers.firstObject navigationBarTintColor]] > 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
    return [self cm_popViewControllerAnimated:animated];
}

- (UIColor*)averageColorFromColor:(UIColor*)fromColor toColor:(UIColor*)toColor percent:(CGFloat)percent {
    CGFloat  fromRed, fromGreen, fromBlue, fromAlpha;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    CGFloat  toRed, toGreen, toBlue, toAlpha;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreed = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    
    return [UIColor colorWithRed:newRed green:newGreed blue:newBlue alpha:newAlpha];
}

- (CGFloat)colorBrigntness:(UIColor*)aColor {
    CGFloat hue, saturation, brigntness, alpha;
    [aColor getHue:&hue saturation:&saturation brightness:&brigntness alpha:&alpha];
    return brigntness;
}

- (void)setNeedsnavigationBarBackgroundAlpha:(CGFloat)alpha {
    UIView *barBgView = self.navigationBar.subviews[0];
    UIView *shadowView = [barBgView valueForKey:@"_shadowView"];
    if (shadowView) {
        shadowView.alpha = 0.0;
    }
    if (self.navigationBar.isTranslucent) {
#ifdef __IPHONE_10_0
        UIView *bgEffectView = [barBgView valueForKey:@"_backgroundEffectView"];
        if (bgEffectView && [self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] == nil) {
            bgEffectView.alpha = alpha;
            return;
        }
#else
        UIView *adaptiveBackDrop = [barBgView valueForKey:@"_adaptiveBackdrop"];
        UIView *backDropEffectView = [adaptiveBackDrop valueForKey:@"_backdropEffectView"];
        if (adaptiveBackDrop && backDropEffectView) {
            backDropEffectView.alpha = alpha;
            return;
        }
#endif
    }
    barBgView.alpha = alpha;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    UIViewController *topVc = self.topViewController;
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = topVc.transitionCoordinator;
    BOOL interactive = transitionCoordinator.initiallyInteractive;
    if (topVc && transitionCoordinator && interactive) {
        
#ifdef __IPHONE_10_0
        [transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            [self dealInteractionChanges:context];
        }];
#else
        [transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            [self dealInteractionChanges:context];
        }];
#endif
        return YES;
    }
    
    NSInteger itemCount = navigationBar.items.count;
    NSInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVc = [self.viewControllers objectAtIndex:self.viewControllers.count - n];
    [self popToViewController:popToVc animated:YES];
    return YES;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    
    id<UIViewControllerTransitionCoordinator> coordinator = self.topViewController.transitionCoordinator;
    CGFloat duration = coordinator.transitionDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve: coordinator.completionCurve];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:duration];
    navigationBar.barTintColor = self.topViewController.navigationBarTintColor;
    if (self.topViewController.navigationBarBgAlpha == 0) {
        if ([self colorBrigntness:self.topViewController.view.backgroundColor] > 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    } else {
        if ([self colorBrigntness:self.topViewController.navigationBarTintColor] > 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
    
    [self setNeedsnavigationBarBackgroundAlpha:[self.topViewController navigationBarBgAlpha]];
    [UIView commitAnimations];
    return YES;
}

- (void)dealInteractionChanges:(id <UIViewControllerTransitionCoordinatorContext>) context {
    if ([context isCancelled]) {
        NSTimeInterval cancelDuration = context.transitionDuration * context.percentComplete;
        UIViewController *fromVc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        [UIView animateWithDuration:cancelDuration animations:^{
            CGFloat nowAlpha = [fromVc navigationBarBgAlpha];
            [self setNeedsnavigationBarBackgroundAlpha:nowAlpha];
            UIColor *color = [fromVc navigationBarTintColor];
            self.navigationBar.barTintColor = color;
            if (fromVc.navigationBarBgAlpha == 0) {
                if ([self colorBrigntness:fromVc.view.backgroundColor] > 0.5) {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                } else {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            } else {
                if ([self colorBrigntness:color] > 0.5) {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                } else {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            }
        }];
    } else {
        NSTimeInterval finishSuration = context.transitionDuration * (1 - context.percentComplete);
        UIViewController *toVc = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        [UIView animateWithDuration:finishSuration animations:^{
            CGFloat nowAlpha = [toVc navigationBarBgAlpha];
            [self setNeedsnavigationBarBackgroundAlpha:nowAlpha];
            self.navigationBar.barTintColor = [toVc navigationBarTintColor];
            if ([toVc navigationBarBgAlpha] == 0) {
                if ([self colorBrigntness:toVc.view.backgroundColor] > 0.5) {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                } else {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            } else {
                if ([self colorBrigntness:[toVc navigationBarTintColor]] > 0.5) {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                } else {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            }
        }];
    }
}

@end

@implementation UIViewController (CMTransition)

- (void)setNavigationBarBgAlpha:(CGFloat)navigationBarBgAlpha {
    objc_setAssociatedObject(self, &"navi_bar_bg_alpha", @(MAX(MIN(navigationBarBgAlpha, 1.0), 0.0)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNeedsnavigationBarBackgroundAlpha:navigationBarBgAlpha];
}

- (CGFloat)navigationBarBgAlpha {
    return [objc_getAssociatedObject(self, &"navi_bar_bg_alpha") floatValue];
}

- (void)setNavigationBarTintColor:(UIColor *)navigationBarTintColor {
    [self.navigationController.navigationBar setBarTintColor:navigationBarTintColor];
    if (self.navigationBarBgAlpha == 0.0) {
        if ([self colorBrigntness:self.view.backgroundColor] > 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    } else {
        if ([self colorBrigntness:navigationBarTintColor] > 0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
    objc_setAssociatedObject(self, &"navi_bar_tint_color", navigationBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)colorBrigntness:(UIColor*)aColor {
    CGFloat hue, saturation, brigntness, alpha;
    [aColor getHue:&hue saturation:&saturation brightness:&brigntness alpha:&alpha];
    return brigntness;
}

- (UIColor*)navigationBarTintColor {
    return objc_getAssociatedObject(self, &"navi_bar_tint_color");
}
@end
