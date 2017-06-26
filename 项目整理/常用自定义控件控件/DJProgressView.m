

#import "DJProgressView.h"

#define KProgressBorderWidth 2.0f
#define KProgressPadding 1.0f
#define KProgressColor [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1]



@interface DJProgressView  ()
@property (nonatomic)DJProgressType type;

@property (nonatomic, weak) UIView *tView;
@property (nonatomic, strong)UIView *borderView;


@property (strong, nonatomic) CAShapeLayer *frontShapeLayer;
@property (strong, nonatomic) CAShapeLayer *backShapeLayer;
@property (strong, nonatomic) UIBezierPath *circleBezierPath;
//渐变用
@property (nonatomic, strong) CAGradientLayer *rightGradLayer;
@property (nonatomic, strong) CAGradientLayer *leftGradLayer;
@property (nonatomic, strong) CALayer *gradLayer;
@end

@implementation DJProgressView

- (instancetype)initWithFrame:(CGRect)frame type:(DJProgressType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        self.backgroundColor = [UIColor whiteColor];
         if (_type == kDJProgressBarType){
            //边框
            UIView *borderView = [[UIView alloc] initWithFrame:self.bounds];
            borderView.layer.cornerRadius = self.bounds.size.height * 0.5;
            borderView.layer.masksToBounds = YES;
            borderView.backgroundColor = [UIColor whiteColor];
            borderView.layer.borderColor = [KProgressColor CGColor];
            borderView.layer.borderWidth = KProgressBorderWidth;
            [self addSubview:borderView];
             _borderView = borderView;
            //进度
            UIView *tView = [[UIView alloc] init];
            tView.backgroundColor = KProgressColor;
//            tView.layer.cornerRadius = (self.bounds.size.height - (KProgressBorderWidth + KProgressPadding) * 2) * 0.5;
             tView.layer.cornerRadius =  self.bounds.size.height * 0.5;
            tView.layer.masksToBounds = YES;
            [self addSubview:tView];
            self.tView = tView;
         }else{
             _baseColor =[UIColor colorWithWhite:0.886 alpha:1.000];
             _progressColor = KProgressColor;
             _lineWeight = 5.0;
             [self setNeedsDisplay];
         }
    }
    return self;
}
- (void)setProgress:(CGFloat)progress
{

    
    _progress = progress;

    if (_type == kDJProgressRoundType) {
        NSAssert(progress >= 0 && progress <=1, @"超出范围");
        _progress = progress;
        [self setNeedsDisplay];

    }else if (_type == kDJProgressBarType){
//        CGFloat margin = KProgressBorderWidth + KProgressPadding;
//        CGFloat maxWidth = self.bounds.size.width - margin * 2;
//        CGFloat heigth = self.bounds.size.height - margin * 2;
        _tView.frame = CGRectMake(0, 0, self.bounds.size.width  * progress, self.bounds.size.height);
//        _tView.frame = CGRectMake(margin, margin, maxWidth * progress, heigth);
        [self layoutIfNeeded];
    }
    

   
}
-(void)drawRect:(CGRect)rect{
    
    if (_type == kDJProgressBarType){
        return;
    }
    CGFloat kWidth = rect.size.width;
    CGFloat kHeight = rect.size.height;
    
    if (!self.circleBezierPath){
        self.circleBezierPath = ({
            CGPoint pCenter = CGPointMake(kWidth * 0.5, kHeight * 0.5);
            CGFloat radius = MIN(kWidth, kHeight);
            radius = radius - _lineWeight;
            UIBezierPath *circlePath = [UIBezierPath bezierPath];
            [circlePath addArcWithCenter:pCenter radius:radius * 0.5 startAngle:270 * M_PI / 180 endAngle:269 * M_PI / 180 clockwise:YES];
            [circlePath closePath];
            circlePath;
        });
    }
    if (!self.backShapeLayer) {
        self.backShapeLayer = ({
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.frame = rect;
            shapeLayer.path = self.circleBezierPath.CGPath;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.lineWidth = _lineWeight;
            shapeLayer.strokeColor = _baseColor.CGColor;
            shapeLayer.lineCap = kCALineCapRound;
            [self.layer addSublayer:shapeLayer];
            shapeLayer;
        });
    }
    
    if (!self.frontShapeLayer){
        self.frontShapeLayer = ({
            CAShapeLayer  *shapeLayer = [CAShapeLayer layer];
            shapeLayer.frame = rect;
            shapeLayer.path = self.circleBezierPath.CGPath;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.lineWidth = _lineWeight;
            shapeLayer.strokeColor = _progressColor.CGColor;
            shapeLayer;
        });
        if (self.gradual) {
            [self addGradLayerWithRect:rect];
            self.frontShapeLayer.lineCap = kCALineCapRound;
            _gradLayer.mask = self.frontShapeLayer;
            [self.layer addSublayer:_gradLayer];
        }else{
            [self.layer addSublayer:self.frontShapeLayer];
        }
    }
    
    [self startAnimationValue:self.progress];
}
- (void)addGradLayerWithRect:(CGRect)rect{
    CGFloat kHeight = rect.size.height;
    CGRect viewRect = CGRectMake(0, 0, kHeight, kHeight);
    CGPoint centrePoint = CGPointMake(kHeight/2, kHeight/2);
    
    _leftGradLayer = ({
        CAGradientLayer *leftGradLayer = [CAGradientLayer layer];
        leftGradLayer.bounds = CGRectMake(0, 0, kHeight/2, kHeight);
        leftGradLayer.locations = @[@0.1];
        [leftGradLayer setColors:@[(id)_progressColor.CGColor,(id)_baseColor.CGColor]];
        leftGradLayer.position = CGPointMake(leftGradLayer.bounds.size.width/2, leftGradLayer.bounds.size.height/2);
        leftGradLayer;
    });
    _rightGradLayer = ({
        CAGradientLayer *rightGradLayer = [CAGradientLayer layer];
        rightGradLayer.locations = @[@0.1];
        rightGradLayer.bounds = CGRectMake(kHeight/2, 0, kHeight/2, kHeight);
        [rightGradLayer setColors:@[(id)_progressColor.CGColor,(id)_baseColor.CGColor]];
        rightGradLayer.position = CGPointMake(rightGradLayer.bounds.size.width/2+kHeight/2, rightGradLayer.bounds.size.height/2);
        rightGradLayer;
    });
    _gradLayer = ({
        CALayer *gradLayer = [CALayer layer];
        gradLayer.bounds = viewRect;
        gradLayer.position = centrePoint;
        gradLayer.backgroundColor = [UIColor clearColor].CGColor;
        gradLayer;
    });
    [_gradLayer addSublayer:_leftGradLayer];
    [_gradLayer addSublayer:_rightGradLayer];
}
- (void)startAnimationValue:(CGFloat)value{
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 1.0f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:value];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [self.frontShapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
}

- (void)setGradual:(BOOL)gradual{
    _gradual = gradual;
    if (gradual) {
        [self.frontShapeLayer removeFromSuperlayer];
        self.frontShapeLayer = nil;
    }else{
        [_gradLayer removeFromSuperlayer];
        _gradLayer = nil;
        [self.frontShapeLayer removeFromSuperlayer];
        self.frontShapeLayer = nil;
    }
} 

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    _tView.backgroundColor = progressColor;
    [self layoutIfNeeded];
    [self setNeedsDisplay];

}
- (void)setBaseColor:(UIColor *)baseColor
{
    _baseColor = baseColor;
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}
- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
     _borderView.layer.borderColor = [borderColor CGColor];
    [self layoutIfNeeded];
}
- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    _borderView.layer.borderWidth = borderWidth;
    [self layoutIfNeeded];
}
- (void)setLineWeight:(CGFloat)lineWeight
{
    _lineWeight = lineWeight;
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}
@end
