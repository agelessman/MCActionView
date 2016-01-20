//
//  MCActionView.m
//  qikeyun
//
//  Created by 马超 on 16/1/19.
//  Copyright © 2016年 Jerome. All rights reserved.
//

#import "MCActionView.h"
#import "MCWindow.h"
#import "UIView+MCAction.h"
#import "MCActionDefine.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

#define maxHeight screenH - 100

@class MCACtionCell;
@protocol MCACtionCellDelegate <NSObject>

- (void)cell:(MCACtionCell *)cell didClickedCellForIndexPath:(NSIndexPath *)indexPath;

@end

@interface MCACtionCell :UITableViewCell
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,assign)id <MCACtionCellDelegate> delegate;
@end
@implementation MCACtionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        self.label = label;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
        [self.contentView addSubview:line];
        self.line = line;
        
        UIButton *cover = [[UIButton alloc] init];
        [cover addTarget:self action:@selector(coverAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cover];
        cover.frame = self.frame;
    }
    
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = CGRectMake(10, 10, screenW - 20, self.bounds.size.height - 20);
    self.line.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

- (void)coverAction
{
    if ([self.delegate respondsToSelector:@selector(cell:didClickedCellForIndexPath:)]) {
        [self.delegate cell:self didClickedCellForIndexPath:self.indexPath];
    }
}
@end


@interface MCActionView () <UITableViewDelegate,UITableViewDataSource,MCACtionCellDelegate>
@property (nonatomic,strong)UILabel *head;
@end
@implementation MCActionView

- (instancetype)initWithAttributeStringArray:(NSArray *)attArrays
{
    
    self.cancelTopMargin        = 4;
    self.cellTopAndBottomMargin = 10;
    self.attArrays              = attArrays;
    [self initHeight];
    self = [super initWithFrame:self.frame];
    if (self) {
        
        self.exclusiveTouch = YES;
        self.backgroundColor = [UIColor clearColor];
       

        self.showAnimation     = [self sheetShowAnimation];
        self.hideAnimation     = [self sheetHideAnimation];
        self.animationDuration = 0.3f;
        self.touchWildToHide   = YES;
        
        
       
        [self initHeadLabel];
        [self initCancelLabel];
        [self initTableView];
        
        [self updateSubviewLayout];

      
    }
    
    return self;
}


#pragma mark init tableView

