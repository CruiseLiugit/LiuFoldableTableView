//
//  PTGameMapLevelListItem.h
//  PTLatitude
//
//  Created by LiLiLiu on 16/4/6.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "SOBaseItem.h"

/**
 * @brief V1.3 游戏关卡 服务器返回数据 2 级
 */
@interface PTGameMapLevelListItem : SOBaseItem

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;

@property (strong , nonatomic) NSArray *levels_list; //元素为 PTGameMapLevelItem 对象

@end
