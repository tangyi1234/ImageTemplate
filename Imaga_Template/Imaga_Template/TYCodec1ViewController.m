//
//  TYCodec1ViewController.m
//  Imaga_Template
//
//  Created by 汤义 on 2018/6/15.
//  Copyright © 2018年 yitang. All rights reserved.
//

#import "TYCodec1ViewController.h"
#import "TYImageCodec.h"

#define w [UIScreen mainScreen].bounds.size.width
#define h [UIScreen mainScreen].bounds.size.height
@interface TYCodec1ViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation TYCodec1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    scrollView.delegate = self;
    [self.view addSubview:_scrollView = scrollView];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = CGRectMake(10, 0, 100, 30);
    but1.backgroundColor = [UIColor redColor];
    [but1 setTitle:@"转yuv" forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(selectorBut1) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:but1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, h - 400, w, 400)];
    imageView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_imageView = imageView];
}

- (void)selectorBut1 {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageBut1) object:nil];
    [operationQueue addOperation:op];
}

- (void)downloadImageBut1 {
    NSURL *imageURL = [NSURL URLWithString:@"http://10.10.61.218:8080/name/8.png"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [TYImageCodec addWithConversionYUV:imageData imageRefYUV:^(CGImageRef imageRef) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [self performSelectorOnMainThread:@selector(updateUIBut1:) withObject:image waitUntilDone:YES];
    }];
}

- (void)updateUIBut1:(UIImage *)image {
    _imageView.image = image;
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    
    NSUInteger length = [imageData length]/1000;
    NSLog(@"图片大小:%lu",(unsigned long)length);
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
