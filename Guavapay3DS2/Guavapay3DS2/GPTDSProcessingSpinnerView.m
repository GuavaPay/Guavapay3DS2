//
//  GPTDSProcessingSpinnerView 2.h
//  Guavapay3DS2
//


#import "GPTDSProcessingSpinnerView.h"
#import "UIColor+DefaultColors.h"
#import <QuartzCore/QuartzCore.h>

@interface GPTDSProcessingSpinnerView ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGFloat lineWidth;
@end

@implementation GPTDSProcessingSpinnerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = 6.0;
        _spinnerColor = [UIColor _gptds_backgroundBrandColor];
        [self setupLayer];
        [self startSpinning];
    }
    return self;
}

- (void)setupLayer {
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.strokeColor = self.spinnerColor.CGColor;
    self.shapeLayer.fillColor = nil;
    self.shapeLayer.lineWidth = self.lineWidth;
    self.shapeLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.shapeLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat radius = (MIN(self.bounds.size.width, self.bounds.size.height) - self.lineWidth) / 2.0;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + (M_PI * 1.5);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    self.shapeLayer.path = path.CGPath;
    self.shapeLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)startSpinning {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anim.fromValue = @(0);
    anim.toValue = @(2 * M_PI);
    anim.duration = 2.0;
    anim.repeatCount = INFINITY;
    [self.layer addAnimation:anim forKey:@"spin"];
}

@end
