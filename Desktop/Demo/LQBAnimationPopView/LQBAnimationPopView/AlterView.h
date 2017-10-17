//
//  AlterView.h
//  ZJAnimationPopView
//
//  Created by 刘庆兵 on 2017/10/17.
//  Copyright © 2017年 Qingbing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlterView : UIView

@property (nonatomic, copy) void(^canceSureActionBlock)(BOOL isSure);
+ (instancetype)xib;
@end
