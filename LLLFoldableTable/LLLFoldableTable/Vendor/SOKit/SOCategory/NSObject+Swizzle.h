//
//  NSObject+Swizzle.h
//  Pods
//
//  Created by Sean Li on 15/7/22.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

@end


@interface NSArray (PTSwizzleMethod)
-(id)safeObjectAtIndex:(NSUInteger)index;
@end

//@interface NSMutableArray (PTSwizzleMethod)
//@end
//


@interface NSDictionary (PTSwizzleMethod)
-(id)safeObjectForKey:(id)aKey;
-(id)safeNumberForKey:(id)aKey;
-(id)safeStringForKey:(id)aKey;
@end

@interface NSMutableDictionary (PTSwizzleMethod)
-(void)safeSetObject:(id)anObject forKey:(id)aKey;

@end