//
//  SRHttpDNSManager.h
//  StockRadar
//
//  Created by HuJunjian on 16/1/16.
//  Copyright © 2016年 StockRadar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRHttpDNSManager : NSObject
/*!
 *  @brief 获取DNS数据源实例
 *
 *  @return
 */
+ (instancetype)sharedInstance;
/*!
 *  @brief 获取域名对应的IP
 *
 *  @param domain 需要解析的域名
 *
 *  @return IP地址
 */
- (NSString *)getIPWithDomain:(NSString *)domain;

@end
