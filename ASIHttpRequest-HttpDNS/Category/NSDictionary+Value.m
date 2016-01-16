//
//  NSDictionary+Value.m
//  StockRadar
//
//  Created by HuJunjian on 15/12/14.
//  Copyright © 2015年 StockRadar. All rights reserved.
//

#import "NSDictionary+Value.h"

@implementation NSDictionary (Value)
- (NSInteger)getIntegerValueWithKey:(NSString *)key{
    id value = [self objectForKey:key];
    if (value && [value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    }
    return 0;
}

- (NSString *)getStringValueWithKey:(NSString *)key{
    id value = [self objectForKey:key];
    if (value && [value isKindOfClass:[NSString class]]) {
        return value;
    }
    if ([value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", value];
}

- (float)getFloatValueWithKey:(NSString *)key{
    id value = [self objectForKey:key];
    if (value && [value respondsToSelector:@selector(floatValue)]) {
        return [value floatValue];
    }
    return 0;
}

- (double)getDoubleValueWithKey:(NSString *)key{
    id value = [self objectForKey:key];
    if (value && [value respondsToSelector:@selector(doubleValue)]) {
        return [value doubleValue];
    }
    return 0;
}

- (NSArray *)getArrayValueWithKey:(NSString *)key{
    id value = [self objectForKey:key];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)getDictionaryValueWithKey:(NSString *)key{
    id value = [self objectForKey:key];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}
@end
