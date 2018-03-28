//
//  chartView.m
//  lifeBit_teach
//
//  Created by 程党威 on 2017/10/27.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "chartView.h"

@interface chartView()
@property (nonatomic, strong) CAShapeLayer *lineChartLayer;

@property (nonatomic, strong)UIBezierPath * path1;
/** 渐变背景视图 */
@property (nonatomic, strong) UIView * gradientBackgroundView;
/** 渐变图层 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray *gradientLayerColors;

@property (nonatomic, assign) NSInteger  timeCount;

@end

@implementation chartView
static CGFloat bounceX = 40;
static CGFloat bounceY = 40;
static CGFloat lineCount = 7;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createLabelY];
        [self drawGradientBackgroundView];
        [self setLineDash];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)creatViewWithTime:(NSInteger)time{
    _timeCount = time;
     [self createLabelX];
    
}
- (void)creatTittle:(NSString *)tittle{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    label.text = tittle;
    
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
        
        [path moveToPoint:CGPointMake( 0, label1.frame.origin.y - bounceY+5)];
        
        [path addLineToPoint:CGPointMake(self.frame.size.width - 2*bounceX, label1.frame.origin.y - bounceY+5)];
        
        CGFloat dash[] = {10,10};
        
        [path setLineDash:dash count:2 phase:10];
        [path stroke];
        dashLayer.path = path.CGPath;
        [self.gradientBackgroundView.layer addSublayer:dashLayer];
    }
}

#pragma mark 创建x轴的数据
- (void)createLabelX{

    for (NSInteger i = 0; i < _timeCount+2; i++) {
        
        UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 2*bounceX)/(_timeCount+1) * i + bounceX, self.frame.size.height - bounceY + bounceY*0.1+5, 40, bounceY/2)];
        
        if (i==0) {
            
            LabelMonth.text = [NSString stringWithFormat:@"%ld",i];
            LabelMonth.tag = 1000 + i;
            LabelMonth.font = [UIFont systemFontOfSize:10];
            
        }else if (i==_timeCount+1){
            LabelMonth.tag = 1000 + i;
            LabelMonth.text = [NSString stringWithFormat:@"时间(分)"];
            LabelMonth.font = [UIFont systemFontOfSize:10];
            
        }else{
            
            LabelMonth.tag = 1000 + i;
            LabelMonth.text = [NSString stringWithFormat:@"%ld",i];
            LabelMonth.font = [UIFont systemFontOfSize:10];
        }
        

        [self addSubview:LabelMonth];
    }
    
}
#pragma mark 创建y轴数据
- (void)createLabelY{
    
    for (NSInteger i = 0; i < lineCount+1; i++) {
        
        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height - 2 * bounceY)/lineCount * i + bounceX-5 , bounceY-10, bounceY/4.0)];
//        labelYdivision.backgroundColor = [UIColor redColor];
        labelYdivision.textAlignment = NSTextAlignmentRight;
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
    //[self.layer addSublayer:self.gradientLayer];
}

#pragma mark 点击重新绘制折线和背景

- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"开始®");
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"停止~~~~~~~~");
}


- (void)loadData:(NSArray *)dataArry Animated:(BOOL)animated timeLong:(NSInteger)timelong{
    
    [self.lineChartLayer removeFromSuperlayer];
    
    self.lineChartLayer.lineWidth = 1;

    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 3.0;
    self.path1 = path;
    UIColor * color = [UIColor greenColor];
    [color set];
    
    [path moveToPoint:CGPointMake( 0 , (200 - 60) /140.0 * (self.frame.size.height - bounceY*2 )  )];
    
    //创建折现点标记
    
    for (NSInteger i = 1; i< dataArry.count; i++) {
        
        MiHeartModel * heartModel = [dataArry objectAtIndexWithSafety:i];
        
        NSInteger heartNo = heartModel.heartNumber.integerValue;
        
        NSInteger timePoint = heartModel.timePoint.integerValue;
        
        [path addLineToPoint:CGPointMake(timePoint ,  (200 - heartNo) /140.0 * (self.frame.size.height - bounceY*2 ))];
        
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

-(void)setZXView:(NSArray*)dataArry{
    
    
}

-(NSData*)getChart{
    
    return nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
