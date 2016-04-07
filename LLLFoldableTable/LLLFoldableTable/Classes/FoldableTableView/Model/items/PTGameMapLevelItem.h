//
//  PTGameMapLevelItem.h
//  PTLatitude
//
//  Created by LiLiLiu on 16/4/6.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "SOBaseItem.h"

/**
 * @brief V1.3 游戏关卡 服务器返回数据 3 级
 */
@interface PTGameMapLevelItem : SOBaseItem<NSCopying>

@property (copy , nonatomic) NSString *level_id;
@property (copy , nonatomic) NSString *title;

@end
