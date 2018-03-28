//
//  ZXView.m
//  折线图
//
//  Created by iOS on 16/6/28.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "ZXView.h"
@interface ZXView ()
@property (nonatomic, strong) CAShapeLayer *lineChartLayer;

@property (nonatomic, strong)UIBezierPath * path1;
/** 渐变背景视图 */
@property (nonatomic, strong) UIView *gradientBackgroundView;
/** 渐变图层 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray *gradientLayerColors;

@property (nonatomic, assign) TimeType timeType;
@end
@implementation ZXView
static CGFloat bounceX = 20;
static CGFloat bounceY = 20;
static CGFloat lineCount = 7;
static CGFloat timeCount = 17;
static NSInteger countq = 0;
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self createLabelY];
        [self drawGradientBackgroundView];
        [self setLineDash];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
       /*******画出坐标轴********/
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 0);
    CGContextMoveToPoint(context, bounceX, bounceY);
    CGContextAddLineToPoint(context, bounceX, rect.size.height - bounceY);
    CGContextAddLineToPoint(context,rect.size.width -  bounceX, rect.size.height - bounceY);
    CGContextStrokePath(context);
    
      }

#pragma mark 添加虚线

- (void)setLineDash{

    for (NSInteger i = 0;i < 7; i++ ) {
        
        CAShapeLayer * dashLayer = [CAShapeLayer layer];
        dashLayer.strokeColor = [UIColor whiteColor].CGColor;
        
        dashLayer.fillColor = [[UIColor clearColor] CGColor];
        // 默认设置路径宽度为0，使其在起始状态下不显示
        dashLayer.lineWidth = 1.0;


        UILabel * label1 = (UILabel*)[self viewWithTag:1400 + i];
        
        UIBezierPath * path = [[UIBezierPath alloc]init];
        path.lineWidth = 1.0;
        UIColor * color = [UIColor blueColor];
        
        [color set];
        
 [path moveToPoint:CGPointMake( 0, label1.frame.origin.y - bounceY)];
        
 [path addLineToPoint:CGPointMake(self.frame.size.width - 2*bounceX,label1.frame.origin.y - bounceY)];
        
        CGFloat dash[] = {10,10};
        
        [path setLineDash:dash count:2 phase:10];
        [path stroke];
        dashLayer.path = path.CGPath;
        [self.gradientBackgroundView.layer addSublayer:dashLayer];
         }
}

#pragma mark 画折线图
- (void)dravLine{
    
    
    UILabel * label = (UILabel*)[self viewWithTag:1000];
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 3.0;
    self.path1 = path;
    UIColor * color = [UIColor greenColor];
    [color set];
    [path moveToPoint:CGPointMake( label.frame.origin.x , (140 -arc4random()%140) /140.0 * (self.frame.size.height - bounceY*2 )  )];

    //创建折现点标记
    for (NSInteger i = 1; i< timeCount; i++) {
        UILabel * label1 = (UILabel*)[self viewWithTag:1000 + i];
        CGFloat  arc = arc4random()%140;
        
        
        [path addLineToPoint:CGPointMake(label1.frame.origin.x - bounceX,  (140 -arc) /140.0 * (self.frame.size.height - bounceY*2 ) )];

        UILabel * falglabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x , (140 -arc) /140.0 * (self.frame.size.height - bounceY*2 )+ bounceY  , 30, 15)];
      //  falglabel.backgroundColor = [UIColor blueColor];
        falglabel.tag = 3000+ i;
        falglabel.text = [NSString stringWithFormat:@"%.1f",arc+60];
        falglabel.font = [UIFont systemFontOfSize:8.0];
//        [self addSubview:falglabel];
    }
    // [path stroke];
    
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    self.lineChartLayer.strokeColor = [UIColor redColor].CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    self.lineChartLayer.lineWidth = 5;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    
    [self.gradientBackgroundView.layer addSublayer:self.lineChartLayer];//直接添加导视图上
 //   self.gradientBackgroundView.layer.mask = self.lineChartLayer;//添加到渐变图层

}

