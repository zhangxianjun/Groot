//
//  ExperimentViewController.m
//  Groot
//
//  Created by ZXJ on 2017/5/21.
//  Copyright © 2017年 maodenden. All rights reserved.
//

#import "ExperimentViewController.h"

@interface ExperimentViewController ()

@end

@implementation ExperimentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self experimentLiteral];
}

- (void)experimentLiteral {
    NSString *string1 = @"你好";
    NSString *string2;                                  // 为nil
    NSString *string3 = @"Hello";
    NSLog(@"======%@=%@=%@", string1, string2, string3);
    
    NSArray *array1 = [NSArray arrayWithObjects:string1, string2, string3, nil];
    NSLog(@"======%lu", (unsigned long)array1.count);
    
    // array2 会报错
//    NSArray *array2 = @[string1, string2, string3];
//    NSLog(@"======%lu", (unsigned long)array2.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
