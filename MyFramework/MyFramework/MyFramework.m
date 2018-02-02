//
//  MyFramework.m
//  MyFramework
//
//  Created by yangyi on 2018/1/30.
//  Copyright © 2018年 yangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyFramework.h"
#import "NextViewController.h"
#import "BundleLoader.h"

UIViewController* getMyViewController(void)
{
    [BundleLoader initFrameworkBundle:@"MyFrameworkBundle"];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MyFramework" bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    return vc;
}
