//
//  BurgerContainerController.m
//  StacksApp
//
//  Created by Pho Diep on 2/16/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "BurgerContainerController.h"
#import "MenuTableViewController.h"
#import "MenuTableViewDelegate.h"
#import "ProfileViewController.h"
#import "MyQuestionsViewController.h"


#pragma mark - Interface
@interface BurgerContainerController () <MenuTableViewDelegate>

@property (strong, nonatomic) MenuTableViewController *menuVC;
@property (strong, nonatomic) UINavigationController *searchVC;
@property (strong, nonatomic) ProfileViewController *profileVC;
@property (strong, nonatomic) MyQuestionsViewController *myQuestionsVC;

@property (strong, nonatomic) UIViewController *topVC;
@property (strong, nonatomic) UIButton *burgerButton;

@property (strong, nonatomic) UITapGestureRecognizer *tapToClose;
@property (strong, nonatomic) UIPanGestureRecognizer *slideRecognizer;
@property (nonatomic) NSInteger selectedRow;

@end

#pragma mark - Implementation
@implementation BurgerContainerController

#pragma mark - UIViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupVcAsTopVC:self.searchVC];
    self.selectedRow = 0;
    [self addBurgerButton: self.searchVC.view];
    
    self.tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePanel)];
    self.slideRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    [self.topVC.view addGestureRecognizer:self.slideRecognizer];
}

-(void)setupVcAsTopVC:(UIViewController*)viewController {
    [self addChildViewController:viewController];
    viewController.view.frame = self.view.frame;
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];

    self.topVC = viewController;
}

-(void)addBurgerButton:(UIView*)view {
    UIButton *burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 40, 40)];
    [burgerButton setBackgroundImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
    [burgerButton addTarget:self action:@selector(burgerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:burgerButton];
    self.burgerButton = burgerButton;
}


-(void) switchToVC:(UIViewController*)destinationVC {
    __weak BurgerContainerController *weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^{
        //anim
        weakSelf.topVC.view.frame = CGRectMake(weakSelf.view.frame.size.width, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
    } completion:^(BOOL finished) {
        //comp
        destinationVC.view.frame = self.topVC.view.frame;
        
        [self.topVC.view removeGestureRecognizer:self.slideRecognizer];
        [self.burgerButton removeFromSuperview];
        [self.topVC willMoveToParentViewController:nil];
        [self.topVC.view removeFromSuperview];
        [self.topVC removeFromParentViewController];
        
        self.topVC = destinationVC;
        
        [self addChildViewController:self.topVC];
        [self.view addSubview:self.topVC.view];
        [self.topVC didMoveToParentViewController:self];
        [self.topVC.view addSubview:self.burgerButton];
        [self.topVC.view addGestureRecognizer:self.slideRecognizer];
        
        [self closePanel];
    }];
}


#pragma mark - MenuTableViewDelegate
-(void)menuCellSelected:(NSInteger)selectedRow {
    if (self.selectedRow == selectedRow) {
        //vc already showing
        [self closePanel];
    } else {
        self.selectedRow = selectedRow;
        UIViewController *destinationVC;
        switch (selectedRow) {
            case 0:
                destinationVC = self.searchVC;
                break;
            case 1:
                destinationVC = self.myQuestionsVC;
                break;
            case 2:
                destinationVC = self.profileVC;
                break;
            default:
                break;
        }
        [self switchToVC:destinationVC];
    }
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

-(ProfileViewController *)profileVC {
    if (_profileVC == nil) {
        _profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PROFILE_VC"];
    }
    return _profileVC;
}

-(MyQuestionsViewController *)myQuestionsVC {
    if (_myQuestionsVC == nil) {
        _myQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MY_QUESTIONS_VC"];
    }
    return _myQuestionsVC;
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EMBED_SEGUE"]) {
        MenuTableViewController *destinationVC = segue.destinationViewController;
        destinationVC.delegate = self;
        self.menuVC = destinationVC;
    }
}


@end
