//
//  AlterView.m
//  ZJAnimationPopView
//
//  Created by 刘庆兵 on 2017/10/17.
//  Copyright © 2017年 Qingbing Liu. All rights reserved.
//

#import "AlterView.h"

@implementation AlterView

+ (instancetype)xib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 6.0f;
    self.layer.masksToBounds = YES;
}

- (IBAction)canceSureAction:(UIButton *)sender
{
    if (self.canceSureActionBlock) {
        self.canceSureActionBlock(sender.tag);
    }
}

@end