- (void)setViewTimeType:(TimeType)timeType{
    
    _timeType = timeType;
    
    switch (timeType) {
        case Time30:
        {
            for (NSInteger i = 0; i < timeCount; i++) {
                
                UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 2*bounceX)/timeCount * i + bounceX/2, self.frame.size.height - bounceY + bounceY*0.3+5, (self.frame.size.width - 2*bounceX)/timeCount+10, bounceY/2)];
                
                if (i==0) {
                    
                    LabelMonth.tag = 1000 + i;
                    LabelMonth.font = [UIFont systemFontOfSize:10];
                }else if (i==timeCount-1){
                    LabelMonth.tag = 1000 + i;
                    LabelMonth.text = [NSString stringWithFormat:@"时间(分)"];
                    LabelMonth.font = [UIFont systemFontOfSize:10];
                    
                }else{
                    
                    LabelMonth.tag = 1000 + i;
                    LabelMonth.text = [NSString stringWithFormat:@"%ld",i*2];
                    LabelMonth.font = [UIFont systemFontOfSize:10];
                }
                
                
                [self addSubview:LabelMonth];
            }
        }
            break;
        case Time60:
        {
            for (NSInteger i = 0; i < timeCount; i++) {
                
                UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 2*bounceX)/timeCount * i + bounceX/2, self.frame.size.height - bounceY + bounceY*0.3+5, (self.frame.size.width - 2*bounceX)/timeCount+10, bounceY/2)];
                
                if (i==0) {
                    
                    LabelMonth.tag = 1000 + i;
                    LabelMonth.font = [UIFont systemFontOfSize:10];
                }else if (i==timeCount-1){
                    LabelMonth.tag = 1000 + i;
                    LabelMonth.text = [NSString stringWithFormat:@"时间(分)"];
                    LabelMonth.font = [UIFont systemFontOfSize:10];
                    
                }else{
                    
                    LabelMonth.tag = 1000 + i;
                    LabelMonth.text = [NSString stringWithFormat:@"%ld",i*4];
                    LabelMonth.font = [UIFont systemFontOfSize:10];
                }
                
                
                [self addSubview:LabelMonth];
            }
        }
            break;
        case Time90:
        {
            for (NSInteger i = 0; i < timeCount; i++) {
                
                UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 2*bounceX)/timeCount * i + bounceX/2, self.frame.size.height - bounceY + bounceY*0.3+5, (self.frame.size.width - 2*bounceX)/timeCount+10, bounceY/2)];
                
                if (i==0) {
                    
                    LabelMonth.tag = 1000 + i;
                    LabelMonth.font = [UIFont systemFontOfSize:10];
                }else if (i==timeCount-1){
                    LabelMonth.tag = 1000 + i;
                    LabelMonth.text = [NSString stringWithFormat:@"时间(分)"];
                    LabelMonth.font = [UIFont systemFontOfSize:10];
                    
                }else{
                    
                    LabelMonth.tag = 1000 + i;
                    LabelMonth.text = [NSString stringWithFormat:@"%ld",i*6];
                    LabelMonth.font = [UIFont systemFontOfSize:10];
                }

                [self addSubview:LabelMonth];
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark 创建x轴的数据
- (void)createLabelX{
//    CGFloat  month = 12;
    for (NSInteger i = 0; i < timeCount; i++) {
        
        UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 2*bounceX)/timeCount * i + bounceX/2, self.frame.size.height - bounceY + bounceY*0.3+5, (self.frame.size.width - 2*bounceX)/timeCount+10, bounceY/2)];

        if (i==0) {
            
            LabelMonth.tag = 1000 + i;
            LabelMonth.font = [UIFont systemFontOfSize:10];
        }else if (i==timeCount-1){
            LabelMonth.tag = 1000 + i;
            LabelMonth.text = [NSString stringWithFormat:@"时间(分)"];
            LabelMonth.font = [UIFont systemFontOfSize:10];

        }else{
            
            LabelMonth.tag = 1000 + i;
            LabelMonth.text = [NSString stringWithFormat:@"%ld",i*5];
            LabelMonth.font = [UIFont systemFontOfSize:10];
        }
     

        [self addSubview:LabelMonth];
    }

}
#pragma mark 创建y轴数据
- (void)createLabelY{
//    CGFloat Ydivision = 6;
    for (NSInteger i = 0; i < lineCount+1; i++) {
        
        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height - 2 * bounceY)/lineCount * i + bounceX , bounceY, bounceY/2.0)];
        
//        labelYdivision.backgroundColor = [UIColor greenColor];
        
        labelYdivision.tag = 1400 + i;
        labelYdivision.text = [NSString stringWithFormat:@"%.0f",(lineCount - i)*20 + 60];
         labelYdivision.font = [UIFont systemFontOfSize:10];
        [self addSubview:labelYdivision];
    }
}


#pragma mark 渐变的颜色
- (void)drawGradientBackgroundView {
    // 渐变背景视图（不包含坐标轴）
    self.gradientBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(bounceX, bounceY, self.bounds.size.width - bounceX*2, self.bounds.size.height - 2*bounceY)];
    [self addSubview:self.gradientBackgroundView];
    /** 创建并设置渐变背景图层 */
    
    UIView * back1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width - bounceX*2, (self.bounds.size.height - 2*bounceY)/7)];
    
    back1.backgroundColor = [UIColor redColor];
    
    [self.gradientBackgroundView addSubview:back1];
    
    UIView * back2 = [[UIView alloc]initWithFrame:CGRectMake(0, (self.bounds.size.height - 2*bounceY)/7, self.bounds.size.width - bounceX*2, (self.bounds.size.height - 2*bounceY)/7)];
    
    back2.backgroundColor = UIColorFromRGB(0xb13760);
    
    [self.gradientBackgroundView addSubview:back2];
    
    UIView * back3 = [[UIView alloc]initWithFrame:CGRectMake(0, 2*(self.bounds.size.height - 2*bounceY)/7, self.bounds.size.width - bounceX*2, (self.bounds.size.height - 2*bounceY)/7)];
    
    back3.backgroundColor = UIColorFromRGB(0xc08c42);
    
    [self.gradientBackgroundView addSubview:back3];
    
    UIView * back4 = [[UIView alloc]initWithFrame:CGRectMake(0, 3*(self.bounds.size.height - 2*bounceY)/7, self.bounds.size.width - bounceX*2, (self.bounds.size.height - 2*bounceY)/7)];
    
    back4.backgroundColor = UIColorFromRGB(0x8a9e57);
    
    [self.gradientBackgroundView addSubview:back4];
    
    UIView * back5 = [[UIView alloc]initWithFrame:CGRectMake(0, 4*(self.bounds.size.height - 2*bounceY)/7, self.bounds.size.width - bounceX*2, (self.bounds.size.height - 2*bounceY)/7)];
    
    back5.backgroundColor = UIColorFromRGB(0x5ea6b4);
    
    [self.gradientBackgroundView addSubview:back5];
    
    UIView * back6 = [[UIView alloc]initWithFrame:CGRectMake(0, 5*(self.bounds.size.height - 2*bounceY)/7, self.bounds.size.width - bounceX*2, (self.bounds.size.height - 2*bounceY)/7)];
    
    back6.backgroundColor = UIColorFromRGB(0xa0a4a5);
    
    [self.gradientBackgroundView addSubview:back6];
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    self.gradientBackgroundView.backgroundColor = UIColorFromRGB(0x6c6a6a);
    
