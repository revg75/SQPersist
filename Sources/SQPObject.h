//
//  SQPObject.h
//  SQPersist
//
//  Created by Christopher Ney on 29/10/2014.
//  Copyright (c) 2014 Christopher Ney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include <objc/objc.h>
#include <objc/NSObjCRuntime.h>
#import <UIKit/UIKit.h>

#import "SQPDatabase.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface SQPObject : NSObject

/**
 *  The name of the entity class.
 */
@property (nonatomic, strong) NSString *SQPClassName;

/**
 *  The name of teh associed table of the entity.
 */
@property (nonatomic, strong) NSString *SQPTableName;

/**
 *  Array of class properties.
 */
@property (nonatomic, strong) NSArray *SQPProperties;

/**
 *  Unique entity object identifier.
 */
@property (nonatomic, strong) NSString *objectID;

/**
 *  Set at YES, if you want remove the entity object.
 *  Need to call the SQPSaveEntity method to apply de DELETE SQL order.
 */
@property (nonatomic) BOOL deleteObject;

/**
 *  Create an entity of your object.
 *
 *  @return Entity object
 */
+ (id)SQPCreateEntity;

/**
 *  Save the modification of the entity object.
 *
 *  @return Return YES if the changes apply with succes.
 */
- (BOOL)SQPSaveEntity;

/**
 *  Return every entities save of table.
 *
 *  @return Array of entities.
 */
+ (NSMutableArray*)SQPFetchAll;

/**
 *  Return every entities save of table, with filtering conditions.
 *
 *  @param queryOptions Filtering conditions (clause SQL WHERE).
 *
 *  @return Array of entities.
 */
+ (NSMutableArray*)SQPFetchAllWhere:(NSString*)queryOptions;

/**
 *  Return every entities save of table, with filtering conditions and order.
 *
 *  @param queryOptions Filtering conditions (clause SQL WHERE).
 *  @param orderOptions Ordering conditions (clause SQL ORDER BY).
 *
 *  @return Array of entities.
 */
+ (NSMutableArray*)SQPFetchAllWhere:(NSString*)queryOptions orderBy:(NSString*)orderOptions;

/**
 *  Return every entities save of table, with filtering conditions and order, and pagination system.
 *
 *  @param queryOptions Filtering conditions (clause SQL WHERE).
 *  @param orderOptions Ordering conditions (clause SQL ORDER BY).
 *  @param pageIndex    Page index (start at 0 value).
 *  @param itemsPerPage Number of items per page.
 *
 *  @return Array of entities.
 */
+ (NSMutableArray*)SQPFetchAllWhere:(NSString*)queryOptions orderBy:(NSString*)orderOptions pageIndex:(NSInteger)pageIndex itemsPerPage:(NSInteger)itemsPerPage;

/**
 *  Return one entity object by filtering conditions.
 *
 *  @param queryOptions Filtering conditions (clause SQL WHERE).
 *
 *  @return The resulting entity object.
 */
+ (id)SQPFetchOneWhere:(NSString*)queryOptions;

/**
 *  Return one entity object.
 *
 *  @param objectID Unique entity object identifier.
 *
 *  @return The resulting entity object.
 */
+ (id)SQPFetchOneByID:(NSString*)objectID;

/**
 *  Return the number of entities save into the associated table.
 *
 *  @return Number of entities.
 */
+ (long long)SQPCountAll;

/**
 *  Return the number of entities save into the associated table, with filtering conditions.
 *
 *  @param queryOptions Filtering conditions (clause SQL WHERE).
 *
 *  @return Number of entities.
 */
+ (long long)SQPCountAllWhere:(NSString*)queryOptions;

/**
 *  Remove all entities of the table (TRUNCATE).
 *
 *  @return Return YES when the table is truncate.
 */
+ (BOOL)SQPTruncateAll;

@end