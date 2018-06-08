//
//  TYImageProcessingViewController.m
//  Imaga_Template
//
//  Created by 汤义 on 2018/6/8.
//  Copyright © 2018年 yitang. All rights reserved.
//

#import "TYImageProcessingViewController.h"
#import "TYPublicMethods.h"
#import "TYImageProcessing.h"
#import <Accelerate/Accelerate.h>
#import "extobjc.h"

#define w [UIScreen mainScreen].bounds.size.width
#define h [UIScreen mainScreen].bounds.size.height
@interface TYImageProcessingViewController ()
@property (nonatomic, weak) UIImageView *imageView1;
@property (nonatomic, weak) UIImageView *imageView2;
@end

@implementation TYImageProcessingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView {
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(10, 100, 100, 30);
    but.backgroundColor = [UIColor yellowColor];
    [but setTitle:@"处理图片" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(selectorBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140, w, 300)];
    imageView1.backgroundColor = [UIColor redColor];
    imageView1.image = [TYPublicMethods addWithFilePathStr:@"260"];
    [self.view addSubview:_imageView1 = imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 450, w, 300)];
    imageView2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_imageView2 = imageView2];
}

- (void)selectorBut {
    CGImageRef imageRef = [TYImageProcessing nonAlphaImageWithImage:_imageView1.image.CGImage];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    _imageView2.image = image;
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
