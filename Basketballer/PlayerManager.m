//
//  PlayerManager.m
//  Basketballer
//
//  Created by Liu Wanwei on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlayerManager.h"

static PlayerManager * sDefaultManager = nil;

@implementation PlayerManager

//@synthesize players = _players;

+ (PlayerManager *)defaultManager{
    if (sDefaultManager == nil) {
        sDefaultManager = [[PlayerManager alloc] init];
    }
    
    return sDefaultManager;
}

- (NSArray *)playersForTeam:(NSNumber *)teamId andNumber:(NSNumber *)number{    
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:kPlayerEntity];
    
    // 查询同一支球队的所有球员。
    NSPredicate * predicate;
    if (number == nil) {
        predicate = [NSPredicate predicateWithFormat:@"team == %d", [teamId integerValue]];
    }else{
        predicate = [NSPredicate predicateWithFormat:@"(team == %d) AND (number == %d)", 
                                                    [teamId integerValue],[number integerValue]];
    }
    request.predicate = predicate;
    
    // 按照号码从小到大排序。
    NSSortDescriptor * sortDescripter = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescripter];
    
    NSError * error = nil;
    NSMutableArray * result = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (nil == result) {
        NSLog(@"Player executeFetchRequest error");
        return nil;
    }else if (result.count == 0) {
        return nil;
    }else {
        return result;
    }
}

- (NSArray *)playersForTeam:(NSNumber *)teamId{
    return [self playersForTeam:teamId andNumber:nil];
}

- (BOOL)numberExistInTeam:(NSNumber *)teamId withNumber:(NSNumber *)number{
    NSArray * result = [self playersForTeam:teamId andNumber:number];
    if (result == nil || result.count == 0) {
        return NO;
    }else{
        return YES;        
    }
}

- (Player *)addPlayerForTeam:(NSNumber *)teamId withNumber:(NSNumber *)number withName:(NSString *)name{
    if ([self numberExistInTeam:teamId withNumber:number]) {
        return nil;
    }
    
    Player * newOne = (Player *)[NSEntityDescription insertNewObjectForEntityForName:kPlayerEntity 
                                                    inManagedObjectContext:self.managedObjectContext];
    
    newOne.id = [BaseManager generateIdForKey:kPlayerEntity];
    
    newOne.team = [teamId copy];
    newOne.number = number;
    newOne.name = name;
    
    if(! [self synchroniseToStore]){
        return nil;
    }
    
    return newOne;
}

- (BOOL)synchroniseToStore{
    if(! [super synchroniseToStore]){
        return NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotification:
            [NSNotification notificationWithName:kPlayerChangedNotification object:nil]];
    
    return YES;
}

- (Player *)updatePlayer:(Player *)player withNumber:(NSNumber *)number andName:(NSString *)name{
    // 修改号码，修改后的号码在球队中已存在时，不允许修改。
    if (! [player.number isEqualToNumber:number] &&
        [self numberExistInTeam:player.team withNumber:number]) {
        return nil;
    }
    
    player.number = number;
    player.name = name;
    
    if( ![self synchroniseToStore]){
        return nil;
    }
    
    return player;
}

- (BOOL)deletePlayer:(Player *)player{
    if (! [self deleteFromStore:player synchronized:YES]) {
        return NO;
    }
    
    return YES;
}

- (Player *)playerWithId:(NSNumber *)id {
    Player * player = nil;
    
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:kPlayerEntity];
    
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"id == %d", 
                     [id integerValue]];

    request.predicate = predicate;
    
    NSError * error = nil;
    NSMutableArray * result = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (nil == result) {
        NSLog(@"Player executeFetchRequest error");
        return nil;
    }else if (result.count == 0) {
        return nil;
    }
    
    player = [result objectAtIndex:0];
    return player;
}

@end