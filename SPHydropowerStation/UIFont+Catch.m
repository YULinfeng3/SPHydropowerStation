//
//  UIFont+Catch.m
//  Catch
//
//  Created by 余林峰 on 15/5/13.
//  Copyright (c) 2015年 Entropy. All rights reserved.
//

#import "UIFont+Catch.h"

@implementation UIFont (Catch)

//+ (UIFont *)fontWithStyle:(CATFontStype)style
//{
//    CGFloat fix = 2;
//    if (iPhone6Plus) {
//        fix = 3;
//    }
//    switch (style) {
//        case CATFontStypeHeadline:
//            return [UIFont fontWithName:@"PingHei-Bold" size:24 + fix];
//        case CATFontStypeTitle:
//            return [UIFont fontWithName:@"PingHei-Semibold" size:21 + fix];
//        case CATFontStypeName:
//            return [UIFont fontWithName:@"PingHei-Bold" size:18 + fix];
//        case CATFontStypeSubhead:
//            return [UIFont fontWithName:@"PingHei-Text" size:14 + fix];
//        case CATFontStypeText:
//            return [UIFont fontWithName:@"PingHei-Text" size:13 + fix];
//        case CATFontStypeRegularWords:
//            return [UIFont fontWithName:@"PingHei-Light" size:12 + fix];
//        case CATFontStypeBoldWords:
//            return [UIFont fontWithName:@"PingHei-Bold" size:12 + fix];
//        case CATFontStypeNotice:
//            return [UIFont fontWithName:@"PingHei-Light" size:9 + fix];
//        case CATFontStypeDescription:
//            return [UIFont fontWithName:@"PingHei-Light" size:11 + fix];
//        case CATFontStypeAlertTitle:
//            return [UIFont fontWithName:@"PingHei-Text" size:16 + fix];
//    }
//    return nil;
//}

+ (UIFont *)fontWithStyle:(CATFontStype)style
{
    CGFloat fix = 2;
    switch (style) {
        case CATFontStypeHeadline:
            return [UIFont fontWithName:@"AvenirNext-Bold" size:24 + fix];
        case CATFontStypeSubline:
            return [UIFont fontWithName:@"AvenirNext-Regular" size:22 + fix];
        case CATFontStypeTitle:
            return [UIFont fontWithName:@"AvenirNext-DemiBold" size:21 + fix];
        case CATFontStypeName:
            return [UIFont fontWithName:@"AvenirNext-Bold" size:18 + fix];
        case CATFontStypeSubhead:
            return [UIFont fontWithName:@"AvenirNext-Medium" size:14 + fix];
        case CATFontStypeText:
            return [UIFont fontWithName:@"AvenirNext-Medium" size:13 + fix];
        case CATFontStypeRegularWords:
            return [UIFont fontWithName:@"AvenirNext-Regular" size:12 + fix];
        case CATFontStypeMediumNotice:
            return [UIFont fontWithName:@"AvenirNext-Medium" size:9 + fix];
        case CATFontStypeNotice:
            return [UIFont fontWithName:@"AvenirNext-Regular" size:9 + fix];
        case CATFontStypeDescription:
            return [UIFont fontWithName:@"AvenirNext-Regular" size:11 + fix];
        case CATFontStypeAlertTitle:
            return [UIFont fontWithName:@"AvenirNext-Medium" size:16 + fix];
        case CATFontStypeBoldWords:
            return [UIFont fontWithName:@"AvenirNext-Bold" size:12 + fix];
        case CATFontStypeBoldDescription:
            return [UIFont fontWithName:@"AvenirNext-Medium" size:11 + fix];
        case CATFontStypeLarge:
            return [UIFont fontWithName:@"AvenirNext-Bold" size:36 + fix];
        case CATFontStypeMedium:
            return [UIFont fontWithName:@"AvenirNext-Regular" size:10 + fix];
        case CATFontStypeNameRegular:
            return [UIFont fontWithName:@"AvenirNext-Regular" size:18 + fix];
        case CATFontStypeAlertTitleRegular:
            return [UIFont fontWithName:@"AvenirNext-Regular" size:16 + fix];
    }
    return nil;
}

@end
