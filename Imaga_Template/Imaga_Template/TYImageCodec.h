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
@interface TYImageCodec : NSObject
//解码
+ (void)decodingWithImageData:(NSData *)data imageReturn:(imageRefBlock)imageReturn;
+ (void)addWithMoreDynamicFigureData:(NSData *)data imageReturn:(imageRefNSMArrBlock)imageReturn;
+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;
@end
