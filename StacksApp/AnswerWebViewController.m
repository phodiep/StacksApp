//
//  AnswerWebViewController.m
//  StacksApp
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "AnswerWebViewController.h"
#import <WebKit/WebKit.h>

@interface AnswerWebViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AnswerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Answers";
    
    NSURL *url = [NSURL URLWithString:self.link];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:true completion:^{
        [self.navigationController popViewControllerAnimated:false];
    }];
}


@end
