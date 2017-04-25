//
//  WaveViewController.m
//  WWDraw
//
//  Created by 王伟 on 2017/4/25.
//  Copyright © 2017年 王伟. All rights reserved.
//

#import "WaveViewController.h"
#import "WWWaveView.h"

@interface WaveViewController ()

@property(nonatomic, weak)WWWaveView *waveView;

@end

@implementation WaveViewController


- (WWWaveView *)waveView {
    if (!_waveView) {
        WWWaveView *waveView = [[WWWaveView alloc] init];
        _waveView = waveView;
        [self.view addSubview:waveView];
    }
    return _waveView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"波浪效果图";
    
    [self.view addSubview:self.waveView];
    self.waveView.frame= CGRectMake(0, 0, self.view.frame.size.width, 100);
    self.waveView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
    self.waveView.center = self.view.center;
    
    // 设置参数
    self.waveView.firstLayerColor = [UIColor orangeColor];
    self.waveView.secondLayerColor = [UIColor orangeColor];
    self.waveView.waveHeight = 40;
    self.waveView.waveCurvature = 1.5;
    self.waveView.waveSpeed = 0.5;
    
    // 开始动画
    [self.waveView startAnimation];
    
    
    
}

static BOOL _mybool = NO;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    _mybool = !_mybool;
    if (_mybool) {
        // 结束动画
        [self.waveView stopAnimation];
    } else {
        [self.waveView startAnimation];
    }
    
    
    
}

@end
