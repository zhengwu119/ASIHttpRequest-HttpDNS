//
//  NSDictionary+Value.h
//  StockRadar
//
//  Created by HuJunjian on 15/12/14.
//  Copyright © 2015年 StockRadar. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  @brief 获取NInteger值
 *
 *  @param _dict 字典对象
 *  @param _key  key
 *
 *  @return NSInteger
 */
#define GINT(_dict, _key) [_dict getIntegerValueWithKey: _key]
/*!
 *  @brief 获取NSString值
 *
 *  @param _dict 字典对象
 *  @param _key  key
 *
 *  @return NSString
 */
#define GSTR(_dict, _key) [_dict getStringValueWithKey: _key]
/*!
 *  @brief 获取CGFloat值
 *
 *  @param _dict 字典对象
 *  @param _key  key
 *
 *  @return CGFloat
 */
#define GFLOAT(_dict, _key) [_dict getFloatValueWithKey: _key]
/*!
 *  @brief 获取double值
 *
 *  @param _dict 字典对象
 *  @param _key  key
 *
 *  @return double
 */
#define GDOUB(_dict, _key) [_dict getDoubleValueWithKey: _key]
/*!
 *  @brief 获取NSArray值
 *
 *  @param _dict 字典对象
 *  @param _key  key
 *
 *  @return NSArray
 */
#define GARRAY(_dict, _key) [_dict getArrayValueWithKey: _key]
/*!
 *  @brief 获取NSDicationary值
 *
 *  @param _dict 字典对象
 *  @param _key  key
 *
 *  @return NSDicationary
 */
#define GDICT(_dict, _key) [_dict getDictionaryValueWithKey: _key]



@interface NSDictionary (Value)
/*!
 *  @brief 获取NSInteger值
 *
 *  @param key 对应的key
 *
 *  @return 如果不存在key对应的value则返回0
 */
- (NSInteger)getIntegerValueWithKey:(NSString *)key;
/*!
 *  @brief 获取NSString对象
 *
 *  @param key 对应的key
 *
 *  @return NSString对象 如果不存在key对应的value则返回""
 */
- (NSString *)getStringValueWithKey:(NSString *)key;
/*!
 *  @brief 获取CGFloat值
 *
 *  @param key 对应的key
 *
 *  @return 如果不存在key对应的value则返回0.0
 */
- (float)getFloatValueWithKey:(NSString *)key;
/*!
 *  @brief 获取double
 *
 *  @param key 对应的key
 *
 *  @return 如果不存在key对应的value则返回0.0
 */
- (double)getDoubleValueWithKey:(NSString *)key;
/*!
 *  @brief 获取NSArray对象
 *
 *  @param key 对应的key
 *
 *  @return NSArray对象 如果不存在key对应的value则返回nil
 */
- (NSArray *)getArrayValueWithKey:(NSString *)key;
/*!
 *  @brief 获取NSDicationary对象
 *
 *  @param key 对应的key
 *
 *  @return NSDicationary对象 如果不存在key对应的value则返回nil
 */
- (NSDictionary *)getDictionaryValueWithKey:(NSString *)key;

@end
