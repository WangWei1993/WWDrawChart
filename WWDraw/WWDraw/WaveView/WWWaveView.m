//
//  WWWaveView.m
//  WWDraw
//
//  Created by 王伟 on 2017/4/25.
//  Copyright © 2017年 王伟. All rights reserved.
//

#import "WWWaveView.h"

// #define angle2Rad(angle) (angle * )

@interface WWWaveView ()

@property (nonatomic, strong) CAShapeLayer *firstLayer;

@property (nonatomic, strong) CAShapeLayer *secondLayer;

/** 定时器 */
@property (nonatomic, strong) CADisplayLink *timer;

@end

@implementation WWWaveView

- (CAShapeLayer *)firstLayer {
    if (!_firstLayer) {
        _firstLayer = [CAShapeLayer layer];
        CGRect frame = self.bounds;
        _firstLayer.frame = frame;
        _firstLayer.fillColor = [[UIColor orangeColor]colorWithAlphaComponent:0.4].CGColor;
    }
    return _firstLayer;
}

- (CAShapeLayer *)secondLayer {
    if (!_secondLayer) {
        _secondLayer = [CAShapeLayer layer];
        CGRect frame = self.bounds;
        _secondLayer.frame = frame;
        _secondLayer.fillColor = [[UIColor orangeColor]colorWithAlphaComponent:0.2].CGColor;
    }
    return _secondLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

// 初始化默认值
- (void)initData {
    

    self.waveCurvature = 1.5;
    self.waveSpeed  = 1.5;
    self.waveHeight = 20;
    self.firstLayerColor = [UIColor redColor];
    self.secondLayerColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    
 
    // 创建第一条波纹Layer
    [self.layer addSublayer:self.firstLayer];
    
    // 创建第二条波纹Layer
    [self.layer addSublayer:self.secondLayer];
    
}

// 开始动画
- (void)startAnimation {
    
    
    // 开启定时器
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(waveAnimation)];
    // 优先级最高
    [timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}


static  CGFloat _offsetX = 0;

- (void)waveAnimation {
    
    // x方向上的偏移量
    _offsetX += _waveSpeed;
    
    
    // path宽度和高度
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height =  CGRectGetHeight(self.frame);
    
    [self setPath2Layer:self.firstLayer width:width height:height forword:0];
    [self setPath2Layer:self.secondLayer width:width height:height forword:M_PI];
    
    // 设置颜色
    self.secondLayer.fillColor = [self.secondLayerColor colorWithAlphaComponent:0.4].CGColor;
    self.firstLayer.fillColor = [self.firstLayerColor colorWithAlphaComponent:0.6].CGColor;
    
}

// 结束动画
- (void)stopAnimation {
    
    [self.timer invalidate];
    self.timer = nil;

}


- (void)setPath2Layer:(CAShapeLayer *)layer width:(CGFloat)width height:(CGFloat)height forword:(CGFloat)forword {
    
    /*
     if (_increase) {
     _amplitude += 0.01;
     } else {
     _amplitude -= 0.01;
     }
     
     if (_amplitude >= 16) {
     _increase = NO;
     }
     if (_amplitude <= 14) {
     _increase = YES;
     }
     */
    
    // 正选函数的高度
    CGFloat A = self.waveHeight ? self.waveHeight * 0.5: height * 0.5;
    
    // 正选函数在什么位置（在View的centerY的位置）
    CGFloat centerY = height * 0.5;
    
    // 画路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = 0;
    CGPathMoveToPoint(path, NULL, 0, y);
    
    // 添加所有线段
    for (CGFloat x = 0; x <= width; x++) {
        y = A * sinf(0.01 * self.waveCurvature * x + _offsetX * M_PI / 60 + forword) + centerY; //求正弦值
        
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    
    //变化的中间Y值
    CGFloat centX = self.bounds.size.width/2;
    CGFloat CentY = height * sinf(0.01 * self.waveCurvature *centX  + _offsetX * M_PI / 60);
    NSLog(@"--%f---",CentY);
    if (self.waveBlock) {
        self.waveBlock(CentY);
    }

    
    // 添加起始点和终点
    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    
    CGPathCloseSubpath(path);
    layer.path = path;
    CGPathRelease(path);
    

}

/*
 知识点：
 
 0. 正弦波浪公式
 
 y=Asin(ωx+φ)+k
 A——振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2
 ω——角速度， 控制正弦周期(单位角度内震动的次数)
 φ——初相，x=0时的相位；反映在坐标系上则为图像的左右移动
 k——偏距，反映在坐标系上则为图像的上移或下移
 根据公式：改变A，可以让波浪幅度改变，ω目前来看应该是个定值，因为他控制的是角速度，波浪曲线的角速度只在特定的一些值下才显得自然。改变φ使得曲线有水平位移效果
 
 
 1. 定时器CADisplayLink
 CADisplayLink 与 NSTimer 有什么不同
 iOS设备的屏幕刷新频率是固定的，CADisplayLink在正常情况下会在每次刷新结束都被调用，精确度相当高。
 
 NSTimer的精确度就显得低了点，比如NSTimer的触发时间到的时候，runloop如果在阻塞状态，触发时间就会推迟到下一个runloop周期。并且 NSTimer新增了tolerance属性，让用户可以设置可以容忍的触发的时间的延迟范围。
 
 CADisplayLink使用场合相对专一，适合做UI的不停重绘，比如自定义动画引擎或者视频播放的渲染。NSTimer的使用范围要广泛的多，各种需要单次或者循环定时处理的任务都可以使用。
 
 在UI相关的动画或者显示内容使用 CADisplayLink比起用NSTimer的好处就是我们不需要在格外关心屏幕的刷新频率了，因为它本身就是跟屏幕刷新同步的。
 
 CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(wave)];
 [timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
 
 2. CAShapeLayer
 CAShapeLayer继承自CALayer，可使用CALayer的所有属性
 CAShapeLayer需要和贝塞尔曲线配合使用才有意义。 Shape：形状 贝塞尔曲线可以为其提供形状，而单独使用CAShapeLayer是没有任何意义的。
 使用CAShapeLayer与贝塞尔曲线可以实现不在view的DrawRect方法中画出一些想要的图形
 CAShapeLayer和DrawRect的比较
 
 DrawRect：DrawRect属于CoreGraphic框架，占用CPU，消耗性能大
 CAShapeLayer：CAShapeLayer属于CoreAnimation框架，通过GPU来渲染图形，节省性能。动画渲染直接提交给手机GPU，不消耗内存
 贝塞尔曲线与CAShapeLayer的关系
 
 CAShapeLayer中shape代表形状的意思，所以需要形状才能生效
 贝塞尔曲线可以创建基于矢量的路径
 贝塞尔曲线给CAShapeLayer提供路径，CAShapeLayer在提供的路径中进行渲染。路径会闭环，所以绘制出了Shape
 用于CAShapeLayer的贝塞尔曲线作为Path，其path是一个首尾相接的闭环的曲线，即使该贝塞尔曲线不是一个闭环的曲线
 CAShapeLayer其优点
 
 渲染效率高渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
 高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
 不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉。
 不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
 
 3. 如果是放在scrollView中的重绘
 选择合适的Run Loop 模式
 
 当创建CADisplayLink的时候，我们需要指定一个run loop和run loop mode
 当是用UIScrollview滑动的时候，重绘滚动视图的内容会比别的任务优先级更高
 NSDefaultRunLoopMode - 标准优先级
 NSRunLoopCommonModes - 高优先级
 UITrackingRunLoopMode - 用于UIScrollView和别的控件的动画
 CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(wave)];
 [timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
 
 */



@end
