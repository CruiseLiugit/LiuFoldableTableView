//
//  PTGameMapListModel.m
//  LLLFoldableTable
//
//  Created by LiLiLiu on 16/4/7.
//  Copyright © 2016年 liulili. All rights reserved.
//

#import "PTGameMapListModel.h"

#import "PTGameMapListItem.h"

@interface PTGameMapListModel ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation PTGameMapListModel
@synthesize data = _data;

- (instancetype)init {
    self = [super init];
    if(self) {
        NSMutableDictionary *dict = [self createGameMapData];
        _data = [dict safeObjectForKey:@"data"];
    }
    return (self);
}

- (NSMutableArray *)parseResponseData{
    if (!_data) {
        return nil;
    }
    NSMutableArray *items = [NSMutableArray array];
    for(NSDictionary *dict in _data) {
        PTGameMapListItem *sectionItem = [PTGameMapListItem itemWithDict:dict];
        [items addObject:sectionItem];
    }
    
    return items;
}


#pragma mark - 解析本地json数据
- (NSMutableDictionary *)createGameMapData{
    NSMutableDictionary *dic = nil;
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"GameMap" ofType:@"json"];
    NSString *jsonContent=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (jsonContent != nil)
    {
        NSData *jsonData = [jsonContent dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingMutableContainers
                                                error:&err];
        if(err)
        {
            NSLog(@"json解析失败：%@",err);
            return nil;
        }
    }
    return dic;
}

@end
