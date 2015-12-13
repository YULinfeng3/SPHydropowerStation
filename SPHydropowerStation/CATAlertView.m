//
//  CATAlertView.m
//  Catch
//
//  Created by Xinbao Dong on 15/6/7.
//  Copyright (c) 2015年 Entropy. All rights reserved.
//

#import "CATAlertView.h"
#import "MacroDefinition.h"
#import "UIFont+Catch.h"
#import "Masonry.h"

@interface CATAlertView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bkView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) void (^block)(id sender, NSInteger index);

@end

@implementation CATAlertView

- (instancetype)initWithTitle:(NSString *)title Message:(NSString *)message Hidden:(BOOL)hidden touchBlock:(void (^)(id sender, NSInteger index))block cancelButtonTitle:(NSString *)cancelTitle andButtonsTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bkView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _bkView.userInteractionEnabled = YES;
        [self addSubview:_bkView];
        if (hidden){
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
            [_bkView addGestureRecognizer:tap];
        }
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 100)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 2.5;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        if ([title length] != 0) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _titleLabel.text = title;
            _titleLabel.font = [UIFont fontWithStyle:CATFontStypeAlertTitle];
            _titleLabel.textColor = [UIColor blackColor];
            _titleLabel.numberOfLines = 0;
            [_contentView addSubview:_titleLabel];
        }
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font = [UIFont fontWithStyle:CATFontStypeRegularWords];
        _messageLabel.textColor = UIColorFromRGB(0x9B9B9B);
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.numberOfLines = 0;
        [_contentView addSubview:_messageLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch)];
        [_messageLabel addGestureRecognizer:tap];
        _messageLabel.userInteractionEnabled = YES;
        
        self.message = message;
        
        _buttonArray = [NSMutableArray new];
        
        if ([cancelTitle length] != 0) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.titleLabel.font = [UIFont fontWithStyle:CATFontStypeSubhead];
            [button setTitleColor:UIColorFromRGB(0x9B9B9B) forState:UIControlStateNormal];
            [button setTitle:cancelTitle forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            [_contentView addSubview:button];
        }
        
        va_list args;
        va_start(args, buttonTitle);
        for (NSString *str = buttonTitle; str != nil; str = va_arg(args, NSString *)) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.titleLabel.font = [UIFont fontWithStyle:CATFontStypeSubhead];
            //            [button setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button setTitle:str forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            [_contentView addSubview:button];
        }
        va_end(args);
        
        WS(weakSelf);
        
        [_bkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bkView.mas_left).with.offset(100);
            make.right.equalTo(weakSelf.bkView.mas_right).with.offset(-100);
            make.centerY.equalTo(weakSelf.bkView.mas_centerY);
        }];
        
        if (_titleLabel) {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.contentView.mas_left).with.offset(15);
                make.top.equalTo(weakSelf.contentView.mas_top).with.offset(15);
                make.right.greaterThanOrEqualTo(weakSelf.contentView.mas_right).with.offset(-15);
            }];
        }
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (weakSelf.titleLabel) {
                make.top.equalTo(weakSelf.titleLabel.mas_bottom).with.offset(15);
            }else {
                make.top.equalTo(weakSelf.contentView.mas_top).with.offset(15);
            }
            make.left.equalTo(weakSelf.contentView.mas_left).with.offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-15);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).with.offset(-75);
        }];
        
        UIButton *last = nil;
        for (UIButton *button in _buttonArray) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (last) {
                    make.right.equalTo(last.mas_left).with.offset(-20);
                }else {
                    make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-15);
                }
                make.bottom.equalTo(weakSelf.contentView.mas_bottom).with.offset(-15);
            }];
            last = button;
        }
        
        //        for (NSInteger i = 0; i < [_buttonArray count]; i ++) {
        //
        //            UIButton *btn = _buttonArray[i];
        //            btn.frame = CGRectMake(30 + i * (width + 20), _messageLabel.frame.size.height + _messageLabel.frame.origin.y + 30, width, 35);
        //        }
        //
        _block = block;
    }
    
    return self;
}

- (void)buttonPressed:(UIButton *)btn
{
    NSInteger index = [_buttonArray indexOfObject:btn];
    if (_block) {
        _block(self, index);
    }
    [self hide:nil];
}

- (void)setMessage:(NSString *)message
{
    _message = [message copy];
    _messageLabel.text = _message;
    [self setNeedsDisplay];
    //    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName: _messageLabel.font}];
    //    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(_messageLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    //    CGRect frame = _messageLabel.frame;
    //    frame.size.height = rect.size.height;
    //    _messageLabel.frame = frame;
    //    frame = _contentView.frame;
    //    frame.size.height = _messageLabel.frame.size.height + _messageLabel.frame.origin.y + 90;
    //    _contentView.frame = frame;
    //    _contentView.center = CGPointMake(SCREEN_WIDTH / 2., SCREEN_HEIGHT / 2.);
    //    for (NSInteger i = 0; i < [_buttonArray count]; i ++) {
    //        CGFloat width = (_contentView.frame.size.width - 60 - (_buttonArray.count - 1) * 20) / _buttonArray.count;
    //        width = (NSInteger)width / 1.0 + 0.5;
    //        UIButton *btn = _buttonArray[i];
    //        btn.frame = CGRectMake(30 + i * (width + 20), _messageLabel.frame.size.height + _messageLabel.frame.origin.y + 30, width, 35);
    //    }
}

- (void)show
{
    _bkView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.];
    _contentView.alpha = 0.;
    //    [[[[UIApplication sharedApplication] keyWindow] rootViewController].view addSubview:self];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    if(windows.count > 0) {
//        keyWindow = [windows lastObject];
//    }
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        _bkView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.3];
        _contentView.alpha = 1.;
    }];
}

- (void)hide:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.alpha = 0.;
        self.bkView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)onTouch{
    if (_onTouchMessage) {
        _onTouchMessage();
    }
}

@end