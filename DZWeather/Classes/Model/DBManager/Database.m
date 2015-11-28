//
//  DataBaseManager.m
//  UseDataBase
//
//  Created by Ibokan on 15/11/5.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "Database.h"


@interface Database()
{
    sqlite3* database;
    NSString* path;
}
@end

@implementation Database

- (void)RollBack
{
    [self closeDataBase];
    [self tryOpenDataBase:path];
}

- (void)dealloc
{
    [self closeDataBase];
}

- (void)closeDataBase
{
    int resultCode = sqlite3_close(database);
    NSAssert((resultCode == SQLITE_OK),@"%@ detail:%@",
             [self errorReasonByResultCode:resultCode],
             @"close database fail");
}

- (instancetype)initWithFile:(NSString *)fileName
{
    if (self = [super init]) {
        [self tryOpenDataBase:fileName];
        path = fileName;
    }
    return self;
}

- (void)tryOpenDataBase:(NSString*)fileName
{
    [self checkFile:fileName];
    int resultCode = -1;
    const char* dbpath = [fileName UTF8String];
    resultCode = sqlite3_open(dbpath, &database);

    NSString* message = [NSString stringWithFormat:@"path:%@",fileName];
    NSAssert((resultCode == SQLITE_OK),@"%@ detail:%@",[self errorReasonByResultCode:resultCode],message);
}

- (void)checkFile:(NSString*)fileName
{
    BOOL fileNotExists = NO;
    BOOL isDirectory;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    fileNotExists = ![fileManager fileExistsAtPath:fileName isDirectory:&isDirectory];

    if (fileNotExists) {
        NSLog(@"%@ :file not found,a new database file will be created at %@",self,fileName);
    }
    else {
        NSAssert((!isDirectory),@"%@ :the path : \n %@ \n is exist directory,\
                 database can not create or open from here",self,fileName);
    }
}

- (void)execSql:(NSString *)sql
{
    @synchronized(self){
        [self OnOnceThreadToExecSql:sql];
    }
}

- (void)OnOnceThreadToExecSql:(NSString *)sql
{
    char* errMessage = sqlite3_malloc(100);
    int result = sqlite3_exec(database, [sql UTF8String], callbackFunc, (__bridge void *)(self), &errMessage);
    NSString* message = (errMessage == NULL) ? @"nothing" : [NSString stringWithUTF8String:errMessage] ;
    NSAssert((result == SQLITE_OK),@"%@ detail:%@",
             [self errorReasonByResultCode:result],message);
    
    
    sqlite3_free(errMessage);
}

/**
 * 如果返回行中的一个元素为NULL值，那么callback中相应的字符串指针也会是NULL指针。
 */
int callbackFunc (void* obj,int colCount,char** valueCArr,char** keyCArr)
{
    NSMutableDictionary* TempkeyValues = [NSMutableDictionary dictionaryWithCapacity:1];
    for (int col = 0; col < colCount; col++) {
        NSString* key = [NSString stringWithUTF8String:keyCArr[col]];
        NSString* value = [NSString stringWithUTF8String:valueCArr[col]];
        if (!value) value = @"can't read for string";
        [TempkeyValues setObject:value forKey:key];
    }
    NSDictionary* keyValues = [NSDictionary dictionaryWithDictionary:TempkeyValues];
    
    Database* manager = (Database*)(__bridge id)(obj);
    StatmentCallback callback = manager.callback;
    
    int result = 0;
    if (callback) {
        result = callback(keyValues);
    }
    return result;
}

- (void)updataData:(NSData*)data withSql:(NSString*)sql
{
    [self insertData:data withSql:sql];
}

- (void)insertData:(NSData*)data withSql:(NSString*)sql
{
    @synchronized(self){
        int result = 0;
        sqlite3_stmt* stmt = [self prepareStmtWithSql:sql errDetail:@"insert data fail,grammer error"];
    
        result = sqlite3_bind_blob(stmt, 1, [data bytes], (int)[data length], nil);
        NSAssert((result == SQLITE_OK),@"%@ detail:%@",
                 [self errorReasonByResultCode:result],@"insert data fail");
    
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }
}

- (NSArray*)selectDataWithSql:(NSString*)sql
{
    @synchronized(self){
        sqlite3_stmt* stmt = [self prepareStmtWithSql:sql errDetail:@"select data fail,grammer error"];
    
        NSMutableArray* dataArr = [NSMutableArray arrayWithCapacity:1];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const void* bytes = sqlite3_column_blob(stmt, 0);
            const int  length = sqlite3_column_bytes(stmt, 0);
            NSData* data = [NSData dataWithBytes:bytes length:length];
            [dataArr addObject:data];
        }
        sqlite3_finalize(stmt);
        return [NSArray arrayWithArray:dataArr];
    }
}

