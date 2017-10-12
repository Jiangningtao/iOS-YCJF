//
//  SunQRCode.m
//  OC_生成与读取二维码
//
//  Created by garday on 16/7/4.
//  Copyright © 2016年 garday. All rights reserved.
//

#import "SunQRCode.h"

@implementation SunQRCode

+(UIImage *)GenerateQRCode:(NSString *)string{
    //1.设置滤镜
    CIFilter *fiter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //2.默认设置
    [fiter setDefaults];
    
    //3.设置数据源
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [fiter setValue:data forKey:@"inputMessage"];
    
    //4.输出结果
    CIImage *iimage = [fiter outputImage];
    
    //5.显示二维码
    return [self createNonInterpolatedUIImageFormCIImage:iimage withSize:300];

}

+(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //1.创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
@end
