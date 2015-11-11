//
//  UDWebView.m
//  UncleDanny
//
//  Created by Xinbao Dong on 15/3/5.
//  Copyright (c) 2015年 com.catchkaka. All rights reserved.
//

#import "UDWebView.h"
#import "MacroDefinition.h"

@interface UDWebView () <UIWebViewDelegate>

@property (nonatomic, assign) NSInteger requestCount;

@property (nonatomic, copy) NSString* url;

@property (nonatomic, retain) UIProgressView* progressView;

@property (nonatomic, retain) NSTimer* timer;

@end

@implementation UDWebView

+ (void)initialize{
    //设备相关信息的获取
    NSString *strSysName = [[UIDevice currentDevice] systemName];
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
    NSString *strModel = [[UIDevice currentDevice] model];
    
    // 设置 user-agent
    NSString *oldAgent = [NSString stringWithFormat:@"%@,%@,%@",strSysName,strSysVersion,strModel];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *package = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *ext = [[package componentsSeparatedByString:@"."] lastObject];
    NSString *myAgent = [NSString stringWithFormat:@" %@/%@(%@)", ext, version,build];
    
    if (![oldAgent hasSuffix:myAgent]) {
        NSString *newAgent = [oldAgent stringByAppendingString:myAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
}

- (void)stopLoading
{
    [super stopLoading];
}

- (void)loadURL:(NSString *)url
{
    _url = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self loadRequest:request];
    self.delegate = self;
    
    self.scalesPageToFit = YES;
}

- (void)loadRequest:(NSURLRequest *)request
{
    _requestCount = 0;
    [super loadRequest:[self requestAppendedInfo:request]];
}

- (NSURLRequest *)requestAppendedInfo:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
//    [mutableRequest addValue:@"test" forHTTPHeaderField:@"test"];
//    [mutableRequest addValue:@"test" forHTTPHeaderField:@"test"];
    //    [mutableRequest addValue:[self stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] forHTTPHeaderField:@"User-Agent"];
    return [mutableRequest copy];
}

- (NSString*)title
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (CGPoint)scrollOffset
{
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    return pt;
}

- (void)dealloc
{
//    [KVNProgress dismiss];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}

BOOL _Authenticated;
NSURLRequest *_FailedRequest;
#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *scheme = request.URL.scheme;
    NSString *actionType = request.URL.host;
    NSString *fragment = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                              (CFStringRef)request.URL.fragment,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    
    NSData *responseData = [fragment dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *requestString = [request.URL absoluteString];
    
    if ([scheme isEqualToString:@"catch-objc"])
    {
        NSDictionary* params;
        if (responseData)
        {
            NSError* error;
            params = [NSJSONSerialization
                      JSONObjectWithData:responseData
                      options:NSJSONReadingAllowFragments
                      error:&error];
        }
        
        if ([actionType isEqualToString:@"contact"])
        {
            if (_b2cDelegate && [_b2cDelegate respondsToSelector:@selector(contact:)])
                [_b2cDelegate contact:params[@"tel"]];
        }
        else if ([actionType isEqualToString:@"back"])
        {
            if (_b2cDelegate && [_b2cDelegate respondsToSelector:@selector(back)])
                [_b2cDelegate back];
        }
        else if ([actionType isEqualToString:@"alert"])
        {
            NSString* title = params[@"title"];
            NSString* message = params[@"message"];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if ([actionType isEqualToString:@"doLogin"])
        {
            if (_b2cDelegate && [_b2cDelegate respondsToSelector:@selector(doLogin)])
                [_b2cDelegate doLogin];
        }
        else if ([actionType isEqualToString:@"photographer"])
        {
            if (_b2cDelegate && [_b2cDelegate respondsToSelector:@selector(photographer:)])
                [_b2cDelegate photographer:params[@"photographerId"]];
        }
        else if ([actionType isEqualToString:@"album"])
        {
            if (_b2cDelegate && [_b2cDelegate respondsToSelector:@selector(album:)])
                [_b2cDelegate album:params[@"albumId"]];
        }
        else if ([actionType isEqualToString:@"collection"])
        {
            if (_b2cDelegate && [_b2cDelegate respondsToSelector:@selector(collection:)])
                [_b2cDelegate collection:params[@"collectionId"]];
        }
        else if ([actionType isEqualToString:@"share"])
        {
            if (_b2cDelegate && [_b2cDelegate respondsToSelector:@selector(share:text:url:imageUrl:)])
                [_b2cDelegate share:params[@"title"] text:params[@"text"] url:params[@"url"] imageUrl:params[@"imageUrl"]];
        }
        else if([actionType isEqualToString:@"pay"]){
            if (_b2cDelegate && [_b2cDelegate respondsToSelector:@selector(pay:)])
                [_b2cDelegate pay:params[@"charge"]];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _requestCount ++;
    
    if (_showWaiting)
    {
//        [KVNProgress showWithStatus:@"正在加载..." onView:webView];
    }
    else
    {
        if (!_progressView) {
            _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            [_progressView setProgressViewStyle:UIProgressViewStyleDefault];
            _progressView.progressTintColor = RGBACOLOR(0, 0, 0, 1);
            _progressView.trackTintColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
            _progressView.progress = 0.1;
            [self addSubview:_progressView];
            
            if (!_timer)
            {
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
            }
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _requestCount --;
    if (_requestCount == 0) {
        _progressView.progress = 1;
        _progressView.hidden = YES;
        if (_b2cDelegate && [_b2cDelegate respondsToSelector:@selector(loadFinished:)])
            [_b2cDelegate loadFinished:YES];
    }
    else
    {
        if (_b2cDelegate && [_b2cDelegate respondsToSelector:@selector(loadFinished:)])
            [_b2cDelegate loadFinished:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _requestCount --;
    if (_requestCount == 0) {
        if (_b2cDelegate)
            [_b2cDelegate loadFinished:NO];
    }
}

#pragma mark - Util

-(void)changeProgress
{
    float proValue = _progressView.progress;
    _progressView.hidden = NO;
    double v = (arc4random() % 10) / 100.0;
    proValue += v;
    if(proValue >= 0.84)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    [_progressView setProgress:proValue animated:YES];
    if (_progressView.progress >= 1)
    {
        _progressView.hidden = YES;
    }
}


@end
