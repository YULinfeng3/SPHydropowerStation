//
//  CATMessageView.h
//  Catch
//
//  Created by 余林峰 on 15/7/11.
//  Copyright (c) 2015年 Entropy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CATMessageViewType)
{
    CATMessageViewDefault = 0,
    CATMessageViewRed
};

@interface CATMessageView : UIView

@property (nonatomic,retain) NSString* message;

+ (void)showWithMessage:(NSString*)message;

+ (void)showWithMessage:(NSString*)message
                   type:(CATMessageViewType)type;

@end
