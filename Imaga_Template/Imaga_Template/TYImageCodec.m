//
//  TYImageCodec.m
//  Imaga_Template
//
//  Created by 汤义 on 2018/6/13.
//  Copyright © 2018年 yitang. All rights reserved.
//

#import "TYImageCodec.h"

@implementation TYImageCodec
+ (void)decodingWithImageData:(NSData *)data imageReturn:(imageRefBlock)imageReturn {
    //创建CGImageSource,待解码对象
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (!source) {
        return;
    }
    NSDictionary *imageProperties = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    NSUInteger fileSize = [imageProperties[(__bridge NSString *)kCGImagePropertyFileSize] unsignedIntegerValue]; // 没什么用的文件大小
    
    NSDictionary *exifProperties = imageProperties[(__bridge NSString *)kCGImagePropertyExifDictionary]; // EXIF信息
    NSString *exifCreateTime = exifProperties[(__bridge NSString *)kCGImagePropertyExifDateTimeOriginal]; // EXIF拍摄时间
    NSLog(@"获取图片大小和拍摄信息:大小:%lu 时间:%@",(unsigned long)fileSize,exifCreateTime);
    
    NSUInteger width = [imageProperties[(__bridge NSString *)kCGImagePropertyPixelWidth] unsignedIntegerValue]; //宽度，像素值
    NSUInteger height = [imageProperties[(__bridge NSString *)kCGImagePropertyPixelHeight] unsignedIntegerValue]; //高度，像素值
    BOOL hasAlpha = [imageProperties[(__bridge NSString *)kCGImagePropertyHasAlpha] boolValue]; //是否含有Alpha通道
    CGImagePropertyOrientation exifOrientation = [imageProperties[(__bridge NSString *)kCGImagePropertyOrientation] integerValue]; // 这里也能直接拿到EXIF方向信息，和前面的一样。如果是iOS 7，就用NSInteger取吧 :)
    NSLog(@"宽度:%lu,高度:%lu,是否含有Alpha通道:%d,EXIF方向信息:%u",(unsigned long)width,(unsigned long)height,hasAlpha,exifOrientation);
    //解码
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    if (imageReturn) {
        imageReturn(imageRef,width,height);
    }
    // 清理，都是C指针，避免内存泄漏
    CGImageRelease(imageRef);
    CFRelease(source);
}

+ (void)addWithMoreDynamicFigureData:(NSData *)data imageReturn:(imageRefNSMArrBlock)imageReturn{
    //创建CGImageSource,待解码对象
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (!source) {
        return;
    }
    NSUInteger frameCount = CGImageSourceGetCount(source); //帧数
    NSMutableArray <UIImage *> *images = [NSMutableArray array];
    double totalDuration = 0;
    for (size_t i = 0; i < frameCount; i++) {
        NSDictionary *frameProperties = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary]; // GIF属性字典
        double duration = [gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime] doubleValue]; // GIF原始的帧持续时长，秒数
        CGImagePropertyOrientation exifOrientation = [frameProperties[(__bridge NSString *)kCGImagePropertyOrientation] integerValue]; // 方向
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL); // CGImage
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        totalDuration += duration;
        [images addObject:image];
        CGImageRelease(imageRef);
        
    }
    
    if (imageReturn) {
        imageReturn(images);
    }
    
    CFRelease(source);
}

+ (void)addWithProgressiveDecodingData:(NSData *)data imageRefProgressive:(imageRefProgressiveBlock)imageRefProgressive {
    if (!data) {
        return;
    }
    //获取source
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    //解码
    // 更新数据
//    CGImageSourceUpdateData(source, (__bridge CFDataRef)data, NO);
    
    // 和普通解码过程一样
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    if (!imageRef) {
        return;
    }
    
//    CGDataProviderRef providerRef = CGImageGetDataProvider(imageRef);
//    
//    CFDataRef dataRef = CGDataProviderCopyData(providerRef);
//    
//    NSData *my_nsdata = (__bridge_transfer NSData*)dataRef;
    
    if (imageRefProgressive) {
        imageRefProgressive(imageRef);
    }
    
    CGImageRelease(imageRef);
    CFRelease(source);
}

