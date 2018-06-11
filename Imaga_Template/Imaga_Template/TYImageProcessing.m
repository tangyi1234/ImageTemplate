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
    
    // 首先，创建一个buffer，可以用vImage提供的CGImage的便携构造方法，里面需要传入原始数据所需要的format，这里就是ARGB8888。拿到a_buffer是为了做一个参考模板，通过这个模板进行装换。
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    // 所有vImage的方法一般都有一个result，判断是否成功
    if (a_ret != kvImageNoError) return NULL;
    // 接着，我们需要对output buffer开辟内存，这里由于是RGB888，对应的rowBytes是3 * width，注意还需要64字节对齐，否则vImage处理会有额外的开销。
    output_buffer.width = a_buffer.width;
    output_buffer.height = a_buffer.height;
    output_buffer.rowBytes = vImageByteAlign(output_buffer.width * 3, 64);
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    // 这里使用vImage的convert方法，转换色彩格式 .这个方法只是针对与RGB888颜色的转换。
    vImage_Error ret = vImageConvert_ARGB8888toRGB888(&a_buffer, &output_buffer, kvImageNoFlags);
    if (ret != kvImageNoError) return NULL;
    // 此时已经output buffer已经转换完成，输出回CGImage
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatRGB888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}

+ (CGImageRef)nonAlphaImageWithImage1:(CGImageRef)aImage {
    // 首先，我们声明input和output的buffer
    __block vImage_Buffer a_buffer = {}, output_buffer = {};
    @onExit {
        // 由于vImage的API需要手动管理内存，避免内存泄漏
        // 为了方便错误处理清理内存，可以使用clang attibute的cleanup（这里是libextobjc的宏）
        // 如果不这样，还有一种方式，就是使用goto，定义一个fail:的label，所有return NULL改成`goto fail`;
        if (a_buffer.data) free(a_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    
//    // 首先，创建一个buffer，可以用vImage提供的CGImage的便携构造方法，里面需要传入原始数据所需要的format，这里就是ARGB8888。拿到a_buffer是为了做一个参考模板，通过这个模板进行装换。
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
//    // 所有vImage的方法一般都有一个result，判断是否成功
    if (a_ret != kvImageNoError) return NULL;
//    // 接着，我们需要对output buffer开辟内存，这里由于是RGB888，对应的rowBytes是3 * width，注意还需要64字节对齐，否则vImage处理会有额外的开销。
    output_buffer.width = a_buffer.width;
    output_buffer.height = a_buffer.height;
    output_buffer.rowBytes = vImageByteAlign(output_buffer.width * 2, 44);
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    
//    // 这里使用vImage的convert方法，转换色彩格式
//    vImage_Error ret = vImageConvert_ARGB8888toRGB888(&a_buffer, &output_buffer, kvImageNoFlags);
//    if (ret != kvImageNoError) return NULL;
    
    /*
     vImageConvert_ARGB8888toRGB888只是针对与RGB888颜色的装换，下面使用的方法就是全能性，所有的颜色都能进行转换。
     */
    vImage_Error ret;
    vImageConverterRef converter = vImageConverter_CreateWithCGImageFormat(&vImageFormatARGB8888, &vImageFormatRGB565, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    ret = vImageConvert_AnyToAny(converter, &a_buffer, &output_buffer, NULL, kvImageNoFlags);
    // 此时已经output buffer已经转换完成，输出回CGImage
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatRGB565, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}
//对图片进行添加颜色
+ (CGImageRef)fillWithColorImage:(CGImageRef)aImage colorsRef:(CGColorRef)colorsRef {
//    CGImageRef aImage; // 输入的bottom Image
//    CGColorRef color; // 输入的color
    __block vImage_Buffer a_buffer = {}, b_buffer = {}, output_buffer = {}; // 分别是bottom buffer，top buffer和最后的output buffer
    @onExit {
        // 由于vImage的API需要手动管理内存，避免内存泄漏
        // 为了方便错误处理清理内存，可以使用clang attibute的cleanup（这里是libextobjc的宏）
        // 如果不这样，还有一种方式，就是使用goto，定义一个fail:的label，所有return NULL改成`goto fail`;
        if (a_buffer.data) free(a_buffer.data);
        if (b_buffer.data) free(b_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    //通过创建buffer来获取原始format数据
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    
    b_buffer.width = a_buffer.width;
    b_buffer.height = a_buffer.height;
    b_buffer.rowBytes = a_buffer.rowBytes;
    b_buffer.data = malloc(b_buffer.rowBytes * b_buffer.height);
    output_buffer.width = a_buffer.width;
    output_buffer.height = a_buffer.height;
    output_buffer.rowBytes = a_buffer.rowBytes;
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    if (!b_buffer.data || !output_buffer.data) return NULL;
    
    Pixel_8888 pixel_color = {0};
    const double *components = CGColorGetComponents(colorsRef);
    const size_t components_size = CGColorGetNumberOfComponents(colorsRef);
    // 对CGColor进行转换到Pixel_8888
    if (components_size == 2) {
        // white, alpha
        pixel_color[0] = components[1] * 255;
    } else {
        // red, green, blue, (alpha)
        pixel_color[0] = components_size == 3 ? 255 : components[3] * 255;
        pixel_color[1] = components[0] * 255;
        pixel_color[2] = components[1] * 255;
        pixel_color[3] = components[2] * 255;
    }
    // 填充color到top buffer
    vImage_Error b_ret = vImageBufferFill_ARGB8888(&b_buffer, pixel_color , kvImageNoFlags);
    if (b_ret != kvImageNoError) return NULL;
    // Alpha Blend
    vImage_Error ret = vImageAlphaBlend_ARGB8888(&b_buffer, &a_buffer, &output_buffer, kvImageNoFlags);
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatRGB888, NULL, NULL, kvImageNoFlags, &ret);
    if (ret != kvImageNoError) return NULL;
    
    return outputImage;
}
//两张图片进行合成
+ (CGImageRef)imageWithSynthesis:(CGImageRef)aImage bImage:(CGImageRef)bImage point:(CGPoint)point
{
    /*
     这里的坐标原点是左下角
     */
//    CGImageRef aImage, bImage; // 输入的bottom Image和top Image
    __block vImage_Buffer a_buffer = {}, b_buffer = {}, c_buffer = {}, output_buffer = {};
    @onExit {
        // 由于vImage的API需要手动管理内存，避免内存泄漏
        // 为了方便错误处理清理内存，可以使用clang attibute的cleanup（这里是libextobjc的宏）
        // 如果不这样，还有一种方式，就是使用goto，定义一个fail:的label，所有return NULL改成`goto fail`;
        if (a_buffer.data) free(a_buffer.data);
        if (b_buffer.data) free(b_buffer.data);
        if (c_buffer.data) free(c_buffer.data);
        if (output_buffer.data) free(output_buffer.data);
    };
    //通过创建buffer来获取原始format数据
    vImage_Error a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, aImage, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    
    vImage_Error b_ret = vImageBuffer_InitWithCGImage(&b_buffer, &vImageFormatARGB8888, NULL, bImage, kvImageNoFlags);
    if (b_ret != kvImageNoError) return NULL;
    
    c_buffer.width = a_buffer.width;
    c_buffer.height = a_buffer.height;
    c_buffer.rowBytes = a_buffer.rowBytes;
    c_buffer.data = malloc(c_buffer.rowBytes * c_buffer.height);
    output_buffer.width = a_buffer.width;
    output_buffer.height = a_buffer.height;
    output_buffer.rowBytes = a_buffer.rowBytes;
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    //c buffer指的是将top Image进行处理后的临时buffer，使得宽高同bottom image相同
    // 这里我们使用到了线性变换的平移变换，以(0,0)放置top image，然后偏移point个像素点，其余部分填充clear color，即可得到这个处理后的c buffer
    CGAffineTransform transform = CGAffineTransformMakeTranslation(point.x, point.y);
    vImage_CGAffineTransform cg_transform = *((vImage_CGAffineTransform *)&transform);
    Pixel_8888 clear_color = {0};
    vImage_Error c_ret = vImageAffineWarpCG_ARGB8888(&b_buffer, &c_buffer, NULL, &cg_transform, clear_color, kvImageBackgroundColorFill);
    if (c_ret != kvImageNoError) return NULL;
    // 略过output buffer初始化
    // 将bottom image和处理后的c buffer进行Alpha Blend
    vImage_Error ret = vImageAlphaBlend_ARGB8888(&c_buffer, &a_buffer, &output_buffer, kvImageNoFlags);

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

// RGB565的format结构体
static vImage_CGImageFormat vImageFormatRGB565 = (vImage_CGImageFormat) {
    .bitsPerComponent = 8, // 8位
    .bitsPerPixel = 16, // RGB3通道，3*8
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
