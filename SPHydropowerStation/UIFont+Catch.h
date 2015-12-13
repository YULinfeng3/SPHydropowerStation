//
//  UIFont+Catch.h
//  Catch
//
//  Created by 余林峰 on 15/5/13.
//  Copyright (c) 2015年 Entropy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CATFontStype)
{
    CATFontStypeHeadline = 1,           // 48 Demi Bold
    CATFontStypeTitle = 2,              // 42 Medium
    CATFontStypeName = 3,               // 36 Demi Bold
    CATFontStypeSubhead = 4,            // 28 Regular
    CATFontStypeText = 5,               // 26 Regular
    CATFontStypeRegularWords = 6,       // 24 Regular
    CATFontStypeNotice = 7,             // 18 Regular
    CATFontStypeDescription = 8,        // 22 Regular
    CATFontStypeAlertTitle = 9,         // 32 Medium
    CATFontStypeBoldWords = 10,
    CATFontStypeBoldDescription = 11,
    CATFontStypeLarge = 12,             // 36
    CATFontStypeNameRegular = 13,
    CATFontStypeAlertTitleRegular = 14,
    CATFontStypeMediumNotice = 15,
    CATFontStypeSubline = 16,
    CATFontStypeMedium = 17,
};

@interface UIFont (Catch)

+ (UIFont *)fontWithStyle:(CATFontStype)style;

@end
