//
//  TYPublicMethods.m
//  Imaga_Template
//
//  Created by 汤义 on 2018/6/8.
//  Copyright © 2018年 yitang. All rights reserved.
//

#import "TYPublicMethods.h"

@implementation TYPublicMethods
+ (UIImage *)addWithFilePathStr:(NSString *)str {
    NSString *filePath=[[NSBundle mainBundle] pathForResource:str ofType:@"png"];
    return [UIImage imageNamed:filePath];
}
@end
