//
//  CCDBManager.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/12.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "CCDBManager.h"
#import <FMDB.h>
#import "Constant.h"
#import "NSString+Tool.h"
@interface CCDBManager (){
    FMDatabaseQueue *_dbQueue;
}

@end

@implementation CCDBManager
+ (instancetype)sharedManager
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDataBase];
    }
    return self;
}

- (void)initDataBase{
    //Documents 路径
    NSString *documenPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //db路径
    NSString *dbPath = [documenPath stringByAppendingString:@"shunshousonghuo.db"];
    //获取数据库实例
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    //    [_db executeUpdate:@"create table if not exists USER(id integer primary key autoincrement,name,score,image)"];
    //1.创建表 CREATE TABLE
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS photos (id integer PRIMARY KEY AUTOINCREMENT, filename text NOT NULL, succeed integer NOT NULL);"];
        if (result) {
            NSLog(@"创建照片表成功");
        }else
        {
            NSLog(@"创建照片表失败");
        }
        BOOL result2=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS voices (id integer PRIMARY KEY AUTOINCREMENT, filename text NOT NULL, succeed integer NOT NULL);"];
        if (result2) {
            NSLog(@"创建录音表成功");
        }else
        {
            NSLog(@"创建录音表失败");
        }
    }];
}

- (void)insertPhotoWithfileName:(NSString *)fileName{
    
    if ([self isPhotoExistWithFileName:fileName]) {
        return;
    }
    
    //2.插入数据 INSERT INTO
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"INSERT INTO photos (filename, succeed) VALUES (?, ?);";
        BOOL excult = [db executeUpdate:sql,fileName, @0];
        if (excult) {
            CCLog(@"插入成功");
        }else{
            CCLog(@"插入失败");
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_NEW_PHOTO_UPLOAD_NOTI object:nil];
}

- (void)insertPhotosWithfileNames:(NSArray *)fileNames{
    //2.插入数据 INSERT INTO
    if (fileNames.count==0) {
        return;
    }
    NSMutableArray *sqls = [NSMutableArray array];
    for (NSString *fileName in fileNames) {
        if (![self isPhotoExistWithFileName:fileName]) {
            [sqls addObject:[NSString stringWithFormat:@"INSERT INTO photos (filename, succeed) VALUES ('%@', %@);",fileName,@0]];
        }
    }
    if (sqls.count>0 ) {
        __block NSString *sql = [sqls componentsJoinedByString:@""""];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            BOOL excult = [db executeStatements:sql];
            if (excult) {
                CCLog(@"插入成功");
            }else{
                CCLog(@"插入失败");
            }
        }];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_NEW_PHOTO_UPLOAD_NOTI object:nil];
}

- (NSArray *)getAllUnuploadPhotos{
    //查询数据
    __block NSMutableArray *photos = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 3.执行查询语句
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM photos WHERE succeed = ?",@0];
        // 4.遍历结果
        while ([resultSet next]) {
            NSString *filename = [resultSet stringForColumn:@"filename"];
            [photos addObject:filename];
        }
    }];
    return photos;
}

- (void)photoUplaodSuccedWithFileName:(NSString *)fileName{
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL excult = [db executeUpdate:@"UPDATE photos SET succeed = ? WHERE filename = ? ",@1,fileName];
        if (excult) {
            CCLog(@"更新成功");
        }else{
            CCLog(@"更新失败");
        }
    }];
}


- (BOOL)isPhotoExistWithFileName:(NSString *)fileName{
    __block BOOL isExist = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 3.执行查询语句
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM photos WHERE filename = ?",fileName];
        // 4.遍历结果
        while ([resultSet next]) {
            isExist = YES;
        }
    }];
    return isExist;
}

- (void)deletePhotoWithFileName:(NSString *)fileName{
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL excult = [db executeUpdate:@"DELETE FROM photos WHERE filename = ?", fileName];
        if (excult) {
            CCLog(@"删除成功");
        }else{
            CCLog(@"删除失败");
        }
    }];
}

- (void)deleteAllPhotos{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL excult = [db executeUpdate:@"DELETE FROM photos"];
        if (excult) {
            CCLog(@"删除成功");
        }else{
            CCLog(@"删除失败");
        }
    }];
}

#pragma mark ---------> VOICE

- (void)insertVoiceWithFileName:(NSString *)fileName{
    
    if ([self isVoiceExistWithFileName:fileName]) {
        return;
    }
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"INSERT INTO voices (filename, succeed) VALUES (?, ?);";
        BOOL excult = [db executeUpdate:sql,fileName, @0];
        if (excult) {
            CCLog(@"插入成功");
        }else{
            CCLog(@"插入失败");
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_NEW_VOICE_UPLOAD_NOTI object:nil];
}

- (void)deleteVoiceFileWithFileName:(NSString *)fileName{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL excult = [db executeUpdate:@"DELETE FROM voices WHERE filename = ?", fileName];
        if (excult) {
            CCLog(@"删除成功");
        }else{
            CCLog(@"删除失败");
        }
    }];

}

- (void)voiceUploadSucceedWithFileName:(NSString *)fileName{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL excult = [db executeUpdate:@"UPDATE voices SET succeed = ? WHERE filename = ? ",@1,fileName];
        if (excult) {
            CCLog(@"更新成功");
        }else{
            CCLog(@"更新失败");
        }
    }];
}

- (NSMutableArray *)getAllUnuploadVoices{
    //查询数据
    __block NSMutableArray *voices = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 3.执行查询语句
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM voices WHERE succeed = ?",@0];
        // 4.遍历结果
        while ([resultSet next]) {
            NSString *filename = [resultSet stringForColumn:@"filename"];
            [voices addObject:filename];
        }
    }];
    return voices;
}
- (void)deleteAllVoices{
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL excult = [db executeUpdate:@"DELETE FROM voices"];
        if (excult) {
            CCLog(@"删除成功");
        }else{
            CCLog(@"删除失败");
        }
    }];
}

- (BOOL)isVoiceExistWithFileName:(NSString *)fileName{
    __block BOOL isExist = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 3.执行查询语句
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM voices WHERE filename = ?",fileName];
        // 4.遍历结果
        while ([resultSet next]) {
            isExist = YES;
        }
    }];
    return isExist;
}

- (BOOL)hasUploadFile{
    __block BOOL isExist = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM photos WHERE succeed = ?",@0];
        while ([resultSet next]) {
            isExist = YES;
        }
        FMResultSet *resultSet2 = [db executeQuery:@"SELECT * FROM voices WHERE succeed = ?",@0];
        while ([resultSet2 next]) {
            isExist = YES;
        }
    }];
    return isExist;
}

@end
