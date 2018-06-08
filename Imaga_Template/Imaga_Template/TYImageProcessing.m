//
//  TYImageProcessing.m
//  Imaga_Template
//
//  Created by 汤义 on 2018/6/8.
//  Copyright © 2018年 yitang. All rights reserved.
//

#import "TYImageProcessing.h"
#import <Accelerate/Accelerate.h>
#import "extobjc.h"

@implementation TYImageProcessing
+ (CGImageRef)nonAlphaImageWithImage:(CGImageRef)aImage
{
    // 首先，我们声明input和output的buffer
    __block vImage_Buffer a_buffer = {}, output_buffer = {};
    @onExit {
        // 由于vImage的API需要手动管理内存，避免内存泄漏
        // 为了方便错误处理清理内存，可以使用clang attibute的cleanup（这里是libextobjc的宏）
        // 如果不这样，还有一种方式，就是使用goto，定义一个fail:的label，所有return NULL改成`goto fail`;
        if (a_buffer.data) free(a_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    
    // 首先，创建一个buffer，可以用vImage提供的CGImage的便携构造方法，里面需要传入原始数据所需要的format，这里就是ARGB8888
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    // 所有vImage的方法一般都有一个result，判断是否成功
    if (a_ret != kvImageNoError) return NULL;
    // 接着，我们需要对output buffer开辟内存，这里由于是RGB888，对应的rowBytes是3 * width，注意还需要64字节对齐，否则vImage处理会有额外的开销。
    output_buffer.width = a_buffer.width;
    output_buffer.height = a_buffer.height;
    output_buffer.rowBytes = vImageByteAlign(output_buffer.width * 3, 64);
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    // 这里使用vImage的convert方法，转换色彩格式
    vImage_Error ret = vImageConvert_ARGB8888toRGB888(&a_buffer, &output_buffer, kvImageNoFlags);
    if (ret != kvImageNoError) return NULL;
    // 此时已经output buffer已经转换完成，输出回CGImage
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatRGB888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}

// 为了方便，我们首先直接定义好ARGB8888的format结构体，后续需要多次使用
static vImage_CGImageFormat vImageFormatARGB8888 = (vImage_CGImageFormat) {
    .bitsPerComponent = 8, // 8位
    .bitsPerPixel = 32, // ARGB4通道，4*8
    .colorSpace = NULL, // 默认就是sRGB
    .bitmapInfo = kCGImageAlphaFirst | kCGBitmapByteOrderDefault, // 表示ARGB
    .version = 0, // 或许以后会有版本区分，现在都是0
    .decode = NULL, // 和`CGImageCreate`的decode参数一样，可以用来做色彩范围映射的，NULL就是[0, 1.0]
    .renderingIntent = kCGRenderingIntentDefault, // 和`CGImageCreate`的intent参数一样，当色彩空间超过后如何处理
};
// RGB888的format结构体
static vImage_CGImageFormat vImageFormatRGB888 = (vImage_CGImageFormat) {
    .bitsPerComponent = 8, // 8位
    .bitsPerPixel = 24, // RGB3通道，3*8
    .colorSpace = NULL,
    .bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault, // 表示RGB
    .version = 0,
    .decode = NULL,
    .renderingIntent = kCGRenderingIntentDefault,
};
// 字节对齐使用，vImage如果不是64字节对齐的，会有额外开销
static inline size_t vImageByteAlign(size_t size, size_t alignment) {
    return ((size + (alignment - 1)) / alignment) * alignment;
}
@end
