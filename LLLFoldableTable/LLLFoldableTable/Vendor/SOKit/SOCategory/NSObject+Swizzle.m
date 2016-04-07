//
//  NSObject+Swizzle.m
//  Pods
//
//  Created by Sean Li on 15/7/22.
//
//

#import "NSObject+Swizzle.h"

#import <objc/runtime.h>


@implementation NSObject (Swizzle)

@end



@implementation NSArray (PTSwizzleMethod)

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        [self swizzleWithArrayClass:NSClassFromString(@"__NSArrayI")];
//        
//        
//    });
//    
//}
//
//+ (void)swizzleWithArrayClass:(Class)class {
//    
//    
//    SEL originalSelector = @selector(objectAtIndex:);
//    SEL swizzledSelector = @selector(swizzleObjectAtIndex:);
//    
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//    
//    BOOL didAddMethod =
//    class_addMethod(class,
//                    originalSelector,
//                    method_getImplementation(swizzledMethod),
//                    method_getTypeEncoding(swizzledMethod));
//    
//    if (didAddMethod) {
//        class_replaceMethod(class,
//                            swizzledSelector,
//                            method_getImplementation(originalMethod),
//                            method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//    
//    
//}

-(id)safeObjectAtIndex:(NSUInteger)index
{
    
    if (index < self.count)
    {
        id value = [self objectAtIndex:index];
        if (value == [NSNull null]) {
            return nil;
        }
        return value;
    }
    
    NSLog(@"NSArray Count:%lu,  %@ index:%lu 越界",(unsigned long)self.count ,self,(unsigned long)index);
    return nil;//越界返回为nil
    
}

@end

//
//
//@implementation NSMutableArray (PTSwizzleMethod)
//
//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        [self swizzleWithArrayClass:NSClassFromString(@"__NSArrayI")];
//        
//        
//    });
//    
//}
//
//+ (void)swizzleWithArrayClass:(Class)class {
//    
//    
//    SEL originalSelector = @selector(objectAtIndex:);
//    SEL swizzledSelector = @selector(swizzleObjectAtIndex:);
//    
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//    
//    BOOL didAddMethod =
//    class_addMethod(class,
//                    originalSelector,
//                    method_getImplementation(swizzledMethod),
//                    method_getTypeEncoding(swizzledMethod));
//    
//    if (didAddMethod) {
//        class_replaceMethod(class,
//                            swizzledSelector,
//                            method_getImplementation(originalMethod),
//                            method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//    
//    
//}
//
//-(id)swizzleObjectAtIndex:(NSUInteger)index
//{
//    
//    if (index < self.count)
//    {
//        id value = [self swizzleObjectAtIndex:index];
//        if (value == [NSNull null]) {
//            return nil;
//        }
//        return value;
//    }
//    
//    NSLog(@"Array Count:%d,  %@ index:%d 越界",self.count ,self,index);
//    return nil;//越界返回为nil
//    
//}

//@end


@implementation NSDictionary (PTSwizzleMethod)

-(id)safeObjectForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
    }
    return value;
}

-(id)safeNumberForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSString class]]) {
        value = @([value integerValue]);
    }else if (![value isKindOfClass:[NSNumber class]]) {
        value = @(0);
    }
    return value;
}

-(id)safeStringForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [value stringValue];
    }else if (![value isKindOfClass:[NSString class]]) {
        value = @"";
    }
    return value;
}

@end

@implementation NSMutableDictionary (PTSwizzleMethod)

-(void)safeSetObject:(id)anObject forKey:(id)aKey{
    
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
    else{
        //NSLog(@"Attempting to set nil to key:%@. Insertion aborted.",aKey);
    }
}

@end

