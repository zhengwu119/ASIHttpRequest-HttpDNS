//
//  NSArray+DNS.h
//  StockRadar
//
//  Created by HuJunjian on 16/1/16.
//  Copyright © 2016年 StockRadar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DNS)

- (NSString *)ip;

- (NSUInteger)ttl;

- (NSUInteger)expiredTime;


@end
