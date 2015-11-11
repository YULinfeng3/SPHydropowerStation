//
//  UDWebView.h
//  UncleDanny
//
//  Created by Xinbao Dong on 15/3/5.
//  Copyright (c) 2015年 com.catchkaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UDWebViewDelegate <NSObject>

@optional
- (void)loadFinished:(BOOL)succeed;

- (void)contact:(NSString*)tel;

- (void)back;

- (void)doLogin;

- (void)share:(NSString*)title
         text:(NSString*)text
          url:(NSString*)url
     imageUrl:(NSString*)imageUrl;

- (void)pay:(NSString*)charge;

#pragma mark - Banner 跳转

- (void)photographer:(NSString*)photographerId;

- (void)album:(NSString*)albumId;

- (void)collection:(NSString*)collectionId;

@end

@interface UDWebView : UIWebView

@property (nonatomic,assign) id<UDWebViewDelegate> b2cDelegate;

@property (nonatomic,assign) BOOL showWaiting;

- (void)loadURL:(NSString *)url;
- (NSURLRequest *)requestAppendedInfo:(NSURLRequest *)request;
- (NSString*)title;
- (CGPoint)scrollOffset;

@end
