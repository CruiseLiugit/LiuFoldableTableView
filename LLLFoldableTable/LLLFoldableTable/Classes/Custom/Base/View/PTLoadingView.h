//
//  PTLoadingView.h
//  kidsPlay
//
//  Created by CHEN KAIDI on 13/7/15.
//  Copyright (c) 2015 CHEN KAIDI. All rights reserved.
//

#import <UIKit/UIKit.h>

// 回调
typedef void(^loadingCallBackBlock)();

@interface PTLoadingView : UIView
@property (nonatomic, copy) loadingCallBackBlock onClick;
- (void)startSpinning;
- (void)stopSpinning;
@end
