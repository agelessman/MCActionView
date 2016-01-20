//
//  MCWindow.h
//  qikeyun
//
//  Created by 马超 on 16/1/19.
//  Copyright © 2016年 Jerome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCWindow : UIWindow
@property (nonatomic, assign) BOOL touchWildToHide; // default is YES. datePickView will be hidden when user touch the translucent background.

+ (MCWindow *)sharedWindow;

/**
 *  cache the window to prevent the lag of the first showing.
 */
- (void) cacheWindow;
@end
