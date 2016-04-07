//
//  PTGameMapListItem.h
//  PTLatitude
//
//  Created by LiLiLiu on 16/4/6.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "SOBaseItem.h"

/**
 * @brief V1.3 游戏关卡 服务器返回数据 1 级
 */
@interface PTGameMapListItem : SOBaseItem<NSCopying>

@property (nonatomic, copy) NSString *game_id;
@property (nonatomic, copy) NSString *game_name;
@property (nonatomic, copy) NSString *game_icon;
@property (nonatomic, copy) NSString *description_icon;
@property (nonatomic, copy) NSString *description_title;
@property (nonatomic, copy) NSString *description_content;

@property (nonatomic, strong) NSArray *levels; //元素为 PTGameMapLevelListItem
@end
