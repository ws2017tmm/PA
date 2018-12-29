//
//  PANextStepView.m
//  PAFinance
//
//  Created by 李响 on 2018/12/29.
//  Copyright © 2018 StevenWu. All rights reserved.
//

#import "PANextStepView.h"

@interface PANextStepView ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (strong, nonatomic) NSArray *labelList;

@end

@implementation PANextStepView

- (NSArray *)labelList {
    if (_labelList == nil) {
        _labelList = @[_label1, _label2, _label3];
    }
    return _labelList;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setIndex:(NSUInteger)index {
    _index = index;
    
    // 更换背景色
    [self.labelList enumerateObjectsUsingBlock:^(UILabel *  _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            label.backgroundColor = WSColor(133, 199, 253);
        } else {
            label.backgroundColor = UIColor.lightGrayColor;
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置圆角
    [self.labelList enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.layer.cornerRadius = label.ws_width * 0.5;
        label.layer.masksToBounds = YES;
    }];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
