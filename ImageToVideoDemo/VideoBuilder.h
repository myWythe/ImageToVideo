//
//  VideoBuilder.h
//  ConvertVideo
//
//  Created by myqiqiang on 15/11/17.
//  Copyright © 2015年 myqiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

typedef void(^successBlock)(void);
typedef void(^failBlock)(NSError *error);

@interface VideoBuilder : NSObject

- (VideoBuilder *)initWithOutputSize:(CGSize )size Timescale:(int32_t )scale OutputPath:(NSString *)path;
/**
 *  通过图片添加视频枕
 *
 *  @param image  图片
 */
- (BOOL)addVideoFrameWithImage:(UIImage *)image;

/**
 *  用图片数组一次性生成视频
 *
 *  @param images 图片数组
 */
- (void)convertVideoWithImageArray:(NSArray *)images;

//- (void)maskFinish;

- (void)maskFinishWithSuccess:(successBlock)success Fail:(failBlock)fail;

- (void)saveToPhotosGalleryWithVideoPath:(NSURL *)srcURL toastResultInView:(UIView *)view;

@end
