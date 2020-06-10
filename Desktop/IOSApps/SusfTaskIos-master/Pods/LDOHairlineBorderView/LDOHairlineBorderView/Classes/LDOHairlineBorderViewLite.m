//
//  LDOHairlineBorderViewLite.m
//  LDOHairlineBorderView
//
//  Created by Sebastian Ludwig on 03.02.19.
//

#import "LDOHairlineBorderViewLite.h"

@implementation LDOHairlineBorderViewLite {
    NSNumber *__horizontalHairlineInset;
    NSNumber *__verticalHairlineInset;
    
    NSNumber *__topHairlineInset;
    NSNumber *__topHairlineLeftInset;
    NSNumber *__topHairlineRightInset;
    
    NSNumber *__bottomHairlineInset;
    NSNumber *__bottomHairlineLeftInset;
    NSNumber *__bottomHairlineRightInset;
    
    NSNumber *__leftHairlineInset;
    NSNumber *__leftHairlineTopInset;
    NSNumber *__leftHairlineBottomInset;
    
    NSNumber *__rightHairlineInset;
    NSNumber *__rightHairlineTopInset;
    NSNumber *__rightHairlineBottomInset;
}

@synthesize topHairlineColor = _topHairlineColor;
@synthesize bottomHairlineColor = _bottomHairlineColor;
@synthesize leftHairlineColor = _leftHairlineColor;
@synthesize rightHairlineColor = _rightHairlineColor;

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Ensure the line doesn't get stretched during animations
    self.contentMode = UIViewContentModeRedraw;
}

- (CGSize)intrinsicContentSize
{
    // Ensure a valid layout without having to specify height constraints.
    // Unfortunately Interface Builder does not read this value and one has
    // to set a placeholder intrinsic content size to stop it complaining.
    return CGSizeMake(1, 1);
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat hairlineWidth = 1.0 / [UIScreen mainScreen].scale;
    
    // Offset hairlines by half their width to align them with full pixels - see http://stackoverflow.com/questions/12878781
    CGFloat offset = hairlineWidth / 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, hairlineWidth);
    
    if (self.topHairline) {
        CGContextSetStrokeColorWithColor(context, self.topHairlineColor.CGColor);
        [self drawHorizontalHairlineAtY:(0 + offset)
                              leftInset:[self effectiveTopHairlineLeftInset]
                             rightInset:[self effectiveTopHairlineRightInset]
                                context:context];
        CGContextStrokePath(context);
    }
    
    if (self.bottomHairline) {
        CGContextSetStrokeColorWithColor(context, self.bottomHairlineColor.CGColor);
        [self drawHorizontalHairlineAtY:(CGRectGetMaxY(self.bounds) - offset)
                              leftInset:[self effectiveBottomHairlineLeftInset]
                             rightInset:[self effectiveBottomHairlineRightInset]
                                context:context];
        CGContextStrokePath(context);
    }
    
    if (self.leftHairline) {
        CGContextSetStrokeColorWithColor(context, self.leftHairlineColor.CGColor);
        [self drawVerticalHairlineAtX:(0 + offset)
                             topInset:[self effectiveLeftHairlineTopInset]
                          bottomInset:[self effectiveLeftHairlineBottomInset]
                              context:context];
        CGContextStrokePath(context);
    }
    
    if (self.rightHairline) {
        CGContextSetStrokeColorWithColor(context, self.rightHairlineColor.CGColor);
        [self drawVerticalHairlineAtX:(CGRectGetMaxX(self.bounds) - offset)
                             topInset:[self effectiveRightHairlineTopInset]
                          bottomInset:[self effectiveRightHairlineBottomInset]
                              context:context];
        CGContextStrokePath(context);
    }
}

- (void)drawHorizontalHairlineAtY:(CGFloat)y leftInset:(CGFloat)leftInset rightInset:(CGFloat)rightInset context:(CGContextRef)context
{
    CGContextMoveToPoint(context, leftInset, y);
    CGContextAddLineToPoint(context, self.bounds.size.width - rightInset, y);
}

- (void)drawVerticalHairlineAtX:(CGFloat)x topInset:(CGFloat)topInset bottomInset:(CGFloat)bottomInset context:(CGContextRef)context
{
    CGContextMoveToPoint(context, x, topInset);
    CGContextAddLineToPoint(context, x, self.bounds.size.height - bottomInset);
}

#pragma mark - Properties

#pragma mark Color

- (void)setHairlineColor:(UIColor *)color
{ _hairlineColor = color; [self setNeedsDisplay]; }

- (UIColor *)topHairlineColor
{ return _topHairlineColor ?: _hairlineColor; }

- (UIColor *)bottomHairlineColor
{ return _bottomHairlineColor ?: _hairlineColor; }

- (UIColor *)leftHairlineColor
{ return _leftHairlineColor ?: _hairlineColor; }

- (UIColor *)rightHairlineColor
{ return _rightHairlineColor ?: _hairlineColor; }

- (void)setTopHairlineColor:(UIColor *)color
{ _topHairlineColor = color; [self setNeedsDisplay]; }

- (void)setBottomHairlineColor:(UIColor *)color
{ _bottomHairlineColor = color; [self setNeedsDisplay]; }

- (void)setLeftHairlineColor:(UIColor *)color
{ _leftHairlineColor = color; [self setNeedsDisplay]; }

- (void)setRightHairlineColor:(UIColor *)color
{ _rightHairlineColor = color; [self setNeedsDisplay]; }

#pragma mark Active

- (void)setTopHairline:(BOOL)topHairline
{ _topHairline = topHairline; [self setNeedsDisplay]; }

