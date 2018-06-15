//
//  TYImageCodec.h
//  Imaga_Template
//
//  Created by 汤义 on 2018/6/13.
//  Copyright © 2018年 yitang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#if SD_MAC
#import <CoreServices/CoreServices.h>
#else
#import <MobileCoreServices/MobileCoreServices.h>
#endif
typedef void (^imageRefBlock) (CGImageRef imageRef,NSUInteger ws,NSUInteger hs);
typedef void (^imageRefNSMArrBlock) (NSMutableArray *muArr);
typedef void (^imageRefProgressiveBlock) (CGImageRef imageRef);
typedef void (^imageRefBlackWhiteImageBlock) (CGImageRef imageRef);
typedef void (^imageRefYUVBlock) (CGImageRef imageRef);
@interface TYImageCodec : NSObject
//解码
+ (void)decodingWithImageData:(NSData *)data imageReturn:(imageRefBlock)imageReturn;
+ (void)addWithMoreDynamicFigureData:(NSData *)data imageReturn:(imageRefNSMArrBlock)imageReturn;
//渐进
+ (void)addWithProgressiveDecodingData:(NSData *)data imageRefProgressive:(imageRefProgressiveBlock)imageRefProgressive;
//转换为黑白色
+ (void)addWithBlackWhiteImageData:(NSData *)data type:(int)type blackWhiteImage:(imageRefBlackWhiteImageBlock)blackWhiteImage;
//转yuv
+ (void)addWithConversionYUV:(NSData *)data imageRefYUV:(imageRefYUVBlock)imageRefYUV;
+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;
@end
