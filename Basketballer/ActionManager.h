//
//  ActionManager.h
//  Basketballer
//
//  Created by Liu Wanwei on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseManager.h"
#import "Action.h"
#import "Match.h"

#define kActionEntity       @"Action"
#define kMatchField         @"match"
#define kTeamField          @"team"
#define kPeriodField        @"period"
#define kTimeField          @"time"
#define kTypeField          @"type"

#define kHome               @"home"
#define kGuest              @"guest"

typedef enum {
    ActionTypePoints    = 0,        // 用于搜索所有得分类型事件，并非用于添加、删除事件。
    ActionType1Point    = 1,        // 罚球得分。
    ActionType2Points   = 2,        // 两分球。
    ActionType3Points   = 3,        // 三分球。
    ActionTypeFoul      = 4,        // 犯规。
    ActionTypeTimeout   = 5         // 暂停。
}ActionType;

@protocol FoulActionDelegate <NSObject>
- (void)FoulsBeyondLimit:(NSNumber *)teamId;
@end

@interface ActionManager : BaseManager

// 当前比赛的实时汇总信息。
@property (nonatomic, readonly) NSInteger homeTeamPoints;
@property (nonatomic, readonly) NSInteger homeTeamFouls;
@property (nonatomic, readonly) NSInteger homeTeamTimeouts;

@property (nonatomic, readonly) NSInteger guestTeamPoints;
@property (nonatomic, readonly) NSInteger guestTeamFouls;
@property (nonatomic, readonly) NSInteger guestTeamTimeouts;

@property (nonatomic) NSInteger periodLength;
@property (nonatomic) NSInteger periodTimeoutsLimit;
@property (nonatomic) NSInteger periodFoulsLimit;

@property (nonatomic, strong) NSMutableArray * actionArray; // 当前正进行比赛的action组。

@property (nonatomic, weak) id<FoulActionDelegate> delegate;

+ (ActionManager *)defaultManager;

// 一场比赛中的所有动作。
- (NSMutableArray *)actionsForMatch:(NSInteger)matchId;

// 从一组动作中筛选出某个时间段内的特定动作。
- (NSArray *)actionsWithType:(ActionType)actionType inPeriod:(NSInteger)period inActions:(NSArray *)actions;

// 返回每节比赛某个球队、某项技术统计的累计值数组。
- (NSMutableArray *)summaryForFilter:(NSInteger)filter withTeam:(NSInteger)team inActions:(NSArray *)actions;

- (BOOL)actionForHomeTeamInMatch:(Match *)match withType:(NSInteger)actionType atTime:(NSInteger)time inPeriod:(NSInteger)period;

- (BOOL)actionForGuestTeamInMatch:(Match *)match withType:(NSInteger)actionType atTime:(NSInteger)time inPeriod:(NSInteger)period;

- (BOOL)deleteAction:(Action *)action;
- (BOOL)deleteActionAtIndex:(NSInteger)index;
- (void)deleteActionsInMatch:(NSInteger)matchId;

- (void)resetRealtimeActions:(Match *)match;

- (void)finishMatch:(Match *)match;

@end
