//
//  LDOHairlineBorderView.h
//  LDOHairlineBorderView
//
//  Created by Sebastian Ludwig on 02.02.19.
//  Copyright (c) 2019 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDOHairlineBorderViewLite.h"

@interface LDOHairlineBorderView : LDOHairlineBorderViewLite

@property (nonatomic, nullable) IBInspectable UIColor *topHairlineColor;
/// Sets left and right inset of top hairline.
/// Returns the minimun of the left and right inset.
@property (nonatomic) IBInspectable CGFloat topHairlineInset;
@property (nonatomic) IBInspectable CGFloat topHairlineLeftInset;
@property (nonatomic) IBInspectable CGFloat topHairlineRightInset;

@property (nonatomic, nullable) IBInspectable UIColor *bottomHairlineColor;
/// Sets left and right inset of bottom hairline.
/// Returns the minimun of the left and right inset.
@property (nonatomic) IBInspectable CGFloat bottomHairlineInset;
@property (nonatomic) IBInspectable CGFloat bottomHairlineLeftInset;
@property (nonatomic) IBInspectable CGFloat bottomHairlineRightInset;

@property (nonatomic, nullable) IBInspectable UIColor *leftHairlineColor;
/// Sets top and bottom inset of left hairline.
/// Returns the minimun of the top and bottom inset.
@property (nonatomic) IBInspectable CGFloat leftHairlineInset;
@property (nonatomic) IBInspectable CGFloat leftHairlineTopInset;
@property (nonatomic) IBInspectable CGFloat leftHairlineBottomInset;

@property (nonatomic, nullable) IBInspectable UIColor *rightHairlineColor;
/// Sets top and bottom inset of right hairline.
/// Returns the minimun of the top and bottom inset.
@property (nonatomic) IBInspectable CGFloat rightHairlineInset;
@property (nonatomic) IBInspectable CGFloat rightHairlineTopInset;
@property (nonatomic) IBInspectable CGFloat rightHairlineBottomInset;

@end
