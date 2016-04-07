//
//  PTGameMapLevelItem.m
//  PTLatitude
//
//  Created by LiLiLiu on 16/4/6.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTGameMapLevelItem.h"

@implementation PTGameMapLevelItem


+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTGameMapLevelItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    
    item.level_id = [dict safeStringForKey:@"level_id"];
    item.title = [dict safeStringForKey:@"title"];
    
    return (item);
}


- (instancetype)init {
    self = [super init];
    if(self) {
        _level_id  = _title = nil;
    }
    return (self);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    PTGameMapLevelItem *item = [super copyWithZone:zone];
    item.level_id = self.level_id;
    item.title = self.title;
    
    return (self);
}
#pragma mark -

@end
