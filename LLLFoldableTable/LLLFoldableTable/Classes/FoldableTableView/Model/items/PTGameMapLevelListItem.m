//
//  PTGameMapLevelListItem.m
//  PTLatitude
//
//  Created by LiLiLiu on 16/4/6.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTGameMapLevelListItem.h"

#import "NSObject+Swizzle.h"
#import "PTGameMapLevelItem.h"

@implementation PTGameMapLevelListItem


+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTGameMapLevelListItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    item.title = [dict safeStringForKey:@"title"];
    item.icon = [dict safeStringForKey:@"icon"];
    
    NSArray *levels_listArr = [dict safeObjectForKey:@"levels_list"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSDictionary *likeDict in levels_listArr) {
        PTGameMapLevelItem *item = [PTGameMapLevelItem itemWithDict:likeDict];
        [tempArr addObject:item];
    }
    item.levels_list = [NSArray arrayWithArray:tempArr];
    
    
    return (item);
}


- (instancetype)init {
    self = [super init];
    if(self) {
        _title = _icon = nil;
        _levels_list = nil;
    }
    return (self);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    PTGameMapLevelListItem *item = [super copyWithZone:zone];
    item.title = self.title;
    item.icon = self.icon;
    item.levels_list = self.levels_list;
    
    return (self);
}
#pragma mark -

@end