- (sqlite3_stmt*)prepareStmtWithSql:(NSString*)sql errDetail:(NSString*)detail
{
    sqlite3_stmt* stmt = nil;
    int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil);
    NSAssert((result == SQLITE_OK),@"%@ detail:%@",
             [self errorReasonByResultCode:result],detail);
    NSAssert(!stmt, @"prepare fail,stmt is nil");
    return stmt;
}

- (NSString*)errorReasonByResultCode:(int)resultCode
{
    /*API3REF: Result Codes
     *
     * copy from sqlite3.h
     *
     ** KEYWORDS: SQLITE_OK {error code} {error codes}
     ** KEYWORDS: {result code} {result codes}
     **
     ** Many SQLite functions return an integer result code from the set shown
     ** here in order to indicate success or failure.
     **
     ** New error codes may be added in future versions of SQLite.
     **
     ** See also: [SQLITE_IOERR_READ | extended result codes],
     ** [sqlite3_vtab_on_conflict()] [SQLITE_ROLLBACK | result codes].
     */
    //  SQLITE_OK           0   /* Successful result */
    /* beginning-of-error-codes */
    NSString* errorList = @" \
    * SQLITE_ERROR        1    SQL error or missing database\
    * SQLITE_INTERNAL     2    Internal logic error in SQLite\
    * SQLITE_PERM         3    Access permission denied\
    * SQLITE_ABORT        4    Callback routine requested an abort\
    * SQLITE_BUSY         5    The database file is locked\
    * SQLITE_LOCKED       6    A table in the database is locked\
    * SQLITE_NOMEM        7    A malloc() failed\
    * SQLITE_READONLY     8    Attempt to write a readonly database\
    * SQLITE_INTERRUPT    9    Operation terminated by sqlite3_interrupt()\
    * SQLITE_IOERR       10    Some kind of disk I/O error occurred\
    * SQLITE_CORRUPT     11    The database disk image is malformed\
    * SQLITE_NOTFOUND    12    Unknown opcode in sqlite3_file_control()\
    * SQLITE_FULL        13    Insertion failed because database is full\
    * SQLITE_CANTOPEN    14    Unable to open the database file\
    * SQLITE_PROTOCOL    15    Database lock protocol error\
    * SQLITE_EMPTY       16    Database is empty\
    * SQLITE_SCHEMA      17    The database schema changed\
    * SQLITE_TOOBIG      18    String or BLOB exceeds size limit\
    * SQLITE_CONSTRAINT  19    Abort due to constraint violation\
    * SQLITE_MISMATCH    20    Data type mismatch\
    * SQLITE_MISUSE      21    Library used incorrectly\
    * SQLITE_NOLFS       22    Uses OS features not supported on host\
    * SQLITE_AUTH        23    Authorization denied\
    * SQLITE_FORMAT      24    Auxiliary database format error\
    * SQLITE_RANGE       25    2nd parameter to sqlite3_bind out of range\
    * SQLITE_NOTADB      26    File opened that is not a database file\
    * SQLITE_NOTICE      27    Notifications from sqlite3_log()\
    * SQLITE_WARNING     28    Warnings from sqlite3_log()\
    * SQLITE_ROW         100   sqlite3_step() has another row ready\
    * SQLITE_DONE        101   sqlite3_step() has finished executing\
    */";
    /* end-of-error-codes */
    
    NSString* regular = [NSString stringWithFormat:@"\\* \\w+[ ]+%d[^\\*]+\\*",resultCode];
    NSRange messageRange = [errorList rangeOfString:regular options:NSRegularExpressionSearch];
    NSString* message = [NSString stringWithFormat:@"UNKNOW_ERROR: undefine error"];
    
    if (messageRange.location != NSNotFound) {
        message = [errorList substringWithRange:messageRange];
        
        NSRange numberRange = [message rangeOfString:@"[ ]+\\d+[ ]+" options:NSRegularExpressionSearch];
        message = [message stringByReplacingCharactersInRange:numberRange withString:@":"];
        NSRange headRange = [message rangeOfString:@"\\*[ ]+" options:NSRegularExpressionSearch];
        message = [message stringByReplacingCharactersInRange:headRange withString:@""];
        NSRange footerRange = [message rangeOfString:@"[ ]+\\*" options:NSRegularExpressionSearch];
        message = [message stringByReplacingCharactersInRange:footerRange withString:@""];
    }
    return message;
}

@end







