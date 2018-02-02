//
//  BundleLoader.h
//  MyFramework
//
//  Created by yangyi on 2018/2/1.
//  Copyright © 2018年 yangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BundleLoader : NSObject

/**
 加载bundle资源前调用该方法初始化

 @param bundleName bundle名，后缀不要写
 */
+ (void)initFrameworkBundle:(NSString*)bundleName;

/**
 不再需要加载bundle资源时调用该方法反初始化
 */
+ (void)uninitFrameworkBundle;

@end
