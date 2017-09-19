//
//  MyPromotionViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "MyPromotionViewController.h"
#import <CoreImage/CoreImage.h>

@interface MyPromotionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *erweimaImage;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong,nonatomic)NSString *er;
@end

@implementation MyPromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)request{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"] forKey:@"memberId"];
    //    NSString *ID = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"];
    //    NSDictionary *para = @{@"memberId":ID};
    [RequestAPI requestURL:@"/mySelfController/getInvitationCode" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            //    NSDictionary *result = responseObject[@"result"];
            //   _QR = result[@"result"];
            _er =  responseObject[@"result"];
            
            [self bu];
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情
        NSLog(@"statusCode = %ld",(long)statusCode);
        
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//}
-(void)bu{
    //创建一个二维码滤镜实例（CIFilter）
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //滤镜恢复默认设置
    [filter setDefaults];
    //给滤镜添加数据
    NSString *string = [NSString stringWithFormat:@"http://dwz.cn/%@",_er];
    //将字符串转成二进制数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //通过KVC设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    //4.获取生成的图片
    CIImage *ciImg = filter.outputImage;
    // 7.将CIImage转成UIImage
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:ciImg withSize:200];
    //显示二维码
    UIImage *customQrcode = [self imageBlackToTransparent:image withRed:255.f andGreen:255.f andBlue:255.f];
    _erweimaImage.layer.shadowOffset = CGSizeMake(0, 0.5);  // 设置阴影的偏移量
    _erweimaImage.layer.shadowRadius = 1;  // 设置阴影的半径
    _erweimaImage.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
    _erweimaImage.layer.shadowOpacity = 1; // 设置阴影的不透明度
    _erweimaImage.image = customQrcode;
    //_imageView.image = image;
}






- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    //CGFloat scale = MIN(10, 20);
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}





#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
//遍历图片像素
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
