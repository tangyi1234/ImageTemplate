//
//  TYCodecViewController.m
//  Imaga_Template
//
//  Created by 汤义 on 2018/6/13.
//  Copyright © 2018年 yitang. All rights reserved.
//

#import "TYCodecViewController.h"
#import <ImageIO/ImageIO.h>
#if SD_MAC
#import <CoreServices/CoreServices.h>
#else
#import <MobileCoreServices/MobileCoreServices.h>
#endif
#import "TYPublicMethods.h"
#import "TYImageCodec.h"
#import "YYGIF.h"

#define w [UIScreen mainScreen].bounds.size.width
#define h [UIScreen mainScreen].bounds.size.height
@interface TYCodecViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation TYCodecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    scrollView.delegate = self;
    [self.view addSubview:_scrollView = scrollView];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(10, 0, 100, 30);
    but.backgroundColor = [UIColor redColor];
    [but setTitle:@"解码" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(selectorBut) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:but];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = CGRectMake(120, 0, 100, 30);
    but1.backgroundColor = [UIColor redColor];
    [but1 setTitle:@"网络解码" forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(selectorBut1) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:but1];
    
    UIButton *butVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    butVideo.frame = CGRectMake(w - 110, 0, 100, 30);
    butVideo.backgroundColor = [UIColor greenColor];
    [butVideo setTitle:@"视频解码" forState:UIControlStateNormal];
    [butVideo addTarget:self action:@selector(selectorButVideo) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:butVideo];
    
    UIButton *but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    but2.frame = CGRectMake(10, 30, 100, 30);
    but2.backgroundColor = [UIColor greenColor];
    [but2 setTitle:@"解码gif" forState:UIControlStateNormal];
    [but2 addTarget:self action:@selector(selectorBut2) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:but2];
    
    UIButton *but3 = [UIButton buttonWithType:UIButtonTypeCustom];
    but3.frame = CGRectMake(120, 30, 100, 30);
    but3.backgroundColor = [UIColor greenColor];
    [but3 setTitle:@"渐近式解码" forState:UIControlStateNormal];
    [but3 addTarget:self action:@selector(selectorBut3) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:but3];
    
    UIButton *but4 = [UIButton buttonWithType:UIButtonTypeCustom];
    but4.frame = CGRectMake(w - 110, 30, 100, 30);
    but4.backgroundColor = [UIColor greenColor];
    [but4 setTitle:@"转黑白色" forState:UIControlStateNormal];
    [but4 addTarget:self action:@selector(selectorBut4) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:but4];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, w, 300)];
    imageView.backgroundColor = [UIColor redColor];
    [scrollView addSubview:_imageView = imageView];
}

- (void)selectorBut {
    CGSize size = CGSizeMake(w, 300);
    NSData *data = [TYPublicMethods addWithFilePathDataStr:@"260"];
    [TYImageCodec decodingWithImageData:data imageReturn:^(CGImageRef imageRef, NSUInteger ws, NSUInteger hs) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        _imageView.frame = CGRectMake(0, 60, ws/3, hs/3);
        _imageView.image = image;
    }];
}

- (void)selectorBut1 {
    [self initImageView];
}

- (void)initImageView {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage) object:nil];
    [operationQueue addOperation:op];
}
//这里是在异步中执行
- (void)downloadImage {
    NSURL *imageURL = [NSURL URLWithString:@"http://10.10.61.218:8080/name/11.png"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [TYImageCodec decodingWithImageData:imageData imageReturn:^(CGImageRef imageRef, NSUInteger ws, NSUInteger hs) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        _imageView.frame = CGRectMake(0, 60, ws/3, hs/3);
        _scrollView.contentSize = CGSizeMake(ws/3, hs/3 + 100);
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
    }];
    
}

- (void)updateUI:(UIImage*)image {
    _imageView.image = image;
}

- (void)selectorBut2 {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImages) object:nil];
    [operationQueue addOperation:op];
}

- (void)selectorBut3 {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageBut3) object:nil];
    [operationQueue addOperation:op];
}

- (void)selectorBut4 {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageBut4) object:nil];
    [operationQueue addOperation:op];
}

- (void)downloadImages {
    NSURL *imageURL = [NSURL URLWithString:@"http://10.10.61.218:8080/name/movement.gif"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [TYImageCodec addWithMoreDynamicFigureData:imageData imageReturn:^(NSMutableArray *muArr) {
        NSLog(@"没有数据吗:%lu",(unsigned long)muArr.count);
        [self performSelectorOnMainThread:@selector(updateUIs:) withObject:muArr waitUntilDone:YES];
    }];
}

- (void)downloadImageBut3 {
    NSURL *imageURL = [NSURL URLWithString:@"http://10.10.61.218:8080/name/18.png"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [TYImageCodec addWithProgressiveDecodingData:imageData imageRefProgressive:^(CGImageRef imageRef) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [self performSelectorOnMainThread:@selector(updateUIBut3:) withObject:image waitUntilDone:YES];
    }];
//
//    [TYImageCodec addWithProgressiveDecodingData:imageData imageRefProgressive:^(NSData *imageData) {
//        UIImage *image = [UIImage imageWithData:imageData];
//        [self performSelectorOnMainThread:@selector(updateUIBut3:) withObject:image waitUntilDone:YES];
//    }];
}

- (void)downloadImageBut4 {
    NSURL *imageURL = [NSURL URLWithString:@"http://10.10.61.218:8080/name/18.png"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [TYImageCodec addWithBlackWhiteImageData:imageData type:0 blackWhiteImage:^(CGImageRef imageRef) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [self performSelectorOnMainThread:@selector(updateUIBut4:) withObject:image waitUntilDone:YES];
    }];
}

- (void)updateUIs:(NSMutableArray *)imageArr {
//    for (UIImage *image in imageArr) {
//        _imageView.image = image;
//    }
    //把存有UIImage的数组赋给动画图片数组
    _imageView.animationImages = imageArr;
    //设置执行一次完整动画的时长
    _imageView.animationDuration = 6*0.15;
    //动画重复次数 （0为重复播放）
    _imageView.animationRepeatCount = 1;
    //开始播放动画
    [_imageView startAnimating];
}

- (void)updateUIBut3:(UIImage *)image {
    _imageView.image = image;
}

- (void)updateUIBut4:(UIImage *)image {
    _imageView.image = image;
}

#define mark --视频转码
- (void)selectorButVideo {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageVideo) object:nil];
    [operationQueue addOperation:op];
    
}

- (void)downloadImageVideo {
    NSURL *imageURL = [NSURL URLWithString:@"http://10.10.61.218:8080/name/video.mp4"];
    [YYGIF createGIFfromURL:imageURL withFrameCount:144 delayTime:0.125 loopCount:0 needCompression:YES andCompressionWidth:180 andCompressionHight:180 andFileName:@"测试.gif" completion:^(NSString *GifPath) {
        NSLog(@"Finished generating GIF: %@", GifPath);
        
        if (GifPath)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                _HUD.label.text = @"Complete！";
//                [_HUD hideAnimated:1 afterDelay:1];
                NSData* gifData = [NSData dataWithContentsOfFile:GifPath];
                _imageView.image = [TYImageCodec sd_animatedGIFWithData:gifData];
            });
            
            
            
            
        }else
        {
            
        }
        
    }];
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
