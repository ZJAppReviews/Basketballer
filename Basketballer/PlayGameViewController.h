//
//  PlayGameViewController.h
//  Basketballer
//
//  Created by maoyu on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import <AudioToolbox/AudioToolbox.h>
@class  OperateGameViewController;

@interface PlayGameViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel * gameTimeLable;
@property (nonatomic, weak) IBOutlet UIBarButtonItem * playBarItem;
@property (nonatomic, weak) IBOutlet UIView * gameTimeView;
@property (nonatomic, weak) OperateGameViewController * operateGameView1;
@property (nonatomic, weak) OperateGameViewController * operateGameView2;
@property (nonatomic, weak) NSTimer * countDownTimer;
@property (nonatomic, strong) NSDate * targetTime;
@property (nonatomic, strong) NSDate * lastTimeoutTime;
@property (nonatomic) NSInteger gameState; 
@property (nonatomic, weak) Team * hostTeam;
@property (nonatomic, weak) Team * guestTeam;
@property (nonatomic, weak) NSString * gameMode;
@property (nonatomic) NSInteger curPeroid;
@property (nonatomic, readwrite) CFURLRef soundFileURLRef;
@property (nonatomic, readonly) SystemSoundID soundFileObject;


- (IBAction)startGame:(id)sender;
- (IBAction)stopGame:(id)sender;

@end
