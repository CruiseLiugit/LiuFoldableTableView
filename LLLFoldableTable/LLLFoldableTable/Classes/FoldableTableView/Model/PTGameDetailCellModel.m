//
//  PTGameDetailCellModel.m
//  Demo
//
//  Created by admin on 16/4/6.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import "PTGameDetailCellModel.h"

@interface PTGameDetailCellModel ()

@property (assign, nonatomic) CGFloat cellHeight;

@property (assign, nonatomic) CGFloat maxTextWidth;

@property (copy, nonatomic) UIFont *contentFont;

@property (copy, nonatomic) UIFont *titleFont;

@end

@implementation PTGameDetailCellModel

- (instancetype)initWithImageURL:(NSString *)imageURL title:(NSString *)title content:(NSString *)content style:(PTGameDetailCellStyle)style maxTextWidth:(CGFloat)maxTextWidth contentFont:(UIFont *)contentFont titleFont:(UIFont *)titleFont
{
    self = [super init];
    if (!self) return nil;
    
    self.imageURL = imageURL;
    self.title = title;
    self.content = content;
    self.style = style;
    self.maxTextWidth = maxTextWidth;
    self.contentFont = contentFont;
    self.titleFont = titleFont;
    
    [self reloadCellHeight];
    
    return self;
}

- (void)reloadCellHeight
{
    CGSize contentsize = [self.content boundingRectWithSize:CGSizeMake(self.maxTextWidth, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: self.contentFont}
                                                    context:nil].size;
    
    CGSize titlesize = [self.title boundingRectWithSize:CGSizeMake(self.maxTextWidth, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: self.titleFont}
                                                context:nil].size;
    
    CGFloat height = 30;
    
    height += ([UIScreen mainScreen].bounds.size.width - 40) / 2;
    height += 20;
    height += MIN(titlesize.height, 40);
    height += MIN(contentsize.height, 30);
    height += 10;
    height += self.style == PTGameDetailCellStyleaArticle ? 0 : (self.style == PTGameDetailCellStyleCheckpointFinish ? 88 : 44);
    
    self.cellHeight = height;
}

@end
