//
//  PTLoadingView.m
//  kidsPlay
//
//  Created by CHEN KAIDI on 13/7/15.
//  Copyright (c) 2015 CHEN KAIDI. All rights reserved.
//

#import "PTLoadingView.h"

@implementation PTLoadingView{
    UIButton *_btnFirstLoad;
    UIImageView *_imgLoad;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialiseLoadingView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initialiseLoadingView {
    _btnFirstLoad = [[UIButton alloc] initWithFrame:self.bounds];
    _btnFirstLoad.backgroundColor = [UIColor whiteColor];
    [_btnFirstLoad setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnFirstLoad.userInteractionEnabled = NO;
    [_btnFirstLoad addTarget:self action:@selector(onClickLoad) forControlEvents:UIControlEventTouchUpInside];
    [_btnFirstLoad setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnFirstLoad setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [self addSubview:_btnFirstLoad];
    
    _imgLoad = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imgLoad setImage:[UIImage imageNamed:@"ani_loading_bubble"]];
    _imgLoad.animationDuration = 1;
    _imgLoad.animationRepeatCount = 0;
    
    _imgLoad.size = _imgLoad.image.size;
    _imgLoad.center = CGPointMake(_btnFirstLoad.frame.size.width/2, _btnFirstLoad.frame.size.height/2);
    [_btnFirstLoad addSubview:_imgLoad];
}

- (void)startSpinning {
    _imgLoad.hidden = NO;
    CABasicAnimation* RotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    RotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    RotateAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    RotateAnimation.duration = 0.6;
    RotateAnimation.autoreverses = NO;
    RotateAnimation.removedOnCompletion = YES;
    RotateAnimation.fillMode = kCAFillModeForwards;
    [_imgLoad.layer addAnimation:RotateAnimation forKey:@"RotateAnimation"];
    
    //做循环，动画
    [self performSelector:@selector(startSpinning) withObject:nil afterDelay:0.6];
}

-(void)stopSpinning {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSpinning) object:nil];
    [_imgLoad.layer removeAllAnimations];
    _imgLoad.hidden = YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [_btnFirstLoad setBackgroundColor:backgroundColor];
}

- (void)onClickLoad {
    _btnFirstLoad.userInteractionEnabled = NO;
    [_btnFirstLoad setTitle:@"" forState:UIControlStateNormal];
    _imgLoad.hidden = NO;
    
    if (self.onClick) {
        self.onClick();
    }
}

@end
