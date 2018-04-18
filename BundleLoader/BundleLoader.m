//
//  BundleLoader.m
//  MyFramework
//
//  Created by yangyi on 2018/2/1.
//  Copyright © 2018年 yangyi. All rights reserved.
//

#import "BundleLoader.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static int refCount = 0;
static void *NSBundleMainBundleKey = &NSBundleMainBundleKey;

@interface UIImage (FrameworkBundle)

@end

@implementation UIImage (FrameworkBundle)

#pragma mark - Method swizzling

+ (void)load {
    Method originalMethod = class_getClassMethod([self class], @selector(imageNamed:));
    Method customMethod = class_getClassMethod([self class], @selector(imageNamedCustom:));
    
    //Swizzle methods
    method_exchangeImplementations(originalMethod, customMethod);
}

+ (nullable UIImage *)imageNamedCustom:(NSString *)name {
    //Call original methods
    UIImage *image = [UIImage imageNamedCustom:name];
    if (image != nil)
        return image;
    
    NSBundle* bundle = objc_getAssociatedObject([NSBundle mainBundle], NSBundleMainBundleKey);
    if (bundle)
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];//加载bundle里xcassets的图片只能用这个方法
    else
        return nil;
}

@end

//////////////////////////////////////////////////////////////

@interface UIStoryboard (FrameworkBundle)

@end

@implementation UIStoryboard (FrameworkBundle)

+ (void)load {
    Method originalMethod = class_getClassMethod([self class], @selector(storyboardWithName:bundle:));
    Method customMethod = class_getClassMethod([self class], @selector(storyboardWithNameCustom:bundle:));
    
    //Swizzle methods
    method_exchangeImplementations(originalMethod, customMethod);
}

+ (UIStoryboard *)storyboardWithNameCustom:(NSString *)name bundle:(nullable NSBundle *)storyboardBundleOrNil {
    if (storyboardBundleOrNil == nil || storyboardBundleOrNil == [NSBundle mainBundle]) {
        NSBundle* bundle = objc_getAssociatedObject([NSBundle mainBundle], NSBundleMainBundleKey);
        if (bundle) {
            NSString *path = [bundle pathForResource:name ofType:@"storyboardc"];
            if (path)
                return [UIStoryboard storyboardWithNameCustom:name bundle:bundle];
        }
    }
    
    //Call original methods
    return [UIStoryboard storyboardWithNameCustom:name bundle:storyboardBundleOrNil];
}

@end

//////////////////////////////////////////////////////////////

@interface UIViewController (FrameworkBundle)

@end

@implementation UIViewController (FrameworkBundle)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(initWithNibName:bundle:));
    Method customMethod = class_getInstanceMethod(self, @selector(initWithNibNameCustom:bundle:));
    
    //Swizzle methods
    method_exchangeImplementations(originalMethod, customMethod);
}

- (instancetype)initWithNibNameCustom:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    if (nibBundleOrNil == nil || nibBundleOrNil == [NSBundle mainBundle]) {
        NSBundle* bundle = objc_getAssociatedObject([NSBundle mainBundle], NSBundleMainBundleKey);
        if (bundle) {
            NSString *name = nibNameOrNil;
            if (name == nil)
                name = NSStringFromClass([self class]);
            NSString *path = [bundle pathForResource:name ofType:@"nib"];
            if (path)
                return [self initWithNibNameCustom:name bundle:bundle];
        }
    }
    return [self initWithNibNameCustom:nibNameOrNil bundle:nibBundleOrNil];
}

@end

//////////////////////////////////////////////////////////////

@interface FrameworkBundle : NSBundle

@end

@implementation FrameworkBundle

//系统底层加载图片，xib都会进这个方法
- (nullable NSString *)pathForResource:(nullable NSString *)name ofType:(nullable NSString *)ext {
    NSBundle* bundle = objc_getAssociatedObject(self, NSBundleMainBundleKey);
    if (bundle) {
        NSString *path = [bundle pathForResource:name ofType:ext];
        if (path)
            return path;
    }
    return [super pathForResource:name ofType:ext];
}

- (nullable NSURL *)URLForResource:(nullable NSString *)name withExtension:(nullable NSString *)ext {
    NSBundle* bundle = objc_getAssociatedObject(self, NSBundleMainBundleKey);
    if (bundle) {
        NSURL *url = [bundle URLForResource:name withExtension:ext];
        if (url)
            return url;
    }
    return [super URLForResource:name withExtension:ext];
}

- (nullable NSArray *)loadNibNamed:(NSString *)name owner:(nullable id)owner options:(nullable NSDictionary *)options
{
    NSBundle* bundle = objc_getAssociatedObject(self, NSBundleMainBundleKey);
    if (bundle) {
        NSString *path = [bundle pathForResource:name ofType:@"nib"];
        if (path)
            return [bundle loadNibNamed:name owner:owner options:options];
    }
    return [super loadNibNamed:name owner:owner options:options];
}

@end

//////////////////////////////////////////////////////////////

@implementation BundleLoader

+ (void)initFrameworkBundle:(NSString*)bundleName {
    refCount++;
    NSBundle* bundle = objc_getAssociatedObject(self, NSBundleMainBundleKey);
    if (bundle == nil) {
        //获取自定义资源Bundle的对象
        NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
        NSBundle *resBundle = [NSBundle bundleWithPath:path];
        
        //把这个对象关联到mainBundle对象上
        objc_setAssociatedObject([NSBundle mainBundle], NSBundleMainBundleKey, resBundle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        //把mainBundle对象的Class设为自定义Bundle子类的Class
        object_setClass([NSBundle mainBundle], [FrameworkBundle class]);
    }
}

+ (void)uninitFrameworkBundle {
    if (refCount > 0) {
        refCount--;
        if (refCount == 0)
            objc_removeAssociatedObjects([NSBundle mainBundle]);
    }
}

@end
