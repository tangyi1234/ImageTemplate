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
//        UIImageOrientation imageOrientation = [self imageOrientationFromExifOrientation:exifOrientation];
//        UIImage *image = [[UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:imageOrientation];
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
@end
