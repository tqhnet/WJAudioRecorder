//
//  ViewController.m
//  WJAudioRecorder
//
//  Created by tqh on 2018/5/7.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "ViewController.h"
#import "WJAudioRecorder.h"

@interface ViewController ()

@property (nonatomic,strong) WJAudioRecorder *recorder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recorder = [WJAudioRecorder new];
    [self.recorder startRecorder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.recorder stopRecorder];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
