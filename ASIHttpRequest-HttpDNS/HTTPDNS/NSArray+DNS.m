//
//  NSArray+DNS.m
//  StockRadar
//
//  Created by HuJunjian on 16/1/16.
//  Copyright © 2016年 StockRadar. All rights reserved.
//

#import "NSArray+DNS.h"

@implementation NSArray (DNS)


- (NSString *)ip{
    if (self.count > 1) {
        return [self firstObject];
    }
    return nil;
}


- (NSUInteger)ttl{
    if (self.count >= 2) {
        return [[self objectAtIndex:1] integerValue];
    }
    return 0;
}

- (NSUInteger)expiredTime{
    if (self.count >= 3) {
        return [[self objectAtIndex:2] integerValue];
    }
    return 0;
}

@end
