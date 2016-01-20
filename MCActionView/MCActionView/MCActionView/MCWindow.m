//
//  MCWindow.m
//  qikeyun
//
//  Created by 马超 on 16/1/19.
//  Copyright © 2016年 Jerome. All rights reserved.
//

#import "MCWindow.h"
#import "UIView+MCAction.h"
#import "MCActionView.h"

@interface MCWindow ()
@property (nonatomic, assign) CGRect keyboardRect;
@end
@implementation MCWindow


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyKeyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        [self addGestureRecognizer:gesture];
        
        
    }
    return self;
}

+ (MCWindow *)sharedWindow
{
    static MCWindow *window;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        window = [[MCWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    });
    
    return window;
}

- (void)cacheWindow
{
    [self makeKeyAndVisible];
    [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
    
    self.hidden = YES;
}

- (void)actionTap:(UITapGestureRecognizer*)gesture
{
    if ( self.touchWildToHide && !self.MC_dissmissBackgroundAnimating )
    {
        for ( UIView *v in self.MC_dissmissBackgroundView.subviews )
        {
            if ( [v isKindOfClass:[MCActionView class]] )
            {
                MCActionView *popupView = (MCActionView*)v;
                [popupView dismiss];
            }
        }
    }
}

- (void)notifyKeyboardChangeFrame:(NSNotification *)n
{
    NSValue *keyboardBoundsValue = [[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    self.keyboardRect = [keyboardBoundsValue CGRectValue];
}


@end
