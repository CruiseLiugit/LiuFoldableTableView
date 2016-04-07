//
//  PTGameMapListHeaderView.h
//  PTLatitude
//
//  Created by LiLiLiu on 16/4/6.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "SOBaseView.h"

#import "PTGameMapListItem.h"

typedef void(^PTGameMapListHeaderViewActionBlock)(BOOL isExpand);

/**
 * @brief V1.3 游戏关卡页面 游戏理念 View
 */
@interface PTGameMapListHeaderView : SOBaseView

@property (nonatomic,strong) PTGameMapListItem *item;
@property (nonatomic,assign) BOOL expand;       //扩展开

@property (nonatomic,copy) PTGameMapListHeaderViewActionBlock actionBlock; //点击回调

/**
 * @brief 根据服务器返回 游戏理念 description 内容动态计算高度
 */
+ (CGFloat)getHeaderViewHeighWithItem:(PTGameMapListItem *)item;

@end
