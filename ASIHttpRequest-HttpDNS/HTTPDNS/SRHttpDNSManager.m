//
//  SRHttpDNSManager.m
//  StockRadar
//
//  Created by HuJunjian on 16/1/16.
//  Copyright © 2016年 StockRadar. All rights reserved.
//

#import "SRHttpDNSManager.h"
#import "NSArray+DNS.h"
#import "NSDictionary+Value.h"
#import <libkern/OSAtomic.h>
#import "Reachability.h"
#import "ASIHTTPRequest.h"

static NSString *dnsPodServerIP = @"119.29.29.29";

static SRHttpDNSManager *dnsManager;

@interface SRHttpDNSManager ()

@property (nonatomic, strong) NSString *dnsConfigPath;
@property (nonatomic, strong) NSMutableDictionary *dnsDataSource;
@property (nonatomic, assign) OSSpinLock lock;
@property (nonatomic, strong) Reachability *reachability;

@end


@implementation SRHttpDNSManager

- (instancetype)init{
    self = [super init];
    if (self) {
        _lock = OS_SPINLOCK_INIT;
        [self initDataSource];
        _reachability = [Reachability reachabilityWithHostName:dnsPodServerIP];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

- (void)initDataSource{
    
#ifdef DEBUG
    NSString *fileName = @"dns-debug";
#else
    NSString *fileName = @"dns-release";
#endif
    _dnsConfigPath = [NSString stringWithFormat:@"%@/%@", [self dnsConfigDocuPath], fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_dnsConfigPath]) {
        NSString *src = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        NSError *error = nil;
        [fileManager copyItemAtPath:src toPath:_dnsConfigPath error:&error];
    }
    _dnsDataSource = [[NSMutableDictionary alloc] initWithContentsOfFile:_dnsConfigPath];
    if (_dnsDataSource == nil) {
        _dnsDataSource = [[NSMutableDictionary alloc] init];
    }
}

- (NSString *)dnsConfigDocuPath{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (pathArray.count > 0) {
        return [pathArray firstObject];
    }
    return nil;
}

- (NSArray *)synchronizeRecordWithDomain:(NSString *)domain{
    if (![_reachability isReachable]) {
        return nil;
    }
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/d?dn=%@&ttl=1", dnsPodServerIP, domain];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    if (url == nil) {
        return nil;
    }
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:2];
    request.useHTTPDNS = NO;
    [request startSynchronous];
    if (request.responseStatusCode != 200) {
        return nil;
    }
    NSArray *resultArray = [request.responseString componentsSeparatedByString:@","];
    
    if (resultArray.count < 2) {
        return nil;
    }
    NSString *ip = [resultArray objectAtIndex:0];
    if ([ip rangeOfString:@";"].location != NSNotFound) {
        // 返回多个IP的时候，随机分配
        NSArray *ipArray = [ip componentsSeparatedByString:@";"];
        ip = [ipArray objectAtIndex:(rand() % ipArray.count)];
    }
    NSUInteger ttl = [[resultArray objectAtIndex:1] integerValue];
    // 将TTL的更新缩短75%
    NSArray *ipItem = [NSArray arrayWithObjects:ip, @(ttl), @(time(NULL) + (int)(ttl * 0.75)), nil];
    [self updateLocalCache:domain value:ipItem];
    return ipItem;
}


- (void)updateLocalCache:(NSString *)domain value:(NSArray *)ipItem{
    // 更新内存中的IP信息
    OSSpinLockLock(&_lock);
    [_dnsDataSource setObject:ipItem forKey:domain];
    OSSpinLockUnlock(&_lock);
}

// 网络发生变化的时候更新缓存
- (void)networkChanged:(NSNotification *)notification{
    NSArray *keySet = [_dnsDataSource allKeys];
    // 设置成过期
    for (NSString *key in keySet) {
        [self invalidateDomain:key];
    }
}

- (void)dealloc{
    // 对象释放的时候保存到本地
    OSSpinLockLock(&_lock);
    [_dnsDataSource writeToFile:_dnsConfigPath atomically:YES];
    OSSpinLockUnlock(&_lock);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public

+ (instancetype)sharedInstance{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        dnsManager = [[SRHttpDNSManager alloc] init];
    });
    return dnsManager;
}

// 获取域名对应的IP
- (NSString *)getIPWithDomain:(NSString *)domain{
    if (domain == nil) {
        return nil;
    }
    NSString *ip = nil;
    NSArray *ipItem = [_dnsDataSource getArrayValueWithKey:domain];
    // 域名对应的IP信息不存在或者已过去，去DNSPOD同步数据
    if (ipItem == nil || ipItem.expiredTime < time(NULL)) {
        NSArray *item = [self synchronizeRecordWithDomain:domain];
        // 如果同步失败，使用缓存中的
        ipItem = item == nil ? ipItem : item;
    }
    ip = ipItem.ip;
    return ip;
}
// 将域名置为过期
- (void)invalidateDomain:(NSString *)domain{
    NSArray *ipItem = [_dnsDataSource getArrayValueWithKey:domain];
    NSMutableArray *changedIpItem = [ipItem mutableCopy];
    if (changedIpItem.count > 2) {
        [changedIpItem replaceObjectAtIndex:2 withObject:@(0)];
    }
    [_dnsDataSource setObject:changedIpItem forKey:domain];
}

- (BOOL)updateDomain:(NSString *)domain{
    return [self synchronizeRecordWithDomain:domain] != nil;
}

@end