//
//  AuthViewController.m
//  Runner
//
//  Created by admin on 2019/4/28.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController () </* WKNavigationDelegate */ UIWebViewDelegate>

//@property (strong, nonatomic) WKWebView *webView;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self addLoadingView];
    [self addUIWebview];
}

- (void) back {
    self.callBackBlock(NULL);
    [self dismissViewControllerAnimated:NO completion: NULL];
}

- (void)setNavBar {
    self.title = @"应用授权";
    self.navigationController.navigationBar.barTintColor = UIColor.redColor;
    
    UIColor* color = [UIColor whiteColor];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes= dict;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)addLoadingView {
    double width = [[UIScreen mainScreen] bounds].size.width;
    double height = [[UIScreen mainScreen] bounds].size.height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [view setTag:103];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setAlpha:0.8];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setColor:[UIColor redColor]];
    [view addSubview:activityIndicator];
    self.activityIndicator = activityIndicator;
    [self.view addSubview:view];
}

- (void)addUIWebview {
    double width = [[UIScreen mainScreen] bounds].size.width;
    double height = [[UIScreen mainScreen] bounds].size.height;
    NSString *authUrl = @"https://oauth.taobao.com/authorize?response_type=code&client_id=25793646&redirect_uri=urn:ietf:wg:oauth:2.0:oob&view=wap";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    webView.delegate = self;
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authUrl]]];
    [self.view addSubview:webView];
}

#pragma mark - UIWebViewDelegate
//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString: url.absoluteString];
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLQueryItem *item = (NSURLQueryItem *)obj;
        if ([item.name isEqualToString:@"code"]) {
            if (NULL != self.callBackBlock) {
                self.callBackBlock(item.value);
            }
            [self dismissViewControllerAnimated:NO completion:NULL];
        }
    }];
    return YES;
}


//- (void)addWKWebview {
//    double width = [[UIScreen mainScreen] bounds].size.width;
//    double height = [[UIScreen mainScreen] bounds].size.height;
//    NSString *authUrl = @"https://oauth.taobao.com/authorize?response_type=code&client_id=25793646&redirect_uri=urn:ietf:wg:oauth:2.0:oob&view=wap";
//
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    WKPreferences *preference = [[WKPreferences alloc] init];
//    preference.javaScriptEnabled = YES;
//    config.preferences = preference;
//    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, width, height) configuration:config];
//    self.webView.navigationDelegate = self;
//    [self.view addSubview:self.webView];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authUrl]]];
//    [self loadAuth];
//}


//- (void) loadAuth {
//    NSString *authUrl = @"https://oauth.taobao.com/authorize?response_type=code&client_id=25793646&redirect_uri=urn:ietf:wg:oauth:2.0:oob&view=wap";
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString: authUrl] encoding:NSUTF8StringEncoding error:nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.webView loadHTMLString: htmlString baseURL:[NSURL URLWithString:authUrl]];
//            [self.view addSubview:self.webView];
//        });
//    });
//}

//#pragma mark - WKNavigationDelegate
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSURL *url = navigationAction.request.URL;
//    NSURLComponents *components = [[NSURLComponents alloc] initWithString: url.absoluteString];
//    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSURLQueryItem *item = (NSURLQueryItem *)obj;
//        if ([item.name isEqualToString:@"code"]) {
//            if (NULL != self.callBackBlock) {
//                self.callBackBlock(item.value);
//            }
//            [self dismissViewControllerAnimated:NO completion:NULL];
//        }
//    }];
//    decisionHandler(WKNavigationActionPolicyAllow);
//}
@end