+ (void)addWithBlackWhiteImageData:(NSData *)data type:(int)type blackWhiteImage:(imageRefBlackWhiteImageBlock)blackWhiteImage {
    if (!data) {
        return;
    }
    //获取source
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //解码
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    //复制代码
    //知识点CGImageRef
    /*
     sizt_t是定义的一个可移植性的单位，在64位机器中为8字节，32位位4字节。
     width：图片宽度像素
     height：图片高度像素
     bitsPerComponent：每个颜色的比特数，例如在rgba-32模式下为8
     bitsPerPixel：每个像素的总比特数
     bytesPerRow：每一行占用的字节数，注意这里的单位是字节
     space：颜色空间模式，例如const CFStringRef kCGColorSpaceGenericRGB 这个函数可以返回一个颜色空间对象。
     bitmapInfo：位图像素布局，这是个枚举
     provider：数据源提供者
     decode[]：解码渲染数组
     shouldInterpolate：是否抗锯齿
     intent：图片相关参数
     */
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(dataRef);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            //将其转换为RGB格式
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                case 4:
                    *(tmp + 0) = red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(dataRef));
    
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    if (!effectedCgImage) {
        return;
    }
    
    if (blackWhiteImage) {
        blackWhiteImage(effectedCgImage);
    }
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(dataRef);
}

+ (void)addWithConversionYUV:(NSData *)data type:(NSUInteger)type imageRefYUV:(imageRefYUVBlock)imageRefYUV{
    if (!data) {
        return;
    }
    //获取source
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //解码
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    //复制代码
    //知识点CGImageRef
    /*
     sizt_t是定义的一个可移植性的单位，在64位机器中为8字节，32位位4字节。
     width：图片宽度像素
     height：图片高度像素
     bitsPerComponent：每个颜色的比特数，例如在rgba-32模式下为8
     bitsPerPixel：每个像素的总比特数
     bytesPerRow：每一行占用的字节数，注意这里的单位是字节
     space：颜色空间模式，例如const CFStringRef kCGColorSpaceGenericRGB 这个函数可以返回一个颜色空间对象。
     bitmapInfo：位图像素布局，这是个枚举
     provider：数据源提供者
     decode[]：解码渲染数组
     shouldInterpolate：是否抗锯齿
     intent：图片相关参数
     */
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(dataRef);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            //将其转换为RGB格式
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
//            //y
//            *(tmp + 0) = 0.299*red + 0.587*green + 0.115*blue;
//            //u
//            *(tmp + 1) = -0.1687*red - 0.3313*green +0.5*blue + 128;
//            //v
//            *(tmp + 2) = 0.5*red - 0.4187*green - 0.0813*blue + 128;
            UInt8 brightness;
            double f_y, f_u, f_v;
            uint8_t y, u, v;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                case 4:
                    *(tmp + 0) = red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                case 5:
                    f_y = (float) ((66 * red + 129 * green + 25 * blue + 128) >> 8) + 16;
                    f_u = (float) ((-38 * red - 74 * green + 112 * blue + 128) >> 8) + 128;
                    f_v = (float) ((112 * red - 94 * green - 18 * blue + 128) >> 8) + 128;
                    
                    y = correct_color_value(f_y);
                    u = correct_color_value(f_u);
                    v = correct_color_value(f_v);
                    *(tmp + 0) = y;
                    *(tmp + 1) = u;
                    *(tmp + 2) = v;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(dataRef));
    
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    if (!effectedCgImage) {
        return;
    }
    
    if (imageRefYUV) {
        imageRefYUV(effectedCgImage);
    }
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(dataRef);
}

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            
            duration += [self sd_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

uint8_t correct_color_value(float color) {
    uint8_t intValue;
    if (color < 0) {
        intValue = 0;
    } else if (color > 255) {
        intValue = 255;
    } else {
        intValue = (uint8_t)color;
    }
    return intValue;
}

@end