- (void)setBottomHairline:(BOOL)bottomHairline
{ _bottomHairline = bottomHairline; [self setNeedsDisplay]; }

- (void)setLeftHairline:(BOOL)leftHairline
{ _leftHairline = leftHairline; [self setNeedsDisplay]; }

- (void)setRightHairline:(BOOL)rightHairline
{ _rightHairline = rightHairline; [self setNeedsDisplay]; }

#pragma mark Top

- (CGFloat)effectiveTopHairlineLeftInset
{ return (__topHairlineLeftInset ?: __topHairlineInset ?: __horizontalHairlineInset).doubleValue; }

- (CGFloat)topHairlineLeftInset
{ return __topHairlineLeftInset.doubleValue; }

- (void)setTopHairlineLeftInset:(CGFloat)inset
{ __topHairlineLeftInset = @(inset); [self setNeedsDisplay]; }

- (CGFloat)effectiveTopHairlineRightInset
{ return (__topHairlineRightInset ?: __topHairlineInset ?: __horizontalHairlineInset).doubleValue; }

- (CGFloat)topHairlineRightInset
{ return __topHairlineRightInset.doubleValue; }

- (void)setTopHairlineRightInset:(CGFloat)inset
{ __topHairlineRightInset = @(inset); [self setNeedsDisplay]; }

- (CGFloat)topHairlineInset
{ return __topHairlineInset.doubleValue; }

- (void)setTopHairlineInset:(CGFloat)inset
{ __topHairlineInset = @(inset); [self setNeedsDisplay]; }

#pragma mark Bottom

- (CGFloat)effectiveBottomHairlineLeftInset
{ return (__bottomHairlineLeftInset ?: __bottomHairlineInset ?: __horizontalHairlineInset).doubleValue; }

- (CGFloat)bottomHairlineLeftInset
{ return __bottomHairlineLeftInset.doubleValue; }

- (void)setBottomHairlineLeftInset:(CGFloat)inset
{ __bottomHairlineLeftInset = @(inset); [self setNeedsDisplay]; }

- (CGFloat)effectiveBottomHairlineRightInset
{ return (__bottomHairlineRightInset ?: __bottomHairlineInset ?: __horizontalHairlineInset).doubleValue; }

- (CGFloat)bottomHairlineRightInset
{ return __bottomHairlineRightInset.doubleValue; }

- (void)setBottomHairlineRightInset:(CGFloat)inset
{ __bottomHairlineRightInset = @(inset); [self setNeedsDisplay]; }

- (CGFloat)bottomHairlineInset
{ return __bottomHairlineInset.doubleValue; }

- (void)setBottomHairlineInset:(CGFloat)inset
{ __bottomHairlineInset = @(inset); [self setNeedsDisplay]; }

#pragma mark Left

- (CGFloat)effectiveLeftHairlineTopInset
{ return (__leftHairlineTopInset ?: __leftHairlineInset ?: __verticalHairlineInset).doubleValue; }

- (CGFloat)leftHairlineTopInset
{ return  __leftHairlineTopInset.doubleValue; }

- (void)setLeftHairlineTopInset:(CGFloat)inset
{ __leftHairlineTopInset = @(inset); [self setNeedsDisplay]; }

- (CGFloat)effectiveLeftHairlineBottomInset
{ return (__leftHairlineBottomInset ?: __leftHairlineInset ?: __verticalHairlineInset).doubleValue; }

- (CGFloat)leftHairlineBottomInset
{ return __leftHairlineBottomInset.doubleValue; }

- (void)setLeftHairlineBottomInset:(CGFloat)inset
{ __leftHairlineBottomInset = @(inset); [self setNeedsDisplay]; }

- (CGFloat)leftHairlineInset
{ return __leftHairlineInset.doubleValue; }

- (void)setLeftHairlineInset:(CGFloat)inset
{ __leftHairlineInset = @(inset); [self setNeedsDisplay]; }

#pragma mark Right

- (CGFloat)effectiveRightHairlineTopInset
{ return (__rightHairlineTopInset ?: __rightHairlineInset ?: __verticalHairlineInset).doubleValue; }

- (CGFloat)rightHairlineTopInset
{ return __rightHairlineTopInset.doubleValue; }

- (void)setRightHairlineTopInset:(CGFloat)inset
{ __rightHairlineTopInset = @(inset); [self setNeedsDisplay]; }

- (CGFloat)effectiveRightHairlineBottomInset
{ return (__rightHairlineBottomInset ?: __rightHairlineInset ?: __verticalHairlineInset).doubleValue; }

- (CGFloat)rightHairlineBottomInset
{ return __rightHairlineBottomInset.doubleValue; }

- (void)setRightHairlineBottomInset:(CGFloat)inset
{ __rightHairlineBottomInset = @(inset); [self setNeedsDisplay]; }

- (CGFloat)rightHairlineInset
{ return __rightHairlineInset.doubleValue; }

- (void)setRightHairlineInset:(CGFloat)inset
{ __rightHairlineInset = @(inset); [self setNeedsDisplay]; }

#pragma mark General

- (CGFloat)horizontalHairlineInset
{ return __horizontalHairlineInset.doubleValue; }

- (void)setHorizontalHairlineInset:(CGFloat)inset
{ __horizontalHairlineInset = @(inset); [self setNeedsDisplay]; }

- (CGFloat)verticalHairlineInset
{ return __verticalHairlineInset.doubleValue; }

- (void)setVerticalHairlineInset:(CGFloat)inset
{ __verticalHairlineInset = @(inset); [self setNeedsDisplay]; }

@end
