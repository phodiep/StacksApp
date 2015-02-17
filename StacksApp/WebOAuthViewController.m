//
//  WebOAuthViewController.m
//  StacksApp
//
//  Created by Pho Diep on 2/16/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "WebOAuthViewController.h"
#import <WebKit/WebKit.h>

#pragma mark - Interface
@interface WebOAuthViewController () <WKNavigationDelegate>

@end

#pragma mark - Implementation
@implementation WebOAuthViewController

#pragma mark - UIViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    webView.navigationDelegate = self;
    
    NSString *urlString = @"https://stackexchange.com/oauth/dialog?client_id=4286&scope=no_expiry&redirect_uri=https://stackexchange.com/oauth/login_success";
    
    NSURL *url = [NSURL URLWithString:urlString];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];

}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request = navigationAction.request;
    NSURL *url = request.URL;
    
    if ([url.description containsString:@"access_token"]) {
        NSArray *components = [[url description] componentsSeparatedByString:@"="];
        NSString *token = components.lastObject;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:token forKey:@"token"];
        [userDefaults synchronize];
        
        [self dismissViewControllerAnimated:true completion:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


@end