- (void)initHeight
{
    //计算可变字符串的高度
    
    CGFloat totalHeight = 0;
    
    for (int i = 0; i < self.attArrays.count; i++) {
        
        NSAttributedString *temp = self.attArrays[i];
        CGRect rect = [temp boundingRectWithSize:CGSizeMake(screenW - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        totalHeight += rect.size.height + 20;
    }
    
    totalHeight += 45  + self.cancelTopMargin + [self getHeadHeight];
    
    if (totalHeight > maxHeight) {
        
        totalHeight = maxHeight;
        self.talbleView.scrollEnabled = YES;
    }else{
        self.talbleView.scrollEnabled = NO;
    }
    CGRect temp          = CGRectMake(0, screenH - totalHeight, screenW, totalHeight);
    self.frame           = temp;
    
}
- (void)initTableView
{
    self.talbleView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.talbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.talbleView.delegate = self;
    self.talbleView.dataSource = self;
    [self addSubview:self.talbleView];
    

}
- (void)initCancelLabel
{
    UIButton *label = [[UIButton alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    [label setTitle:@"取消" forState:UIControlStateNormal];
    label.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [label setTitleColor:[UIColor colorWithWhite:0.400 alpha:1.000] forState:UIControlStateNormal];
    [label addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:label];
    self.cancelBtn = label;
}

- (void)initHeadLabel
{
    UILabel *head = [[UILabel alloc] init];
    head.textColor = [UIColor colorWithWhite:0.700 alpha:1.000];
    head.font = [UIFont systemFontOfSize:14.0];
    head.backgroundColor = [UIColor whiteColor];
    head.textAlignment = NSTextAlignmentCenter;
    [self addSubview:head];
    self.head = head;
}

#pragma  mark setter


#pragma mark private
- (void)updateSubviewLayout
{
    [self initHeight];
    self.head.frame = CGRectMake(0, 0, screenW, [self getHeadHeight]);
    self.talbleView.frame = CGRectMake(0, CGRectGetMaxY(self.head.frame), screenW, self.bounds.size.height - 45 - self.cancelTopMargin - self.head.bounds.size.height );
    self.cancelBtn.frame = CGRectMake(0, self.bounds.size.height - 45 , screenW, 45);
    
    self.head.text = self.headStr;
   
   
    [self setNeedsLayout];
   
}

- (CGFloat)getHeadHeight
{
    CGFloat headHeight = 0;
    if (self.headStr.length) {
        headHeight = 30;
    }else{
        headHeight = 10;
    }
    return headHeight;
}
- (void)setHeadStr:(NSString *)headStr
{
    _headStr = headStr;
    
}
- (void)setShowType:(ShowType)showType
{
    _showType = showType;
    if (showType == ShowTypeSheet) {
        self.showAnimation     = [self sheetShowAnimation];
        self.hideAnimation     = [self sheetHideAnimation];
    }else{
        self.showAnimation     = [self alertShowAnimation];
        self.hideAnimation     = [self alertHideAnimation];
    }
}
- (void)show
{
    [self updateSubviewLayout];
    [self.talbleView reloadData];
    [self showWithBlock:nil];
}

- (void)showWithBlock:(MCActionBlock)block
{
    if ( block )
    {
        self.showCompletionBlock = block;
    }
    
    if ( !self.attachedView )
    {
        self.attachedView = [MCWindow sharedWindow];
    }
    [self.attachedView MC_showDissmissBackground];
    

    
    if (self.touchWildToHide) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.attachedView.MC_dissmissBackgroundView addGestureRecognizer:gesture];
    }

    
    self.showAnimation(self);
    
    
}
- (void)dismiss
{
    [self hideWithBlock:nil];
}

- (void)hideWithBlock:(MCActionBlock)block
{
    if ( block )
    {
        self.hideCompletionBlock = block;
    }
    
    if ( !self.attachedView )
    {
        self.attachedView = [MCWindow sharedWindow];
    }
    [self.attachedView MC_hideDissmissBackground];
    if (self.touchWildToHide) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.attachedView.MC_dissmissBackgroundView addGestureRecognizer:gesture];
    }
    
    self.hideAnimation(self);
}

- (MCActionBlock)sheetShowAnimation
{
    MCcWeakify(self);
    MCActionBlock block = ^(MCActionView *actionView){
        MCcStrongify(self);
        
        [self.attachedView.MC_dissmissBackgroundView addSubview:self];
        
        
        CGRect tempFrame = self.frame;
        tempFrame.origin.y = self.attachedView.frame.size.height;
        self.frame = tempFrame;
        
        CGPoint tempCenter = self.center;
        tempCenter.x = self.attachedView.center.x;
        self.center = tempCenter;
        
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             CGRect tempFrame = self.frame;
                             tempFrame.origin.y = self.attachedView.frame.size.height- tempFrame.size.height;
                             self.frame = tempFrame;
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MCActionBlock)sheetHideAnimation
{
    MCcWeakify(self);
    MCActionBlock block = ^(MCActionView *actionView){
        MCcStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             CGRect tempFrame = self.frame;
                             tempFrame.origin.y = self.attachedView.frame.size.height;
                             self.frame = tempFrame;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MCActionBlock)alertShowAnimation
{
    MCcWeakify(self);
    MCActionBlock block = ^(MCActionView *actionView){
        MCcStrongify(self);
        
        [self.attachedView.MC_dissmissBackgroundView addSubview:self];
        
        
        CGPoint tempCenter = self.center;
        tempCenter.x = self.attachedView.center.x;
        tempCenter.y = self.attachedView.center.y;
        self.center = tempCenter;
        
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MCActionBlock)alertHideAnimation
{
    MCcWeakify(self);
    MCActionBlock block = ^(MCActionView *actionView){
        MCcStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}


#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attArrays.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString *temp = self.attArrays[indexPath.row];
    CGRect rect = [temp boundingRectWithSize:CGSizeMake(screenW - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size.height + 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MCActionCell";
    MCACtionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( cell == nil) {
        cell = [[MCACtionCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
     NSAttributedString *temp = self.attArrays[indexPath.row];
    cell.label.attributedText = temp;
    cell.indexPath = indexPath;
    
    return cell;
}
- (void)cell:(MCACtionCell *)cell didClickedCellForIndexPath:(NSIndexPath *)indexPath
{
    if (self.actionReturnBlock) {
        self.actionReturnBlock(self,indexPath.row);
    }
}
@end
