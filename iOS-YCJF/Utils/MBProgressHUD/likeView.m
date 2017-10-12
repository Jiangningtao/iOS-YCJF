//
//  likeView.m
//  cell加controller测试
//
//  Created by garday on 2017/3/15.
//  Copyright © 2017年 garday. All rights reserved.
//


#define AppRootView  ([[[[[UIApplication sharedApplication] delegate] window] rootViewController] view])

#define AppRootViewController  ([[[[UIApplication sharedApplication] delegate] window] rootViewController])

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#define takePhotoShare [likeView sharedModel]


#import "likeView.h"

@interface likeView()<UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate>

/***<#注释#> ***/
@property (nonatomic ,strong)NSDictionary *params;
@end
@implementation likeView
+ (likeView *)sharedModel{
    static likeView *sharedModel = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

+(void)sharePicture:(sendPictureBlock)block{
    
    takePhotoShare.sPictureBlock = block;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    UIButton *xjbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height-95, self.frame.size.width/2, 95)];
    [xjbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    xjbtn.backgroundColor =[UIColor whiteColor];
    [xjbtn addTarget:self action:@selector(likebtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *xjimageV = [[UIImageView alloc]initWithFrame:CGRectMake(xjbtn.center.x-23, 25, 46, 34)];
    xjimageV.image = [UIImage imageNamed:@"icon_xiangji"];
    [xjbtn addSubview:xjimageV];
    
    UILabel *xjlab = [[UILabel alloc]initWithFrame:CGRectMake(xjbtn.center.x-30, xjimageV.frame.size.height+25+10, 60 , 20)];
    xjlab.text = @"打开相机";
    xjlab.textColor = [UIColor blackColor];
    xjlab.font = [UIFont systemFontOfSize:14.0];
    
    
    [xjbtn addSubview:xjlab];
    [self addSubview:xjbtn];
    
    
    
    UIButton *zpbtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(xjbtn.frame)+1, self.frame.size.height-95, (self.frame.size.width/2)-1, 95)];
     [zpbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    zpbtn.backgroundColor =[UIColor whiteColor];
    [zpbtn addTarget:self action:@selector(photobtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *zpimageV = [[UIImageView alloc]initWithFrame:CGRectMake((zpbtn.frame.size.width/2)-20, 20, 40, 40)];
   zpimageV.image = [UIImage imageNamed:@"icon_xiangji"];
//    zpimageV.backgroundColor = [UIColor yellowColor];
    [zpbtn addSubview:zpimageV];
    UILabel *zplab = [[UILabel alloc]initWithFrame:CGRectMake((zpbtn.frame.size.width/2)-28, CGRectGetMaxY(zpimageV.frame)+9, 60 , 20)];
    zplab.text = @"本地照片";
    zplab.textColor = [UIColor blackColor];
    zplab.font = [UIFont systemFontOfSize:14.0];
    
    [zpbtn addSubview:zplab];
    [self addSubview:zpbtn];
    
}


- (void)takePicture:(NSUInteger)UIImagePickerControllerSourceType{
    
    // 跳转到相机或相册页面
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType;
        
    }
    else
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    }
    
    [AppRootViewController presentViewController:imagePickerController animated:YES completion:NULL];
    
}

#pragma mark - image picker delegte


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   
    
    [picker dismissViewControllerAnimated:YES completion:^{
    
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
   
    [self upDateHeadIcon:image];
    
    
    [takePhotoShare sPictureBlock](image);
    
}
//从document取得图片
- (UIImage *)getImage:(NSString *)urlStr
{
    return [UIImage imageWithContentsOfFile:urlStr];
    
}
- (void)upDateHeadIcon:(UIImage *)photo
{
    NSMutableDictionary *pramas = [NSMutableDictionary dictionary];
    
    /*方式一：使用NSData数据流传图片*/
    pramas[@"uid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    pramas[@"sid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    pramas[@"accinfo"] = @"1";
    pramas[@"at"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"at"];
    pramas[@"touxiang"] = photo;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    manager.responseSerializer.acceptableContentTypes =[NSSet
                                                        setWithObject:@"text/html"];
    
    [manager POST:sctxurl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(photo,1.0)
          name:@"text" fileName:@"test.jpg" mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"%.2lf%%", progress);
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--2---%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--3---%@",error);
    }];
    
}
//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,
                                        YES);
    
    //写入文件
    
    NSString *imagename = imageName;
    
    NSString *filePath = [[paths
                           objectAtIndex:0]
                          stringByAppendingPathComponent:[NSString
                                                          stringWithFormat:@"%@.png", imagename]];
    
    // 保存文件的名称
    
    // [[self getDataByImage:image] writeToFile:filePath atomically:YES];
    
    [UIImagePNGRepresentation(tempImage)writeToFile:filePath atomically:YES];
    
}


//缩放图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image
     drawInRect:CGRectMake(0,0, image.size.width * scaleSize, image.size.height *scaleSize)];
    
    UIImage *scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSLog(@"%@",NSStringFromCGSize(scaledImage.size));
    
    return scaledImage;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
-(void)likebtnClicked{
     [self removeFromSuperview];
    [takePhotoShare takePicture:UIImagePickerControllerSourceTypeCamera];

   }
-(void)photobtnClicked{
    [self removeFromSuperview];
     [takePhotoShare takePicture:UIImagePickerControllerSourceTypePhotoLibrary];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
