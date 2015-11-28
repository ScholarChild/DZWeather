//
//  DBManagerFactory.h
//  UseDataBase
//
//  Created by Ibokan on 15/11/8.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"
@interface DatabaseFactory : NSObject

//不要试图新建一个该类的实例，而应该用这个实例方法获取单例
+ (instancetype)shareInstance;
- (Database*)managerWithPath:(NSString*)filePath;

@end
