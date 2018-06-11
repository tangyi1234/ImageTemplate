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
@end
