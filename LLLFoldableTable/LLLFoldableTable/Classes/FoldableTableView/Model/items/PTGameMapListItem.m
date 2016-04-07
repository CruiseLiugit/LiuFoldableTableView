//
//  PTGameMapListItem.m
//  PTLatitude
//
//  Created by LiLiLiu on 16/4/6.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTGameMapListItem.h"

#import "PTGameMapLevelListItem.h"

@implementation PTGameMapListItem


+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTGameMapListItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    
    item.game_id = [dict safeStringForKey:@"game_id"];
    item.game_name = [dict safeStringForKey:@"game_name"];
    item.game_icon = [dict safeStringForKey:@"game_icon"];
    item.description_icon = [dict safeStringForKey:@"description_icon"];
    item.description_title = [dict safeStringForKey:@"description_title"];
    item.description_content = [dict safeStringForKey:@"description"];
    
    NSArray *levelsListArr = [dict safeObjectForKey:@"levels"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSDictionary *likeDict in levelsListArr) {
        PTGameMapLevelListItem *item = [PTGameMapLevelListItem itemWithDict:likeDict];
        [tempArr addObject:item];
    }
    item.levels = [NSArray arrayWithArray:tempArr];
    
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _game_icon = _game_id = _game_name = _description_content = _description_icon = _description_title = nil;
        _levels = nil;
    }
    return (self);
}


#pragma mark - <NSCopying>
- (id)copyWithZone:(nullable NSZone *)zone{
    PTGameMapListItem *item = [super copyWithZone:zone];
    item.game_icon = self.game_icon;
    item.game_id = self.game_id;
    item.game_name = self.game_name;
    item.description_content = self.description_content;
    item.description_icon = self.description_icon;
    item.description_title = self.description_title;
    item.levels = self.levels;
    
    return (item);
}
#pragma mark -

@end
