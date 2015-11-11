//
//  CATMessageView.m
//  Catch
//
//  Created by 余林峰 on 15/7/11.
//  Copyright (c) 2015年 Entropy. All rights reserved.
//

#import "CATMessageView.h"
#import "Masonry.h"
#import "MacroDefinition.h"

@interface CATMessageView ()

@property (nonatomic,strong) UILabel* label;

@end

@implementation CATMessageView

- (instancetype)init{
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(1, 1, 1, 1);
        self.alpha = 1.0f;
        self.layer.masksToBounds = YES;
        
        _label = [[UILabel alloc]init];
        _label.textColor = RGBACOLOR(222, 222, 222, 1);
        _label.textAlignment = 1;
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    WS(weakSelf);
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(5, 20, 5, 20));
    }];
    
    [super layoutSubviews];
}

+ (void)showWithMessage:(NSString*)message{
    [CATMessageView showWithMessage:message type:CATMessageViewDefault];
}

+ (void)showWithMessage:(NSString*)message
                   type:(CATMessageViewType)type
{
    CATMessageView* messageView = [[CATMessageView alloc] init];
    switch (type) {
        case CATMessageViewDefault:
            messageView.backgroundColor = [UIColor blackColor];
            break;
        case CATMessageViewRed:
            messageView.backgroundColor = RGBACOLOR(253,113,118,1);
            break;
    }
    messageView.message = message;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSArray *windows = [UIApplication sharedApplication].windows;
    if(windows.count > 0) {
        window = [windows lastObject];
    }
    
    [window addSubview:messageView];
    
    NSInteger height = messageView.bounds.size.height;
    messageView.frame = CGRectMake(0, -height, SCREEN_WIDTH, height);
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        messageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3f delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
            messageView.frame = CGRectMake(0, -height, SCREEN_WIDTH, height);
        } completion:^(BOOL finished) {
            [messageView removeFromSuperview];
        }];
    }];
}

#pragma mark - Setter

-(void)setMessage:(NSString *)message{
    _message = message;
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:message?message:NSLocalizedString(@"Unknown error", nil) attributes:nil];
    CGSize LabelSize = [attr boundingRectWithSize:CGSizeMake(290, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
    NSInteger height = LabelSize.height + 10 > 40 ? LabelSize.height + 10 : 40;
    
    self.frame = CGRectMake(0, -height, SCREEN_WIDTH, height);
    
    _label.text = _message;
}

@end
