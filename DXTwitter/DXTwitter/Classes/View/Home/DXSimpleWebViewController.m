//
//  DXSimpleWebViewController.m
//  DXTwitter
//
//  Created by dx on 17/3/12.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXSimpleWebViewController.h"

@interface DXSimpleWebViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *url;
@end

@implementation DXSimpleWebViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    _url = url;
    _webView = [UIWebView new];
    _webView.delegate = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.frame = self.view.bounds;
    [self.view addSubview:_webView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
