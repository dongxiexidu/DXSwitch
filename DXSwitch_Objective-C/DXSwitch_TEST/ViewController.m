//
//  ViewController.m
//  DXSwitch_TEST
//
//  Created by fashion on 2018/8/23.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

#import "ViewController.h"
#import "FUISwitch.h"
#import "UIColor+FlatUI.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet FUISwitch *mySwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.mySwitch.onColor = [UIColor turquoiseColor];
//    self.mySwitch.offColor = [UIColor cloudsColor];
//    self.mySwitch.onBackgroundColor = [UIColor midnightBlueColor];
//    self.mySwitch.offBackgroundColor = [UIColor silverColor];

    
    FUISwitch *s = [[FUISwitch alloc] initWithFrame: CGRectMake(100, 200, 80, 40)];
    s.onBackgroundColor = [UIColor lightGrayColor];
    s.offBackgroundColor = [UIColor orangeColor];
    [self.view addSubview:s];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.cancelsTouchesInView = YES; // default YES
    [button addGestureRecognizer:tap];

}


- (void)tapAction:(UITapGestureRecognizer *)sender {
    NSLog(@"tapAction");
}

- (void)btnAction:(UIButton *)btn {
    NSLog(@"btnAction");
}



@end
