//
//  PlayGameViewController.h
//  Basketballer
//
//  Created by maoyu on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "LocationManager.h"
#import <MapKit/MapKit.h>
#import "MatchUnderWay.h"

@class  TeamStatistics;

@interface PlayGameViewController : UIViewController <UIActionSheetDelegate,UIAlertViewDelegate,FoulActionDelegate,LocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel * gameTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * gamePeroidLabel;
@property (nonatomic, weak) IBOutlet UILabel * gameHostScoreLable;
@property (nonatomic, weak) IBOutlet UILabel * gameGuestScoreLable;
@property (nonatomic, weak) IBOutlet UIButton * gamePeroidButton;
@property (nonatomic, weak) IBOutlet UIButton * controlButton;
@property (nonatomic, weak) IBOutlet UIImageView * hostImageView;   // 主队球队头像
@property (nonatomic, weak) IBOutlet UIImageView * guestImageView;  // 客队球队头像
@property (nonatomic, weak) IBOutlet UILabel * hostNameLabel;       // 主队队名
@property (nonatomic, weak) IBOutlet UILabel * guestNameLabel;      // 客队队名
@property (nonatomic, weak) IBOutlet UILabel * hostFoulLabel;       // 主队犯规次数
@property (nonatomic, weak) IBOutlet UILabel * guestFoulLabel;      // 客队犯规次数
@property (nonatomic, weak) IBOutlet UILabel * foulLabel;           // 犯规区域名字
@property (nonatomic, weak) IBOutlet UILabel * hostTimeoutLabel;    // 主队暂停次数
@property (nonatomic, weak) IBOutlet UILabel * guestTimeoutLabel;   // 客队暂停次数
@property (nonatomic, weak) IBOutlet UILabel * timeoutLabel;        // 暂停区域名字
@property (nonatomic, weak) IBOutlet UIView * foulView;             // 犯规背景区域
@property (nonatomic, weak) IBOutlet UIView * timeoutView;          // 暂停背景区域
@property (nonatomic, weak) IBOutlet UIImageView * teamBackgroundImageView; // 球队背景图
@property (nonatomic, weak) IBOutlet UIButton * settingButton;
@property (nonatomic, weak) IBOutlet UIButton * operationButton;
@property (nonatomic, weak) IBOutlet UIButton * statisticButton;
@property (nonatomic, weak) IBOutlet UIButton * musicButton;

@property (nonatomic, weak) NSTimer * timeCountDownTimer;
@property (nonatomic, weak) Team * hostTeam;
@property (nonatomic, weak) Team * guestTeam;
@property (nonatomic, weak) TeamStatistics * selectedStatistics;

- (void)startGame;
- (void)stopGame:(MatchState)mode withWinTeam:(NSNumber *)teamId;

- (IBAction)showActionRecord:(id)sender;
- (IBAction)changePeriod:(UIButton *)sender;
- (IBAction)addAction:(UIButton *)sender;
- (IBAction)showGameSettingView:(id)sender;
- (IBAction)controlNeatMatchTime:(id)sender;

- (void)pauseCountdownTime;

- (void)initWithHostTeam:(Team *)hostTeam andGuestTeam:(Team *)guestTeam;

- (void)dismissView;

@end
