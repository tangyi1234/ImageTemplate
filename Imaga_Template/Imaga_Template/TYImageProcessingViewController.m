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
@interface TYImageProcessingViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView1;
@property (nonatomic, weak) UIImageView *imageView2;
@property (nonatomic, weak) UIImageView *imageView3;
@end

@implementation TYImageProcessingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(10, 100, 100, 30);
    but.backgroundColor = [UIColor yellowColor];
    [but setTitle:@"处理图片" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(selectorBut) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:but];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140, w, 300)];
    imageView1.backgroundColor = [UIColor redColor];
    imageView1.image = [TYPublicMethods addWithFilePathStr:@"260"];
    [scrollView addSubview:_imageView1 = imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 450, w, 300)];
    imageView2.backgroundColor = [UIColor greenColor];
    imageView2.image = [TYPublicMethods addWithFilePathStr:@"20008"];
    [scrollView addSubview:_imageView2 = imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 760, w, 300)];
    imageView3.backgroundColor = [UIColor magentaColor];
    [scrollView addSubview:_imageView3 = imageView3];
    
    scrollView.contentSize = CGSizeMake(w,1070);
}

- (void)selectorBut {
//    CGImageRef imageRef = [TYImageProcessing nonAlphaImageWithImage1:_imageView1.image.CGImage];
//    CGImageRef imageRef = [TYImageProcessing fillWithColorImage:_imageView1.image.CGImage colorsRef:[UIColor redColor].CGColor];
//    CGImageRef imageRef = [TYImageProcessing imageWithSynthesis:_imageView1.image.CGImage bImage:_imageView2.image.CGImage point:CGPointMake(100, 300)];
//    CGImageRef imageRef = [TYImageProcessing zoomWithimage:_imageView1.image.CGImage size:CGSizeMake(200, 200)];
//    CGImageRef imageRef = [TYImageProcessing shearWithimage:_imageView1.image.CGImage rect:CGRectMake(w - 100, 100, 500, 500)];
//    CGImageRef imageRef = [TYImageProcessing mirrorWithImage:_imageView1.image.CGImage state:NO];
//    CGImageRef imageRef = [TYImageProcessing rotatingWithImage:_imageView1.image.CGImage radians:90];
    CGImageRef imageRef = [TYImageProcessing shear1WithImage:_imageView1.image.CGImage offset:CGVectorMake(509, 50) translation:1 slope:1 scale:10 horizontal:YES];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    _imageView3.image = image;
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
