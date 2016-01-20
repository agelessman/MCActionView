//
//  UIView+MCAction.h
//  qikeyun
//
//  Created by 马超 on 16/1/19.
//  Copyright © 2016年 Jerome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MCDP)

+ (UIColor *) MC_colorWithHex:(NSUInteger)hex;

@end

@interface UIView (MCAction)

@property (nonatomic, strong, readonly) UIView         *MC_dissmissBackgroundView;
@property (nonatomic, assign, readonly) BOOL           MC_dissmissBackgroundAnimating;
@property (nonatomic, assign          ) NSTimeInterval MC_dissmissAnimationDuration;

- (void) MC_showDissmissBackground;
- (void) MC_hideDissmissBackground;

- (void) MC_distributeSpacingHorizontallyWith:(NSArray*)views;
- (void) MC_distributeSpacingVerticallyWith:(NSArray*)views;
@end
