//
//  WWWaveView.h
//  WWDraw
//
//  Created by 王伟 on 2017/4/25.
//  Copyright © 2017年 王伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WaveViewBlock)(CGFloat currentY);

@interface WWWaveView : UIView

/**
 *  浪弯曲度率
 */
@property (nonatomic, assign) CGFloat waveCurvature;
/**
 *  波浪速度
 */
@property (nonatomic, assign) CGFloat waveSpeed;
/**
 *  波浪高度
 */
@property (nonatomic, assign) CGFloat waveHeight;
/**
 *  Layer颜色1
 */
@property (nonatomic, strong) UIColor *firstLayerColor;
/**
 *  Layer颜色2
 */
@property (nonatomic, strong) UIColor *secondLayerColor;


@property (nonatomic, copy) WaveViewBlock waveBlock;

// 开始动画
- (void)startAnimation;

// 结束动画
- (void)stopAnimation;

@end
