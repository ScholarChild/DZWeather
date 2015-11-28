//
//  DataBaseManager.h
//  UseDataBase
//
//  Created by Ibokan on 15/11/5.
//  Copyright (c) 2015年 Zero. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <sqlite3.h>


/**
 * 查询回调，会在查询（statment)返回结果的每一行皆被调用一次
 *
 * @param rowKeyValues 当前查询行的内容
 * @return 返回值  int 当返回值不为零，查询将被终止，并抛出异常
 *
 */
typedef int (^StatmentCallback)(NSDictionary* rowKeyValues);

/**
 *已知问题：
 * 1.没做多线程安全处理
 * 2.如果多个对象访问同一数据库，可能会出问题
 * 3.还无法处理blob数据
 */
@interface Database : NSObject

@property (assign) StatmentCallback callback;


/**
 * 根据所给的完整文件路径名 打开数据库文件，
 * 文件不存在时将被创建，
 * 若为目录则会抛出异常
 */
- (instancetype)initWithFile:(NSString*)fileName;

/**
 * 通过关闭和重新打开数据库文件，让被中断的事件回滚
 */
- (void)RollBack;

/**
 * 执行 sql，对数据库进行操作或查询,操作失败时会抛出相应的异常信息
 * 该方法不支持blob
 */
- (void)execSql:(NSString*)sql;


- (void)insertData:(NSData*)data withSql:(NSString*)sql;
- (NSArray*)selectDataWithSql:(NSString*)sql;
- (void)updataData:(NSData*)data withSql:(NSString*)sql;

@end


