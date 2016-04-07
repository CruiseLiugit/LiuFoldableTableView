//
//  PTBaseViewController.m
//  kidsPlay
//
//  Created by so on 15/9/14.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "PTBaseViewController.h"
#import "UIViewController+SOViewController.h"
#import "UIButton+SOButton.h"
#import "SOGlobal.h"

@interface PTBaseViewController ()
@end

@implementation PTBaseViewController
@synthesize needRefresh = _needRefresh;
@synthesize ptLoadingView = _ptLoadingView;

#pragma mark - lifeCycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _keyboardBenginFrame = CGRectZero;
        _keyboardEndFrame = CGRectZero;
        _keyboardAnimationDuration = 0.3f;
        _needRefresh = YES;
    }
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xffffff)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.ptLoadingView.frame = self.view.bounds;
}

#pragma mark - Overwrite
-(BOOL)prefersStatusBarHidden {
    return NO;
}
#pragma mark -

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    [super setTitle:@" "];
    [self setTitle:title color:UIColorFromRGB(0x313131) font:[UIFont systemFontOfSize:18] selector:nil];
}
#pragma mark -

#pragma mark - getter
- (PTLoadingView *)ptLoadingView {
    if (!_ptLoadingView) {
        _ptLoadingView = [[PTLoadingView alloc] initWithFrame:self.view.bounds];
        [_ptLoadingView setBackgroundColor:UIColorFromRGBWithAlpha(0xffffff, 1)];
    }
    return (_ptLoadingView);
}
#pragma mark -

#pragma mark - action
- (void)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    _keyboardAnimationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _keyboardBenginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    _keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardAnimationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _keyboardBenginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    _keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

- (UIButton *)showBackButtonItemAnimation:(BOOL)animation {
    UIButton *button = [UIButton buttonWithImage:[UIImage imageNamed:@"btn_20_back_p_nor"] selectedImage:[UIImage imageNamed:@"btn_20_back_p_sel"] hightlightImage:[UIImage imageNamed:@"btn_20_back_p_sel"]];
    button.frame = CGRectMake(0, 0, 36, 36);
    [button addTarget:self action:@selector(leftItemTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)button];
    [self.navigationItem setLeftBarButtonItem:item animated:animation];
    return (button);
}

- (void)leftItemTouched:(id)sender {
    [self dismissAnimation:YES];
}


- (void)startLoadAnimation {
    [self.view addSubview:self.ptLoadingView];
    [self.ptLoadingView startSpinning];
}

- (void)stopLoadAnimation {
    [self.ptLoadingView stopSpinning];
    if ([self.ptLoadingView superview]) {
        [self.ptLoadingView removeFromSuperview];
    }
}

#pragma mark -


#pragma mark - orientation
//默认不支持旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end
