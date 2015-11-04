//
//  ViewController.m
//  图
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ViewController.h"
#import "FYTrendGraphView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:nil forKey:@"test"];
    NSLog(@"%@",dic);
    
    FYTrendGraphView* trendView = [[FYTrendGraphView alloc] initWithFrame:CGRectMake(0, 100.2, 320, 300)];
    trendView.backgroundColor = [UIColor whiteColor];
    trendView.pointColor = [UIColor colorWithRed:78/255.0 green:195/255.0 blue:0.f alpha:1];
    trendView.endY = 100;
    trendView.valueArray = @[@"0",@"10",@"0",@"34",@"52",@"8",@"40",@"80",@"100"];
    trendView.verticalLineWidth = 1.5;
    [self.view addSubview:trendView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
