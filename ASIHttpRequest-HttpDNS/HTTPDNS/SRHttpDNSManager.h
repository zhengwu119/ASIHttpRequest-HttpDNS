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
/*!
 *  @brief 把域名信息置为过期
 *
 *  @param domain 过期的域名
 */
- (void)invalidateDomain:(NSString *)domain;
/*!
 *  @brief 更新域名信息
 *
 *  @param domain 需要更新的域名
 */
- (BOOL)updateDomain:(NSString *)domain;

@end
