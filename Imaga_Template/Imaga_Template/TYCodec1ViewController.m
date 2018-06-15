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
@interface TYCodec1ViewController ()<UIScrollViewDelegate, UITextFieldDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UITextField *textField;
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
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(w - 200, 0, 180, 40)];
    textField.delegate = self;
    textField.text = @"1";
    [_scrollView addSubview:_textField = textField];
}

- (void)selectorBut1 {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageBut1) object:nil];
    [operationQueue addOperation:op];
}

- (void)downloadImageBut1 {
    NSURL *imageURL = [NSURL URLWithString:@"http://10.10.61.218:8080/name/8.png"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [TYImageCodec addWithConversionYUV:imageData type:[_textField.text integerValue] imageRefYUV:^(CGImageRef imageRef) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [self performSelectorOnMainThread:@selector(updateUIBut1:) withObject:image waitUntilDone:YES];
    }];
}

- (void)updateUIBut1:(UIImage *)image {
    _imageView.image = image;
    [self calulateImageFileSize:image];
}

- (void)calulateImageFileSize:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 1.0);//需要改成0.5才接近原图片大小，原因请看下文
    }
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"image = %.3f %@",dataLength,typeArray[index]);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_textField resignFirstResponder]; // 空白处收起
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [_textField resignFirstResponder];
    return YES;
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
