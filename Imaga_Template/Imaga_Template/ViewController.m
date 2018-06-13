//
//  ViewController.m
//  Imaga_Template
//
//  Created by yitang on 2018/5/31.
//  Copyright © 2018年 yitang. All rights reserved.
//

#import "ViewController.h"
#import "TYImageProcessingViewController.h"
#import "TYCodecViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initButView];
}

- (void)initButView {
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(10, 100, 100, 30);
    but.backgroundColor = [UIColor redColor];
    [but setTitle:@"跳转" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(selectorBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = CGRectMake(10, 140, 100, 30);
    but1.backgroundColor = [UIColor yellowColor];
    [but1 setTitle:@"编解码" forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(selectorBut1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but1];
}

- (void)selectorBut {
    TYImageProcessingViewController *vc = [[TYImageProcessingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectorBut1 {
    TYCodecViewController *vc = [[TYCodecViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
