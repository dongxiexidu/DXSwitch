//
//  FUISwitch.h
//  FlatUI
//
//  Created by Jack Flintermann on 5/3/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIControl : UIView
@interface FUISwitch : UIControl
// 1.只在添加时作用一次. 添加结束后以后设置便不再改变 可以移出开关的父控件.而把开关从新加入到window上
// 可以统一设置全局作用
// 在iOS属性后有UI_APPEARANCE_SELECTOR标志都可以一次性统一设置.这种情况还有很多.比如说统一设置UITabbarItem的文字颜色
@property(nonatomic,getter=isOn) BOOL on;
@property(nonatomic, strong, readwrite) UIColor *onBackgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, readwrite) UIColor *offBackgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, readwrite) UIColor *onColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, readwrite) UIColor *offColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, readwrite) UIColor *highlightedColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, readwrite) CGFloat switchCornerRadius UI_APPEARANCE_SELECTOR;
@property(nonatomic, readwrite) CGFloat percentOn;
@property(weak, readwrite, nonatomic) UILabel *offLabel;
@property(weak, readwrite, nonatomic) UILabel *onLabel;

- (void)setOn:(BOOL)on animated:(BOOL)animated; // does not send action

@end
