//
//  UIView+MCAction.m
//  qikeyun
//
//  Created by 马超 on 16/1/19.
//  Copyright © 2016年 Jerome. All rights reserved.
//

#import "UIView+MCAction.h"
#import "MCActionDefine.h"
#import <objc/runtime.h>


@implementation UIColor (MCDP)

+ (UIColor *) MC_colorWithHex:(NSUInteger)hex {
    
    float r = (hex & 0xff000000) >> 24;
    float g = (hex & 0x00ff0000) >> 16;
    float b = (hex & 0x0000ff00) >> 8;
    float a = (hex & 0x000000ff);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

@end


static const void *MC_dissmissReferenceCountKey      = &MC_dissmissReferenceCountKey;

static const void *MC_dissmissBackgroundViewKey      = &MC_dissmissBackgroundViewKey;
static const void *MC_dissmissAnimationDurationKey   = &MC_dissmissAnimationDurationKey;
static const void *MC_dissmissBackgroundAnimatingKey = &MC_dissmissBackgroundAnimatingKey;


@interface UIView (MCPick)

@property (nonatomic, assign, readwrite) NSInteger MC_dissmissReferenceCount;

@end

@implementation UIView (MCPick)

@dynamic MC_dissmissReferenceCount;


- (NSInteger)MC_dissmissReferenceCount {
    return [objc_getAssociatedObject(self, MC_dissmissReferenceCountKey) integerValue];
}

- (void)setMC_dissmissReferenceCount:(NSInteger)MC_dissmissReferenceCount
{
    objc_setAssociatedObject(self, MC_dissmissReferenceCountKey, @(MC_dissmissReferenceCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end



@implementation UIView (MCAction)

@dynamic MC_dissmissBackgroundView;
@dynamic MC_dissmissAnimationDuration;
@dynamic MC_dissmissBackgroundAnimating;


- (UIView *)MC_dissmissBackgroundView
{
    UIView *dimView = objc_getAssociatedObject(self, MC_dissmissBackgroundViewKey);
    
    if ( !dimView )
    {
        dimView = [UIView new];
        [self addSubview:dimView];
        dimView.frame = self.frame;
        dimView.hidden = YES;
        
        self.MC_dissmissAnimationDuration = 0.3f;
        
        objc_setAssociatedObject(self, MC_dissmissBackgroundViewKey, dimView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dimView;
}

- (BOOL)MC_dissmissBackgroundAnimating
{
    return [objc_getAssociatedObject(self, MC_dissmissBackgroundViewKey) boolValue];
}

- (void)setMC_dissmissBackgroundAnimating:(BOOL)MC_dissmissBackgroundAnimating
{
    objc_setAssociatedObject(self, MC_dissmissBackgroundAnimatingKey, @(MC_dissmissBackgroundAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)MC_dissmissAnimationDuration
{
    return [objc_getAssociatedObject(self, MC_dissmissAnimationDurationKey) doubleValue];
}

- (void)setMC_dissmissAnimationDuration:(NSTimeInterval)MC_dissmissAnimationDuration
{
    objc_setAssociatedObject(self, MC_dissmissAnimationDurationKey, @(MC_dissmissAnimationDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)MC_showDissmissBackground
{
    ++self.MC_dissmissReferenceCount;
    
    if ( self.MC_dissmissReferenceCount > 1 )
    {
        return;
    }
    
    self.MC_dissmissBackgroundView.hidden = NO;
    self.MC_dissmissBackgroundAnimating = YES;
    
    if ( [self isKindOfClass:[UIWindow class]] )
    {
        self.hidden = NO;
        [(UIWindow*)self makeKeyAndVisible];
    }
    else
    {
        [self bringSubviewToFront:self.MC_dissmissBackgroundView];
    }
    
    [UIView animateWithDuration:self.MC_dissmissAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.MC_dissmissBackgroundView.backgroundColor = MCcHexColor(0x0000007F);
                         
                     } completion:^(BOOL finished) {
                         
                         if ( finished )
                         {
                             self.MC_dissmissBackgroundAnimating = NO;
                             
                             
                         }
                         
                     }];
}

- (void)MC_hideDissmissBackground
{
    --self.MC_dissmissReferenceCount;
    
    if ( self.MC_dissmissReferenceCount > 0 )
    {
        return;
    }
    
    self.MC_dissmissBackgroundAnimating = YES;
    [UIView animateWithDuration:self.MC_dissmissAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.MC_dissmissBackgroundView.backgroundColor = MCcHexColor(0x00000000);
                         
                     } completion:^(BOOL finished) {
                         
                         if ( finished )
                         {
                             self.MC_dissmissBackgroundView.hidden = YES;
                             self.MC_dissmissBackgroundAnimating = NO;
                             
                             if ( [self isKindOfClass:[UIWindow class]] )
                             {
                                 self.hidden = YES;
                                 [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
                             }
                         }
                     }];
}

- (void) MC_distributeSpacingHorizontallyWith:(NSArray *)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        //设置宽和高相同
        [NSLayoutConstraint
         constraintWithItem:v
         attribute:NSLayoutAttributeWidth
         relatedBy:NSLayoutRelationEqual
         toItem: v
         attribute:NSLayoutAttributeHeight
         multiplier:1.0f
         constant:0];
    }
    
    UIView *v0 = spaces[0];
    
    [NSLayoutConstraint
     constraintWithItem:v0
     attribute:NSLayoutAttributeLeft
     relatedBy:NSLayoutRelationEqual
     toItem: self
     attribute:NSLayoutAttributeLeft
     multiplier:1.0f
     constant:0];
    
    [NSLayoutConstraint
     constraintWithItem:v0
     attribute:NSLayoutAttributeCenterY
     relatedBy:NSLayoutRelationEqual
     toItem: (UIView*)views[0]
     attribute:NSLayoutAttributeCenterY
     multiplier:1.0f
     constant:0];
    
    
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [NSLayoutConstraint
         constraintWithItem:obj
         attribute:NSLayoutAttributeLeft
         relatedBy:NSLayoutRelationEqual
         toItem: lastSpace
         attribute:NSLayoutAttributeRight
         multiplier:1.0f
         constant:0];
        
        
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeLeft
         relatedBy:NSLayoutRelationEqual
         toItem: obj
         attribute:NSLayoutAttributeRight
         multiplier:1.0f
         constant:0];
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeCenterY
         relatedBy:NSLayoutRelationEqual
         toItem: obj
         attribute:NSLayoutAttributeCenterY
         multiplier:1.0f
         constant:0];
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeWidth
         relatedBy:NSLayoutRelationEqual
         toItem: v0
         attribute:NSLayoutAttributeWidth
         multiplier:1.0f
         constant:0];
        
        
        
        lastSpace = space;
    }
    
    [NSLayoutConstraint
     constraintWithItem:lastSpace
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem: self
     attribute:NSLayoutAttributeRight
     multiplier:1.0f
     constant:0];
    
    
    
}

- (void) MC_distributeSpacingVerticallyWith:(NSArray *)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [NSLayoutConstraint
         constraintWithItem:v
         attribute:NSLayoutAttributeWidth
         relatedBy:NSLayoutRelationEqual
         toItem: v
         attribute:NSLayoutAttributeHeight
         multiplier:1.0f
         constant:0];
        
        
    }
    
    UIView *v0 = spaces[0];
    
    [NSLayoutConstraint
     constraintWithItem:v0
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem: self
     attribute:NSLayoutAttributeTop
     multiplier:1.0f
     constant:0];
    [NSLayoutConstraint
     constraintWithItem:v0
     attribute:NSLayoutAttributeCenterX
     relatedBy:NSLayoutRelationEqual
     toItem: (UIView*)views[0]
     attribute:NSLayoutAttributeCenterX
     multiplier:1.0f
     constant:0];
    
    
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [NSLayoutConstraint
         constraintWithItem:obj
         attribute:NSLayoutAttributeTop
         relatedBy:NSLayoutRelationEqual
         toItem: lastSpace
         attribute:NSLayoutAttributeBottom
         multiplier:1.0f
         constant:0];
        
        
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeTop
         relatedBy:NSLayoutRelationEqual
         toItem: obj
         attribute:NSLayoutAttributeBottom
         multiplier:1.0f
         constant:0];
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeCenterX
         relatedBy:NSLayoutRelationEqual
         toItem: obj
         attribute:NSLayoutAttributeCenterX
         multiplier:1.0f
         constant:0];
        [NSLayoutConstraint
         constraintWithItem:space
         attribute:NSLayoutAttributeHeight
         relatedBy:NSLayoutRelationEqual
         toItem: v0
         attribute:NSLayoutAttributeHeight
         multiplier:1.0f
         constant:0];
        
        
        lastSpace = space;
    }
    
    [NSLayoutConstraint
     constraintWithItem:lastSpace
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
     toItem: self
     attribute:NSLayoutAttributeBottom
     multiplier:1.0f
     constant:0];
    
    
    
    
}
@end
