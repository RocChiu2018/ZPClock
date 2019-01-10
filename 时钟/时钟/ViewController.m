//
//  ViewController.m
//  时钟
//
//  Created by 赵鹏 on 2019/1/10.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ViewController.h"

#define kClockImageViewWH  _clockImageView.bounds.size.width  //钟表的宽高
#define kAngleConvertRadian(angle)  (angle) / 180.0 * M_PI  //角度转换为弧度
#define kPerSecSecondHandRotateAngle  6  //每秒钟秒针转动的角度
#define kPerMinMinuteHandRotateAngle  6  //每分钟分针转动的角度
#define kPerHourHourHandRotateAngle  30  //每小时时针转动的角度

/**
 每分钟时针转动的角度：
 一个小时有60分钟，每过一个小时，时针转动30度，所以每过一分钟时针转动0.5度。
 */
#define kPerMinHourHandRotateAngle  0.5

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *clockImageView;

@property (nonatomic, weak) CALayer *secondHandLayer;  //秒针
@property (nonatomic, weak) CALayer *minuteHandLayer;  //分针
@property (nonatomic, weak) CALayer *hourHandLayer;  //时针

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     要按顺序添加表盘上的指针。时针在最底下，分针在中间，秒针在最上面，所以应该先添加时针，再添加分针，最后添加秒针。如果不按照顺序添加的话可能会造成指针之间的相互遮盖。
     */
    
    //添加时针
    [self addHourHand];
    
    //添加分针
    [self addMinuteHand];
    
    //添加秒针
    [self addSecondHand];
    
    /**
     添加定时器：
     每秒钟更新一次表盘。
     */
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateClock) userInfo:nil repeats:YES];
    
    /**
     因为刚开始运行的时候三个指针都会在初始的位置上，只有过1秒钟调用"updateClock"方法之后，指针才会到正确的位置上，这样看着很别扭，所以刚开始运行的时候就要调用一次"updateClock"方法。
     */
    [self updateClock];
}

#pragma mark ————— 更新时钟 —————
- (void)updateClock
{
    //获取当前的日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    /**
     获取日期组件：
     unitFlags参数代表需要获取的日期组件；
     date参数代表需要获取哪个日期的组件；
     */
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:[NSDate date]];
    
    //获取当前时间的秒
    NSInteger second = dateComponents.second;
    
    //获取当前时间的分钟
    NSInteger minute = dateComponents.minute;
    
    //获取当前时间的小时
    NSInteger hour = dateComponents.hour;
    
    //计算当前时间下秒针转了多少度
    CGFloat secondAngle = second * kPerSecSecondHandRotateAngle;
    
    //计算当前时间下分针转了多少度
    CGFloat minuteAngle = minute * kPerMinMinuteHandRotateAngle;
    
    //计算当前时间下时针转了多少度
    CGFloat hourAngle = hour * kPerHourHourHandRotateAngle + minute *kPerMinHourHandRotateAngle;
    
    //旋转秒针
    self.secondHandLayer.transform = CATransform3DMakeRotation(kAngleConvertRadian(secondAngle), 0, 0, 1);
    
    //旋转分针
    self.minuteHandLayer.transform = CATransform3DMakeRotation(kAngleConvertRadian(minuteAngle), 0, 0, 1);
    
    //旋转时针
    self.hourHandLayer.transform = CATransform3DMakeRotation(kAngleConvertRadian(hourAngle), 0, 0, 1);
}

#pragma mark ————— 添加时针 —————
- (void)addHourHand
{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor blackColor].CGColor;
    
    layer.anchorPoint = CGPointMake(0.5, 1);  //设置锚点
    layer.position = CGPointMake(kClockImageViewWH * 0.5, kClockImageViewWH * 0.5);
    layer.bounds = CGRectMake(0, 0, 4, kClockImageViewWH * 0.5 - 40);
    layer.cornerRadius = 4;
    [self.clockImageView.layer addSublayer:layer];
    
    self.hourHandLayer = layer;
}

#pragma mark ————— 添加分针 —————
- (void)addMinuteHand
{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor blackColor].CGColor;
    
    layer.anchorPoint = CGPointMake(0.5, 1);  //设置锚点
    layer.position = CGPointMake(kClockImageViewWH * 0.5, kClockImageViewWH * 0.5);
    layer.bounds = CGRectMake(0, 0, 4, kClockImageViewWH * 0.5 - 20);
    layer.cornerRadius = 4;
    [self.clockImageView.layer addSublayer:layer];
    
    self.minuteHandLayer = layer;
}

#pragma mark ————— 添加秒针 —————
- (void)addSecondHand
{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    
    layer.anchorPoint = CGPointMake(0.5, 1);  //设置锚点
    layer.position = CGPointMake(kClockImageViewWH * 0.5, kClockImageViewWH * 0.5);
    layer.bounds = CGRectMake(0, 0, 1, kClockImageViewWH * 0.5 - 20);
    [self.clockImageView.layer addSublayer:layer];
    
    self.secondHandLayer = layer;
}

@end
