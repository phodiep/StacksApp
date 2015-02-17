//
//  BurgerContainerController.m
//  StacksApp
//
//  Created by Pho Diep on 2/16/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "BurgerContainerController.h"

#pragma mark - Interface
@interface BurgerContainerController ()

@property (strong, nonatomic) UINavigationController *searchVC;
@property (strong, nonatomic) UIViewController *topVC;
@property (strong, nonatomic) UIButton *burgerButton;

@property (strong, nonatomic) UITapGestureRecognizer *tapToClose;
@property (strong, nonatomic) UIPanGestureRecognizer *slideRecognizer;

@end

#pragma mark - Implementation
@implementation BurgerContainerController

#pragma mark - UIViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSearchVcAsTopVC];
    [self addBurgerButton: self.searchVC.view];
    
    self.tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePanel)];
    self.slideRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    [self.topVC.view addGestureRecognizer:self.slideRecognizer];
}

-(void)setupSearchVcAsTopVC {
    [self addChildViewController:self.searchVC];
    self.searchVC.view.frame = self.view.frame;
    [self.view addSubview:self.searchVC.view];
    [self.searchVC didMoveToParentViewController:self];
    self.topVC = self.searchVC;
}

-(void)addBurgerButton:(UIView*)view {
    UIButton *burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 40, 40)];
    [burgerButton setBackgroundImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
    [burgerButton addTarget:self action:@selector(burgerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:burgerButton];
    self.burgerButton = burgerButton;
}

#pragma mark - Gestures
-(void)slidePanel:(id)sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
    
    CGPoint translatedPoint = [pan translationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    
    if ([pan state] == UIGestureRecognizerStateChanged) {
        if (velocity.x > 0 || self.topVC.view.frame.origin.x > 0) {
            self.topVC.view.center = CGPointMake(self.topVC.view.center.x + translatedPoint.x, self.topVC.view.center.y);
            [pan setTranslation:CGPointZero inView:self.view];
        }
    }
    
    if ([pan state] == UIGestureRecognizerStateEnded) {
        
        __weak BurgerContainerController *weakSelf = self;
        
        if (weakSelf.topVC.view.frame.origin.x > weakSelf.view.frame.size.width / 3) {
            weakSelf.burgerButton.userInteractionEnabled = false;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.topVC.view.center = CGPointMake(weakSelf.view.frame.size.width * 1.25, weakSelf.topVC.view.center.y);
            } completion:^(BOOL finished) {
                [weakSelf.topVC.view addGestureRecognizer:weakSelf.tapToClose];
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.topVC.view.center = weakSelf.view.center;
            }];
            [weakSelf.topVC.view removeGestureRecognizer:weakSelf.tapToClose];
        }
        
    }
}

-(void)closePanel {
    [self.topVC.view removeGestureRecognizer:self.tapToClose];
    
    __weak BurgerContainerController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.topVC.view.center = weakSelf.view.center;
    } completion:^(BOOL finished) {
        weakSelf.burgerButton.userInteractionEnabled = true;
    }];
}


#pragma mark - Button actions
-(void)burgerButtonPressed {

    self.burgerButton.userInteractionEnabled = false;
    
    __weak BurgerContainerController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.topVC.view.center = CGPointMake(weakSelf.topVC.view.center.x + 300, weakSelf.topVC.view.center.y);
    } completion:^(BOOL finished) {
        [weakSelf.topVC.view addGestureRecognizer:weakSelf.tapToClose];
    }];
}

#pragma mark - Override Getters
-(UINavigationController *)searchVC {
    if (_searchVC == nil) {
        _searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SEARCH_VC"];
    }
    return _searchVC;
}


@end