//    [self.gradientBackgroundView.layer addSublayer:self.gradientLayer];
//     [self.layer addSublayer:self.gradientLayer];
}

#pragma mark 点击重新绘制折线和背景
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}
- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"开始®");
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"停止~~~~~~~~");
}

- (void)loadDemoData{
    
    [self.lineChartLayer removeFromSuperlayer];
    
    self.lineChartLayer.lineWidth = 1;
    
    UILabel * label = (UILabel*)[self viewWithTag:1000];
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 3.0;
    self.path1 = path;
    UIColor * color = [UIColor greenColor];
    [color set];
    
    [path moveToPoint:CGPointMake( label.frame.origin.x , (200 -120) /140.0 * (self.frame.size.height - bounceY*2 )  )];
    
    //创建折现点标记
    
    NSInteger heart = 120;
    
    for (NSInteger i = 1; i< 120; i++) {
        
        NSInteger heartPoint = heart - 10 + arc4random()%20;
        
        if (heartPoint > 170) {
            heartPoint = 170;
        }
        if (heartPoint < 80) {
            heartPoint = 80;
        }
        
        heart = heartPoint;
        
        [path addLineToPoint:CGPointMake( label.frame.origin.x + i * 600 / 120 ,  (200 - heart) /140.0 * (self.frame.size.height - bounceY*2 ) )];
        
    }
    
}

- (void)loadData:(NSArray *)dataArry Animated:(BOOL)animated timeLong:(NSInteger)timelong{
    
    [self.lineChartLayer removeFromSuperlayer];
    
    self.lineChartLayer.lineWidth = 1;
    
    UILabel * label = (UILabel*)[self viewWithTag:1000];
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 3.0;
    self.path1 = path;
    UIColor * color = [UIColor greenColor];
    [color set];
    
    MiHeartModel * heartModel = [dataArry objectAtIndexWithSafety:0];
    
    NSInteger heartNo = heartModel.heartNumber.integerValue;
    
    [path moveToPoint:CGPointMake( label.frame.origin.x , (200 -heartNo) /140.0 * (self.frame.size.height - bounceY*2 )  )];
    
    //创建折现点标记
    
    for (NSInteger i = 1; i< dataArry.count; i++) {
        
        MiHeartModel * heartModel = [dataArry objectAtIndexWithSafety:i];
        
        NSInteger heartNo = heartModel.heartNumber.integerValue;
        
        NSInteger timePoint = heartModel.timePoint.integerValue;
        
        NSLog(@"timePointtimePoint   %ld",timePoint);
        
        
        switch (_timeType) {
            case Time30:
            {
                [path addLineToPoint:CGPointMake(timePoint *600 / 1800 ,  (200 -heartNo) /140.0 * (self.frame.size.height - bounceY*2 ) )];
            }
                break;
            case Time60:
            {
                [path addLineToPoint:CGPointMake(timePoint *600 / 3600 ,  (200 -heartNo) /140.0 * (self.frame.size.height - bounceY*2 ) )];
            }
                break;
            case Time90:
            {
                [path addLineToPoint:CGPointMake(timePoint *600 / 5400 ,  (200 -heartNo) /140.0 * (self.frame.size.height - bounceY*2 ) )];
            }
                break;
                
            default:
                break;
        }
    }

    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    self.lineChartLayer.strokeColor = [UIColor redColor].CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    self.lineChartLayer.lineWidth = 1;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    
    [self.gradientBackgroundView.layer addSublayer:self.lineChartLayer];//直接添加导视图上
    //   self.gradientBackgroundView.layer.mask = self.lineChartLayer;//添加到渐变图层
    
    self.lineChartLayer.lineWidth = 1;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    // 设置动画代理，动画结束时添加一个标签，显示折线终点的信息
    pathAnimation.delegate = self;

    
}




@end
