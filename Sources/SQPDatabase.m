//
//  SQPDatabase.m
//  SQPersist
//
//  Created by Christopher Ney on 29/10/2014.
//  Copyright (c) 2014 Christopher Ney. All rights reserved.
//

#import "SQPDatabase.h"

#define kSQPDefaultDdName @"SQPersist.db"

@interface SQPDatabase ()
- (FMDatabase*)createDatabase;
@end

/**
 *  Database manager.
 */
@implementation SQPDatabase

/**
 *  Get the main instance of the database manager.
 *
 *  @return Instance.
 */
+ (SQPDatabase*)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

/**
 *  Setup the database.
 *
 *  @param dbName Name of the database.
 */
- (void)setupDatabaseWithName:(NSString*)dbName {
 
    _dbName = dbName;
    _database = [self createDatabase];
}

/**
 *  Return the name of the database.
 *
 *  @return Database name.
 */
- (NSString*)getDdName {
    return _dbName;
}

/**
 *  Return the path of the database.
 *
 *  @return Path of the database.
 */
- (NSString*)getDdPath {
    return _dbPath;
}

/**
 *  Create the local SQLite database file (private method).
 *
 *  @return Database connector.
 */
- (FMDatabase*)createDatabase {
    
    if (_dbName == nil) _dbName = kSQPDefaultDdName;
    
    NSString *documentdir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    _dbPath = [documentdir stringByAppendingPathComponent:_dbName];
    
    //NSLog(@"%@", _dbPath);
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    db.logsErrors = YES;
    db.traceExecution = NO;
    
    if (![db open]) {
        return nil;
    } else {
        return db;
    }
}

/**
 *  Database connector.
 *
 *  @return Database connector.
 */
- (FMDatabase*)database {
    
    if (_database == nil) {
        _database = [self createDatabase];
    }
    
    return _database;
}

/**
 *  Check if the database file exists.
 *
 *  @return Return YES if the database exists.
 */
- (BOOL)databaseExists {
 
    if (_dbPath != nil) {
        BOOL isDirectory = NO;
        return [[NSFileManager defaultManager] fileExistsAtPath:_dbPath isDirectory:&isDirectory];
    } else {
        return NO;
    }
}

/**
 *  Remove the database.
 *
 *  @return Remove the database.
 */
- (BOOL)removeDatabase {
    
    if (_dbPath != nil) {
        
        if (_database != nil) {
            [_database close];
        }
        
        NSError *error = nil;
        
        [[NSFileManager defaultManager] removeItemAtPath:_dbPath error:&error];
        
        if (error == nil) {
            _database = nil;
            return YES;
        } else {
            NSLog(@"%@", [error localizedDescription]);
            return NO;
        }
        
    } else {
        return NO;
    }
}

/**
 *  Remember scanned entity.
 *
 *  @param className  Entity class name
 *  @param properties Properties of entity.
 */
- (void)addScannedEntity:(NSString*)className andProperties:(NSArray*)properties {
    
    if (_properties == nil) _properties = [[NSMutableDictionary alloc] init];
    
    if (className != nil && properties != nil) {
        
        if ([self getExistingEntity:className] == nil) {
            [_properties setObject:properties forKey:className];
        }
    }
}

/**
 *  Return YES if the entity is already scanned.
 *
 *  @param entity Entity class name
 *
 *  @return Return YES if the entity is already scanned.
 */
- (NSArray*)getExistingEntity:(NSString*)className {
    
    if (_properties != nil && className != nil) {
        NSArray *properties = (NSArray*)[_properties valueForKey:className];
        return properties;
    } else {
        return nil;
    }
}

/**
 *  Remember the the class is a entity system.
 *
 *  @param className Class name.
 */
- (void)addEntityObjectName:(NSString*)className {
    
    if (_entities == nil) _entities = [[NSMutableSet alloc] init];
    
    if (className != nil) {
        if ([self isEntityObject:className] == NO) {
            [_entities addObject:className];
        }
    }
}

/**
 *  Indique if a class name is know as an entity system.
 *
 *  @param className Class name.
 *
 *  @return Return YES if is an entity.
 */
- (BOOL)isEntityObject:(NSString*)className {
    
    if (_entities != nil && className != nil) {
        return [_entities containsObject:className];
    } else {
        return NO;
    }
}

/**
 *  Begin a SQL Transaction.
 *
 *  @return Result of begin.
 */
- (BOOL)beginTransaction {

    FMDatabase *db = [[SQPDatabase sharedInstance] database];
    
    NSString *sql = @"BEGIN TRANSACTION";
    
    BOOL result = [db executeUpdate:sql];
    
    return result;
}

/**
 *  Commi a SQL Transaction.
 *
 *  @return Result of commit.
 */
- (BOOL)commitTransaction {
    
    FMDatabase *db = [[SQPDatabase sharedInstance] database];
    
    NSString *sql = @"COMMIT";
    
    BOOL result = [db executeUpdate:sql];
    
    return result;
}

/**
 *  Rollback a SQL Transaction.
 *
 *  @return Result of rollback.
 */
- (BOOL)rollbackTransaction {
    
    FMDatabase *db = [[SQPDatabase sharedInstance] database];
    
    NSString *sql = @"ROLLBACK";
    
    BOOL result = [db executeUpdate:sql];
    
    return result;
}

@end
