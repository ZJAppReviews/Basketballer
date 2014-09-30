//
//  BaseManager.h
//  Basketballer
//
//  Created by Liu Wanwei on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseManager : NSObject

@property (nonatomic, weak) NSManagedObjectContext * managedObjectContext;

- (NSArray *)loadWithEntity:(NSString *)entity;

- (BOOL)synchroniseToStore;
- (BOOL)deleteFromStore:(id)record synchronized:(BOOL)synchronized;

+ (NSNumber *)generateIdForKey:(NSString *)key;

@end
