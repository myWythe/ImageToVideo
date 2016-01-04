//
//  ViewController.m
//  ImageToVideoDemo
//
//  Created by myqiqiang on 16/1/4.
//  Copyright © 2016年 myqiqiang. All rights reserved.
//

#import "ViewController.h"
#import "VideoBuilder.h"


@interface ViewController ()
@property NSTimer *timer;
@property VideoBuilder *videoBuilder;
@property NSString *videoPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fileNameOut2 = @"output.mp4";
    _videoPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), fileNameOut2];
    
    [[NSFileManager defaultManager] removeItemAtPath:_videoPath  error:NULL];
    
    _videoBuilder = [[VideoBuilder alloc]initWithOutputSize:CGSizeMake(640, 360) Timescale:8 OutputPath:_videoPath];
    
    // 一张张的添加，一次性传一个数组，请看API说明
    _timer  = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addImage) userInfo:nil repeats:YES];
}

static int count = 2601;
- (void)addImage {
    
    // 图片已移除，请用自己的图片
    
    if (count < 2900) {
        
        NSString *name = [NSString stringWithFormat:@"IMG_%d",count];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"JPG"]];
        if(image) {
            UIImage *clipImage = [self clipImageWithScaleWithsize:CGSizeMake(640, 360) input:image];
            NSData *clipCompressData = UIImageJPEGRepresentation(clipImage, 0.0f);
            UIImage *clipCompressImage = [UIImage imageWithData:clipCompressData];
            
            if ([_videoBuilder addVideoFrameWithImage:clipCompressImage]) {
                count ++;
            }
        }
        
    } else {
        [_timer invalidate];
        [_videoBuilder maskFinishWithSuccess:^{
            
            [_videoBuilder saveToPhotosGalleryWithVideoPath:[NSURL URLWithString:_videoPath] toastResultInView:self.view];
        } Fail:^(NSError *error) {
            [self.view makeToast:error.localizedDescription];
        }];
        
        
    }
    
}

- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize input:(UIImage *)input
{
    UIImage *newimage;
    UIImage *image = input;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        else{
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToRect(context, CGRectMake(0, 0, asize.width, asize.height));
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    return newimage;
}

@end

