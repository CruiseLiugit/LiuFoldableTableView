//
//  PTGameDetailCellModel.h
//  Demo
//
//  Created by admin on 16/4/6.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PTGameDetailCellStyle) {
    PTGameDetailCellStyleCheckpointFinish = 0,
    PTGameDetailCellStyleCheckpointProcessing = 1,
    PTGameDetailCellStyleTask = 2,
    PTGameDetailCellStyleaArticle = 3,
};

@interface PTGameDetailCellModel : NSObject

- (instancetype)initWithImageURL:(NSString *)imageURL title:(NSString *)title content:(NSString *)content style:(PTGameDetailCellStyle)style maxTextWidth:(CGFloat)maxTextWidth contentFont:(UIFont *)contentFont titleFont:(UIFont *)titleFont;

@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (assign, nonatomic) PTGameDetailCellStyle style;

@property (assign, nonatomic, readonly) CGFloat cellHeight;

- (void)reloadCellHeight;

@end
