//
//  LDOHairlineBorderViewLite.h
//  LDOHairlineBorderView
//
//  Created by Sebastian Ludwig on 03.02.19.
//

#import <UIKit/UIKit.h>

@interface LDOHairlineBorderViewLite : UIView

@property (nonatomic, nullable) IBInspectable UIColor *hairlineColor;

/// Sets left and right insets of top and bottom hairlines.
/// Retunrs the minimum of the left and right insets of the top and bottom hairlines.
@property (nonatomic) IBInspectable CGFloat horizontalHairlineInset;
/// Sets the top and bottom insets of the left and right hairlines.
/// Returns the minimum of the top and bottom insets of the left and right hairlines.
@property (nonatomic) IBInspectable CGFloat verticalHairlineInset;

@property (nonatomic) IBInspectable BOOL topHairline;
@property (nonatomic) IBInspectable BOOL bottomHairline;
@property (nonatomic) IBInspectable BOOL leftHairline;
@property (nonatomic) IBInspectable BOOL rightHairline;

@property (nonatomic, nullable) UIColor *topHairlineColor;
/// Sets left and right inset of top hairline.
/// Returns the minimun of the left and right inset.
@property (nonatomic) CGFloat topHairlineInset;
@property (nonatomic) CGFloat topHairlineLeftInset;
@property (nonatomic) CGFloat topHairlineRightInset;

@property (nonatomic, nullable) UIColor *bottomHairlineColor;
/// Sets left and right inset of bottom hairline.
/// Returns the minimun of the left and right inset.
@property (nonatomic) CGFloat bottomHairlineInset;
@property (nonatomic) CGFloat bottomHairlineLeftInset;
@property (nonatomic) CGFloat bottomHairlineRightInset;

@property (nonatomic, nullable) UIColor *leftHairlineColor;
/// Sets top and bottom inset of left hairline.
/// Returns the minimun of the top and bottom inset.
@property (nonatomic) CGFloat leftHairlineInset;
@property (nonatomic) CGFloat leftHairlineTopInset;
@property (nonatomic) CGFloat leftHairlineBottomInset;

@property (nonatomic, nullable) UIColor *rightHairlineColor;
/// Sets top and bottom inset of right hairline.
/// Returns the minimun of the top and bottom inset.
@property (nonatomic) CGFloat rightHairlineInset;
@property (nonatomic) CGFloat rightHairlineTopInset;
@property (nonatomic) CGFloat rightHairlineBottomInset;

@end
