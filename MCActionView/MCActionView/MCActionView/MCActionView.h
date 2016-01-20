//
//  MCActionView.h
//  qikeyun
//
//  Created by 马超 on 16/1/19.
//  Copyright © 2016年 Jerome. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MCActionView;

typedef enum : NSUInteger {
    ShowTypeSheet,
    ShowTypeAlert
} ShowType;

typedef void(^MCActionBlock)(MCActionView *);
typedef void(^MCActionReturnBlock)(MCActionView *,NSInteger);





@interface MCActionView : UIView

///主要显示的view
@property (nonatomic,strong)UITableView *talbleView;
@property (nonatomic,strong)UIButton *cancelBtn;
/// 数组
@property (nonatomic,strong)NSArray *attArrays;

@property (nonatomic, assign) BOOL touchWildToHide;//default is YES



@property (nonatomic, strong) UIView         *attachedView;       // default is MCWindow. You can attach attachedView to any UIView.

//动画的处理
@property (nonatomic, copy) MCActionBlock   showCompletionBlock; // show completion block.
@property (nonatomic, copy) MCActionBlock   hideCompletionBlock; // hide completion block

@property (nonatomic, copy) MCActionBlock   showAnimation;       // custom show animation block.
@property (nonatomic, copy) MCActionBlock   hideAnimation;       // custom hide animation block.
@property (nonatomic, assign) NSTimeInterval animationDuration;   // default is 0.3
@property (nonatomic, assign) ShowType showType;   // default is ShowTypeSheet



@property (nonatomic,assign)CGFloat cancelTopMargin; // default is 5
@property (nonatomic,assign)CGFloat cellTopAndBottomMargin; // default is 10
@property (nonatomic,copy)NSString *headStr; // default is nil


@property (nonatomic,copy)MCActionReturnBlock actionReturnBlock;




///创建方法
- (instancetype)initWithAttributeStringArray:(NSArray *)attArrays;
- (void)show;
- (void)dismiss;
@end
