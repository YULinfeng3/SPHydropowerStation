//
//  CATAlertView.h
//  Catch
//
//  Created by Xinbao Dong on 15/6/7.
//  Copyright (c) 2015年 Entropy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CATAlertView : UIView

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) void(^onTouchMessage)();

- (instancetype)initWithTitle:(NSString *)title Message:(NSString *)message Hidden:(BOOL)hidden touchBlock:(void (^)(id sender, NSInteger index))block cancelButtonTitle:(NSString *)cancelTitle andButtonsTitles:(NSString *)buttonTitle, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

@end
