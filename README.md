# WWDrawChart

## waveView波浪View

对外接口
typedef void(^WaveViewBlock)(CGFloat currentY);

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



```
// 初始化
WWWaveView *waveView = [[WWWaveView alloc] init];
[self.view addSubview:waveView];
waveView.frame= CGRectMake(0, 0, self.view.frame.size.width, 100);
waveView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
waveView.center = self.view.center;

// 设置参数
self.waveView.firstLayerColor = [UIColor orangeColor];
self.waveView.secondLayerColor = [UIColor orangeColor];
self.waveView.waveHeight = 40;
self.waveView.waveCurvature = 1.5;
self.waveView.waveSpeed = 1.5;

// 开始动画
[self.waveView startAnimation];

// 结束动画
[self.waveView stopAnimation];

```
