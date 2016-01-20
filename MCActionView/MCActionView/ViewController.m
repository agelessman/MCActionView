//
//  ViewController.m
//  MCActionView
//
//  Created by 马超 on 16/1/20.
//  Copyright © 2016年 ma. All rights reserved.
//

#import "ViewController.h"
#import "MCActionView.h"

#define QKYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


@interface ViewController ()
@property (nonatomic,copy)NSArray *one;
@property (nonatomic,copy)NSArray *two;
@property (nonatomic,copy)NSArray *three;
@property (nonatomic,copy)NSArray *four;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setData];
}

- (IBAction)one:(id)sender {
    
    MCActionView *ac = [[MCActionView alloc ]initWithAttributeStringArray:self.one];
    [ac show];
    __block typeof(ac) weakAc = ac;
    ac.actionReturnBlock = ^(MCActionView *actionView , NSInteger index ){
        [weakAc dismiss];
       NSLog(@" ===index:%ld ==== sting:%@",(long)index,actionView.attArrays[index]);
    };
}
- (IBAction)two:(id)sender {
    
    MCActionView *ac = [[MCActionView alloc ]initWithAttributeStringArray:self.two];
    ac.headStr = @"我是个标题哦";
    [ac show];
    
    __block typeof(ac) weakAc = ac;
    ac.actionReturnBlock = ^(MCActionView *actionView , NSInteger index ){
        [weakAc dismiss];
        NSLog(@" ===index:%ld ==== sting:%@",(long)index,actionView.attArrays[index]);
    };
}
- (IBAction)three:(id)sender {
    MCActionView *ac = [[MCActionView alloc ]initWithAttributeStringArray:self.three];
    [ac show];
    __block typeof(ac) weakAc = ac;
    ac.actionReturnBlock = ^(MCActionView *actionView , NSInteger index ){
        [weakAc dismiss];
        NSLog(@" ===index:%ld ==== sting:%@",(long)index,actionView.attArrays[index]);
    };
    
}

- (IBAction)four:(id)sender {
    MCActionView *ac = [[MCActionView alloc ]initWithAttributeStringArray:self.four];
    ac.showType = ShowTypeAlert;
    [ac show];
    __block typeof(ac) weakAc = ac;
    ac.actionReturnBlock = ^(MCActionView *actionView , NSInteger index ){
        [weakAc dismiss];
        NSLog(@" ===index:%ld ==== sting:%@",(long)index,actionView.attArrays[index]);
    };
}

- (void)setData
{
    NSMutableAttributedString *net = [[NSMutableAttributedString alloc] initWithString:@"网络电话" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16] , NSForegroundColorAttributeName:QKYColor(70, 70, 70)}];
    NSAttributedString *att = [[NSAttributedString alloc ]initWithString:@"需要双方都在线,纯网络电话,在WIFI下使用效果更佳" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:QKYColor(150, 150, 150)}];
    [net appendAttributedString:[[NSAttributedString alloc ]initWithString:@"\n"]];
    [net appendAttributedString:att];
    
    
    NSMutableAttributedString *netDir = [[NSMutableAttributedString alloc] initWithString:@"网络直拨" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16] , NSForegroundColorAttributeName:QKYColor(70, 70, 70)}];
    NSAttributedString *att1 = [[NSAttributedString alloc ]initWithString:@"主叫方需要良好的网络环境,(如4G WIFI) 在WIFI下使用效果更佳" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:QKYColor(150, 150, 150)}];
    [netDir appendAttributedString:[[NSAttributedString alloc ]initWithString:@"\n"]];
    [netDir appendAttributedString:att1];
    
    NSMutableAttributedString *dou = [[NSMutableAttributedString alloc] initWithString:@"双向回拨" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16] , NSForegroundColorAttributeName:QKYColor(70, 70, 70)}];
    NSAttributedString *att2 = [[NSAttributedString alloc ]initWithString:@"成功发起呼叫后,会收到系统来电,接听后向对方发起呼叫.接通后无需网络." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:QKYColor(150, 150, 150)}];
    [dou appendAttributedString:[[NSAttributedString alloc ]initWithString:@"\n"]];
    [dou appendAttributedString:att2];
    
    NSMutableAttributedString *sys = [[NSMutableAttributedString alloc] initWithString:@"系统拨号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16] , NSForegroundColorAttributeName:QKYColor(70, 70, 70)}];
    NSAttributedString *att3 = [[NSAttributedString alloc ]initWithString:@"使用手机系统拨号 (自费)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:QKYColor(150, 150, 150)}];
    [sys appendAttributedString:[[NSAttributedString alloc ]initWithString:@"\n"]];
    [sys appendAttributedString:att3];
    
    self.one = @[net,netDir,dou,sys];
    self.two = @[net,netDir,dou,sys];
    self.three = @[net,netDir,dou,sys,net,netDir,dou,sys,net,netDir,dou,sys,net,netDir,dou,sys,net,netDir,dou,sys];
    self.four = @[net,netDir,dou];
}



@end
