//
//  SOHTTPPageRequestModel.m
//  SOKit
//
//  Created by soso on 15/6/16.
//  Copyright (c) 2015年 com.. All rights reserved.
//

#import "SOHTTPPageRequestModel.h"
#import "AFHTTPRequestOperation+SOHTTPRequestOperation.h"

@implementation SOHTTPPageRequestModel

- (void)dealloc {
    SOSUPERDEALLOC();
}

- (instancetype)init {
    return ([self initWithPageOffset:SO_DEFAULT_PAGEOFFSET]);
}

- (instancetype)initWithPageOffset:(NSUInteger)pageOffset {
    self = [super init];
    if(self) {
        _pageOffset = pageOffset;
        _pageIndex = 1;
    }
    return (self);
}

#pragma mark -- method
- (void)saveCacheTime {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    //    NSTimeInterval time = [date timeIntervalSince1970];
    // 把时间缓存
    [self cacheObject:date forKey:[self cacheKeyTime] atDisk:YES];
}

- (NSTimeInterval)getCacheTime {
    // 失败先取出缓存
    NSDate *date = [self cachedObjectForKey:[self cacheKeyTime] atDisk:YES];
    NSTimeInterval time = [date timeIntervalSince1970];
    return time;
}
#pragma mark - <SOBaseModelCacheProtocol>
- (NSString *)cacheKey {
    return ([NSString stringWithFormat:@"%@-%@-%@", self.baseURLString, self.parameters, @(self.pageIndex)]);
}

- (NSString *)cacheKeyTime {
    return ([NSString stringWithFormat:@"%@-%@-%@-time", self.baseURLString, self.parameters, @(self.pageIndex)]);
}
#pragma mark -

#pragma mark - <SOHTTPPageModelProtocol>
- (void)cancelAllRequest {
    [super cancelAllRequest];
}

- (AFHTTPRequestOperation *)startLoad {
    [self.parameters setObject:[@(self.pageIndex) stringValue] forKey:_KEY_SOHTTP_PAGEINDEX];
    [self.parameters setObject:[@(self.pageOffset) stringValue] forKey:_KEY_SOHTTP_PAGEOFFSET];
    AFHTTPRequestOperation *operation = [super startLoad];
    [operation setPageOffset:self.pageOffset];
    [operation setPageIndex:self.pageIndex];
    return (operation);
}

- (AFHTTPRequestOperation *)startLoadWithTime:(NSTimeInterval)time {
    __SOWEAK typeof(self) weak_self = self;
    if(self.method && [self.method isEqualToString:SOHTTPRequestMethodGET]) {
        AFHTTPRequestOperation *operation = [self.requestOperationManager GET:self.baseURLString parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weak_self cacheObject:responseObject forKey:[weak_self cacheKey] atDisk:YES];
            [weak_self saveCacheTime];
            [weak_self request:operation didReceived:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weak_self request:operation didFailed:error];
        }];
        return (operation);
    }
    AFHTTPRequestOperation *operation = [self.requestOperationManager POST:self.baseURLString parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weak_self cacheObject:responseObject forKey:[weak_self cacheKey] atDisk:YES];
        [weak_self saveCacheTime];
        [weak_self request:operation didReceived:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weak_self request:operation didFailed:error];
    }];
    return (operation);
}


- (AFHTTPRequestOperation *)reloadData {
    self.pageIndex = 1;
    return ([self startLoad]);
}


- (AFHTTPRequestOperation *)reloadDataWithTimeoutInterval:(NSTimeInterval)time{
    [self.parameters setObject:[@(self.pageIndex) stringValue] forKey:_KEY_SOHTTP_PAGEINDEX];
    [self.parameters setObject:[@(self.pageOffset) stringValue] forKey:_KEY_SOHTTP_PAGEOFFSET];
    
    NSDictionary *cacheDic = [self cachedObjectForKey:[self cacheKey] atDisk:YES];
    if (cacheDic && [cacheDic isKindOfClass:[NSDictionary class]] && cacheDic.allKeys > 0) {
        // 有缓存
        // 判断缓存是否过期
        NSTimeInterval cacheTime = [self getCacheTime];
        
        NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
        
        NSTimeInterval cacheToNowTime = nowTime - cacheTime;
        if (cacheToNowTime <= time) {
            // 未过期
            [self request:nil didReceived:cacheDic];
        } else {
            // 已过期，重新请求
            [self request:nil didReceived:cacheDic];
            AFHTTPRequestOperation *operation = [self startLoadWithTime:time];
            [operation setPageOffset:self.pageOffset];
            [operation setPageIndex:self.pageIndex];
            return operation;
        }
    } else {
        // 没有缓存，重新请求
        AFHTTPRequestOperation *operation = [self startLoadWithTime:time];
        [operation setPageOffset:self.pageOffset];
        [operation setPageIndex:self.pageIndex];
        return operation;
    }
    return nil;
}

- (AFHTTPRequestOperation *)loadDataAtPageIndex:(NSUInteger)pageIndex {
    self.pageIndex = pageIndex;
    return ([self startLoad]);
}

- (AFHTTPRequestOperation *)loadDataAtPageIndex:(NSUInteger)pageIndex WithTimeoutInterval:(NSTimeInterval)time{
    self.pageIndex = pageIndex;
    
    NSDictionary *cacheDic = [self cachedObjectForKey:[self cacheKey] atDisk:YES];
    if (cacheDic && [cacheDic isKindOfClass:[NSDictionary class]] && cacheDic.allKeys > 0) {
        // 有缓存
        // 判断缓存是否过期
        NSTimeInterval cacheTime = [self getCacheTime];
        
        NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
        
        NSTimeInterval cacheToNowTime = nowTime - cacheTime;
        if (cacheToNowTime <= time) {
            // 未过期
            [self request:nil didReceived:cacheDic];
        } else {
            // 已过期，重新请求
            [self request:nil didReceived:cacheDic];
            AFHTTPRequestOperation *operation = [self startLoadWithTime:time];
            [operation setPageOffset:self.pageOffset];
            [operation setPageIndex:self.pageIndex];
            return operation;
        }
    } else {
        // 没有缓存，重新请求
        AFHTTPRequestOperation *operation = [self startLoadWithTime:time];
        [operation setPageOffset:self.pageOffset];
        [operation setPageIndex:self.pageIndex];
        return operation;
    }
    return nil;
}


#pragma mark - SOHTTPModelProtocol
- (void)request:(AFHTTPRequestOperation *)request didReceived:(id)responseObject {
    NSUInteger pgIndex = (NSUInteger)[request pageIndex];
    if(pgIndex > 0) {
        self.pageIndex = (pgIndex + 1);
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(model:didReceivedData:userInfo:)]) {
        [self.delegate model:self didReceivedData:responseObject userInfo:nil];
    }
}
#pragma mark -

@end
