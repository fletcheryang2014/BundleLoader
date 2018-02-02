//
//  ViewController.m
//  MyApp
//
//  Created by yangyi on 2018/1/30.
//  Copyright © 2018年 yangyi. All rights reserved.
//

#import "ViewController.h"
#import "MyFramework/MyFramework.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onLoadBtnClicked:(id)sender {
    UIViewController *vc = getMyViewController();
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
