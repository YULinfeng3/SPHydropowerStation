//
//  UDWebViewController.m
//  UncleDanny
//
//  Created by Xinbao Dong on 15/3/5.
//  Copyright (c) 2015年 com.catchkaka. All rights reserved.
//

#import "UDWebViewController.h"
#import "UDWebView.h"
#import "MacroDefinition.h"
//#import "CATToolbar.h"

#define WEBVIEW_INDICATOR_COLOR [UIColor colorWithRed:44. / 255.f green:167. / 255.f blue:252. / 255.f alpha:1.0]

@interface UDWebViewController () <UDWebViewDelegate>

@property (nonatomic, strong) UDWebView *webView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) NSInteger finishedCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) BOOL finished;

@property (nonatomic,retain) UIButton* backButton;

@end

@implementation UDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
    [self configureUI];

    [self startRequesting];
    
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_indicatorView removeFromSuperview];
    [_webView stopLoading];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WelcomeDismiss" object:nil];
}

- (void)viewDidLayoutSubviews
{
    self.webView.frame = self.view.bounds;
}

- (void)startRequesting
{
    _totalCount = 0;
    _finishedCount = 0;
    [_webView loadURL:_url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWebView
{
    _webView = [[UDWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _webView.b2cDelegate = self;
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
}

- (void)configureUI
{
    _indicatorView = [[UIView alloc] init];
    _indicatorView.frame = CGRectMake(0, 1, 10, 3);
    _indicatorView.backgroundColor = WEBVIEW_INDICATOR_COLOR;

    self.webView.backgroundColor = [UIColor whiteColor];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 70, 50, 50)];
    [self.backButton setImage:[UIImage imageNamed:@"toolbar_back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
}

- (void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setProgress:(CGFloat)progress
{
    if (_indicatorView.superview == nil) {
//        [self.navigationController.view addSubview:_indicatorView];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_indicatorView];
    }
    if (progress == 0.) {
        progress = 0.05;
    }
    CGRect frame = _indicatorView.frame;
    frame.size.width = SCREEN_WIDTH * progress;
    [UIView animateWithDuration:0.3 animations:^{
        _indicatorView.frame = frame;
        if (progress == 1.0) {
            _indicatorView.backgroundColor = [UIColor clearColor];
        }else {
            _indicatorView.backgroundColor = WEBVIEW_INDICATOR_COLOR;
        }
    } completion:^(BOOL finished) {
        if (progress == 1.) {
            _indicatorView.frame = CGRectMake(0, 1, 10, 3);
            [_indicatorView removeFromSuperview];
        }
    }];
    _progress = progress;
}

#pragma mark - web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _totalCount ++;
    if (_finished == YES) {
        self.progress = 0.;
        _finished = NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _finishedCount ++;
    self.progress = (CGFloat)_finishedCount / _totalCount;
    if (_finishedCount == _totalCount) {
        _finishedCount = 0;
        _totalCount = 0;
        _finished = YES;
    }
    self.title = [_webView title];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _finishedCount ++;
    self.progress = (CGFloat)_finishedCount / _totalCount;
    if (_finishedCount == _totalCount) {
        _finishedCount = 0;
        _totalCount = 0;
        _finished = YES;
    }
    self.title = [_webView title];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *absoluteString = [[request URL] absoluteString];
    NSArray *components = [absoluteString componentsSeparatedByString:@"::"];
    
    if (components != nil && [components count] > 0) {
        NSString *pocotol = [components objectAtIndex:0];
        if ([pocotol isEqualToString:@"test"]) {
            NSString *commandStr = [components objectAtIndex:1];
            NSArray *commandArray = [commandStr componentsSeparatedByString:@":"];
            if (commandArray != nil && [commandArray count] > 0) {
                NSString *command = [commandArray objectAtIndex:0];
                if ([command isEqualToString:@"login"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息" message:@"网页发出了登录请求" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
            }
            return NO;
        }
    }
    return YES;
}

#pragma mark - UDWebViewDelegate

- (void)loadFinished:(BOOL)succeed{
    self.title = [_webView title];
}

@end
