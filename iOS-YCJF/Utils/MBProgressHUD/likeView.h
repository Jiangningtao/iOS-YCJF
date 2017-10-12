//
//  likeView.h
//  cell加controller测试
//
//  Created by garday on 2017/3/15.
//  Copyright © 2017年 garday. All rights reserved.
//

#import <UIKit/UIKit.h>





//使用block 返回值
typedef void (^sendPictureBlock)(UIImage *image);

@interface likeView : UIView<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic,copy)sendPictureBlock sPictureBlock;


+ (likeView *)sharedModel;

+(void)sharePicture:(sendPictureBlock)block;


@end
