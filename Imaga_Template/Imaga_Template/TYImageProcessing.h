//
//  TYImageProcessing.h
//  Imaga_Template
//
//  Created by 汤义 on 2018/6/8.
//  Copyright © 2018年 yitang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TYImageProcessing : NSObject
+ (CGImageRef)nonAlphaImageWithImage:(CGImageRef)aImage;
+ (CGImageRef)nonAlphaImageWithImage1:(CGImageRef)aImage;
//对图片进行添加颜色
+ (CGImageRef)fillWithColorImage:(CGImageRef)aImage colorsRef:(CGColorRef)colorsRef;
//两张图片进行合成
+ (CGImageRef)imageWithSynthesis:(CGImageRef)imageRrf bImage:(CGImageRef)bImage point:(CGPoint)point;
//对图片进行缩放
+ (CGImageRef)zoomWithimage:(CGImageRef)imageRef size:(CGSize)size;
//对图片进行剪切
+ (CGImageRef)shearWithimage:(CGImageRef)imagRef rect:(CGRect)rect;
//对图进行旋转
+ (CGImageRef)mirrorWithImage:(CGImageRef)imageRef state:(BOOL)state;
//旋转图片
+ (CGImageRef)rotatingWithImage:(CGImageRef)imageRef radians:(CGFloat)radians;
//错切图片
+ (CGImageRef)shear1WithImage:(CGImageRef)imageRef offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale horizontal:(BOOL)horizontal;
@end
