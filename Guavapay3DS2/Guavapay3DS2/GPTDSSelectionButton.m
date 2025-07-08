//
//  GPTDSSelectionButton.h
//  Guavapay3DS2
//

#import "GPTDSSelectionButton.h"

#import "GPTDSSelectionCustomization.h"

@interface _GPTDSSelectionButtonView: UIView
@property (nonatomic) BOOL isCheckbox;
@property (nonatomic) GPTDSSelectionCustomization *customization;
@property (nonatomic, getter = isSelected) BOOL selected;
@end

static const CGFloat kMinimumTouchAreaDimension = 42.f;
static const CGFloat kContentSizeDimension = 22.f;
static const CGFloat kCornerRadiusDimension = 4.f;
static const CGFloat kRadioBorderWidthDimension = 2.f;

@implementation _GPTDSSelectionButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }

    return self;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}


- (void)setCustomization:(GPTDSSelectionCustomization *)customization {
    _customization = customization;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    if (self.isCheckbox) {
        [self _drawCheckboxWithRect:rect];
    } else {
        [self _drawRadioButtonWithRect:rect];
    }
}

- (void)_drawRadioButtonWithRect:(CGRect)rect {
    // Fill background
    UIBezierPath *background = [UIBezierPath bezierPathWithOvalInRect:rect];
    [self.customization.unselectedBackgroundColor setFill];
    [background fill];

    // Draw outer ring
    CGFloat borderWidth = kRadioBorderWidthDimension;
    CGRect borderRect = CGRectInset(rect, borderWidth / 2.0, borderWidth / 2.0);
    UIBezierPath *border = [UIBezierPath bezierPathWithOvalInRect:borderRect];
    UIColor *ringColor = self.isSelected ? self.customization.primarySelectedColor : self.customization.unselectedBorderColor;
    [ringColor setStroke];
    border.lineWidth = borderWidth;
    [border stroke];

    // Draw inner dot when selected
    if (self.isSelected) {
        CGFloat dotInset = borderWidth * 2.0;
        CGRect dotRect = CGRectInset(rect, dotInset, dotInset);
        UIBezierPath *dot = [UIBezierPath bezierPathWithOvalInRect:dotRect];
        [self.customization.primarySelectedColor setFill];
        [dot fill];
    }
}

- (void)_drawCheckboxWithRect:(CGRect)rect {
    // Draw background
    UIBezierPath *background = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:kCornerRadiusDimension];
    if (self.isSelected) {
        [self.customization.primarySelectedColor setFill];
    } else {
        [self.customization.unselectedBackgroundColor setFill];
    }
    [background fill];

    // Draw unselected border
    if (!self.isSelected) {
        UIBezierPath *border = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1.0, 1.0) cornerRadius:kCornerRadiusDimension];
        border.lineWidth = 2.0;
        [self.customization.unselectedBorderColor setStroke];
        [border stroke];
    }

    // Draw check mark if selected
    if (self.isSelected) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat w = CGRectGetWidth(rect);
        CGFloat h = CGRectGetHeight(rect);
        CGFloat size = MIN(w, h);
        CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        CGFloat xOff = size * 0.25;
        CGFloat yOff = size * 0.15;

        CGPoint p1 = CGPointMake(center.x - xOff, center.y);
        CGPoint p2 = CGPointMake(center.x - xOff * 0.3, center.y + yOff);
        CGPoint p3 = CGPointMake(center.x + xOff, center.y - yOff);

        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        [path addLineToPoint:p3];

        path.lineWidth = 2;
        path.lineCapStyle = kCGLineCapRound;
        [self.customization.secondarySelectedColor setStroke];
        [path stroke];
    }
}

@end

@implementation GPTDSSelectionButton {
    _GPTDSSelectionButtonView *_contentView;
}

- (instancetype)initWithCustomization:(GPTDSSelectionCustomization *)customization {
    self = [super init];
    if (self) {
        _contentView = [[_GPTDSSelectionButtonView alloc] initWithFrame:CGRectMake(0, 0, kContentSizeDimension, kContentSizeDimension)];
        _contentView.userInteractionEnabled = NO;
        [self addSubview:_contentView];
        self.customization = customization;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL pointInside = [super pointInside:point withEvent:event];
    if (!pointInside &&
        self.enabled &&
        !self.isHidden &&
        (CGRectGetWidth(self.bounds) < kMinimumTouchAreaDimension || CGRectGetHeight(self.bounds) < kMinimumTouchAreaDimension)
        ) {
        // Make sure that we intercept touch events even outside our bounds if they are within the
        // minimum touch area. Otherwise this button is too hard to tap
        CGRect expandedBounds = CGRectInset(self.bounds, MIN(CGRectGetWidth(self.bounds) - kMinimumTouchAreaDimension, 0), MIN(CGRectGetHeight(self.bounds) < kMinimumTouchAreaDimension, 0));
        pointInside = CGRectContainsPoint(expandedBounds, point);
    }

    return pointInside;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kContentSizeDimension, kContentSizeDimension);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _contentView.selected = selected;
}

- (void)setCustomization:(GPTDSSelectionCustomization *)customization {
    _contentView.customization = customization;
}

- (GPTDSSelectionCustomization *)customization {
    return _contentView.customization;
}

- (void)setIsCheckbox:(BOOL)isCheckbox {
    _contentView.isCheckbox = isCheckbox;
}

- (BOOL)isCheckbox {
    return _contentView.isCheckbox;
}

@end
