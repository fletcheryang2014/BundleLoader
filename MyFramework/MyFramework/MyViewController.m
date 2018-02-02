//
//  MyViewController.m
//  MyFramework
//
//  Created by yangyi on 2018/1/30.
//  Copyright © 2018年 yangyi. All rights reserved.
//

#import "MyViewController.h"
#import "NextViewController.h"
#import "MyView.h"
#import "BundleLoader.h"

@interface MyViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *label;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载bundle里的普通文件资源
    NSString *path = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data != nil && data.length > 0)
        self.label.text = @"user.json文件加载成功";
    else
        self.label.text = @"user.json文件加载失败";
    
    //加载bundle里的视图xib
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil];
    if (array.count > 0) {
        MyView *view = array[0];
//        //加载bundle里assets的图片
//        view.iconView.image = [UIImage imageNamed:@"crown"];
        
        view.frame = CGRectMake(70, 140, 240, 50);
        [self.view addSubview:view];
    }
    
}

- (IBAction)onNextBtnClicked:(id)sender {
    //加载视图控制器的xib
    NextViewController *vc = [[NextViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [BundleLoader uninitFrameworkBundle];
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
