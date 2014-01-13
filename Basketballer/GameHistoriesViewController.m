//
//  GameHistoriesViewController.m
//  Basketballer
//
//  Created by maoyu on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameHistoriesViewController.h"
#import "PlayGameViewController.h"
#import "GameDetailsViewController.h"
#import "MatchManager.h"
#import "TeamManager.h"
#import "GameSetting.h"
#import "StartGameViewController.h"
#import "GameHistoriesMapViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Feature.h"

@interface GameHistoriesViewController (){
    GameDetailsViewController * _gameDetailsViewController;
    UINavigationController * _gameHistoriesMapViewController;
    
    NSDateFormatter * _dateFormatter;
    NSInteger _selectedRow;
}
@end

@implementation GameHistoriesViewController
@synthesize tvCell = _tvCell;
@synthesize matches = _matches;
@synthesize historyType = _historyType;

#pragma 私有函数
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initNavigationItem {
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startGame)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem * leftItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showGameHistoriesMapView)];
    self.navigationItem.leftBarButtonItem = leftItem;

}

#pragma 事件函数

- (void)showGameHistoriesMapView {
    if (nil == _gameHistoriesMapViewController) {
        GameHistoriesMapViewController * rootViewController = [[GameHistoriesMapViewController alloc] initWithNibName:@"GameHistoriesMapViewController" bundle:nil];
        _gameHistoriesMapViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    }
    
    [[AppDelegate delegate] presentModelViewController:_gameHistoriesMapViewController];
}

- (void)historyChangedHandler:(NSNotification *)notification{
    NSLog(@"got notification: %@", notification.name);
    
    if (notification.object != nil && [notification.object isKindOfClass:[NSNumber class]]) {
        [self.tableView reloadData];
        /*NSMutableArray * tempMatches = [NSMutableArray arrayWithArray:_matches];
        [tempMatches removeObjectAtIndex:_selectedRow];
        self.matches = tempMatches;*/
        
        //NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_selectedRow inSection:0];
        //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _historyType = HistoryTypeTeams;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self initNavigationItem];
    if (_historyType == HistoryTypeTeam) {
         [[Feature defaultFeature] initNavleftBarItemWithController:self withAction:@selector(back)];
        self.title = LocalString(@"Record");
    }else {
        self.matches = [[MatchManager defaultManager] matchesArray];
        self.title = LocalString(@"Histories");
        
    }
   
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    // 添加、删除比赛刷新表
    [nc addObserver:self selector:@selector(historyChangedHandler:) name:kMatchChanged object:nil];
    self.tableView.rowHeight = 48.0f;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_matches == nil) {
        return 0;
    }else{
        return _matches.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MatchRecordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        [[NSBundle mainBundle] loadNibNamed:@"MatchRecordCell" owner:self options:nil];
        cell = _tvCell;
        self.tvCell = nil;
    }
    
    Match * match = [_matches objectAtIndex:indexPath.row];
    
//    UIImage * defaultTeamProfile = [UIImage imageNamed:@"DefaultTeamProfile"];
    UIImage * image;
    Team * team;
    TeamManager * tm = [TeamManager defaultManager];
    
    // 主队图像。
    team = [tm teamWithId:match.homeTeam];
    image = [tm imageForTeam:team];
    UIImageView * homeImageProfile = (UIImageView *)[cell viewWithTag:UIHomeTeamProfileTag];
    homeImageProfile.image = image;
//    homeImageProfile.layer.masksToBounds = YES;
//    homeImageProfile.layer.cornerRadius = 5.0f;    
    
    // 主队名字。    
    UILabel * homeTeamNameLabel = (UILabel *)[cell viewWithTag:UIHomeTeamNameTag];
    homeTeamNameLabel.text = team.name;
    
    // 主队得分。
    UILabel * homeTeamPointsLabel = (UILabel *)[cell viewWithTag:UIHomeTeamPointsTag];
    homeTeamPointsLabel.text = [[match homePoints] stringValue];
    
    // 比赛日期。
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yy-MM-dd"];
    }
    UILabel * dateLabel = (UILabel *)[cell viewWithTag:UIMatchDateTag];
    dateLabel.text = [_dateFormatter stringFromDate:[match date]];
    
    // 比赛时间。
//    if (_timeFormatter == nil) {
//        _timeFormatter = [[NSDateFormatter alloc] init];
//        [_timeFormatter setDateFormat:@"hh:mm"];
//    }
//    UILabel * timeLabel = (UILabel *)[cell viewWithTag:UIMatchTimeTag];
//    timeLabel.text = [_timeFormatter stringFromDate:[match date]];
    
    // 客队图像。
    team = [tm teamWithId:match.guestTeam];
    image = [tm imageForTeam:team];
    UIImageView * guestTeamProfile = (UIImageView *)[cell viewWithTag:UIGuestTeamProfileTag];
    guestTeamProfile.image = image;
//    guestTeamProfile.layer.masksToBounds = YES;
//    guestTeamProfile.layer.cornerRadius = 5.0f;
    
    // 客队名字。
    UILabel * guestTeamNameLabel = (UILabel *)[cell viewWithTag:UIGuestTeamNameTag];
    guestTeamNameLabel.text = team.name;
    
    // 客队得分。
    UILabel * guestTeamPointsLabel = (UILabel *)[cell viewWithTag:UIGuestTeamPointsTag];
    guestTeamPointsLabel.text = [[match guestPoints] stringValue];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[MatchManager defaultManager] deleteMatch:[_matches objectAtIndex:indexPath.row]];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_gameDetailsViewController == nil) {
        _gameDetailsViewController = [[GameDetailsViewController alloc] 
                                      initWithNibName:@"GameDetailsViewController" bundle:nil];
    }
    
    Match * match = [_matches objectAtIndex:indexPath.row];
    
    _gameDetailsViewController.match = match;
    [_gameDetailsViewController reloadActionsInMatch];
    _gameDetailsViewController.hidesBottomBarWhenPushed = YES;    
    [self.navigationController pushViewController:_gameDetailsViewController animated:YES];
    
    // 用于删除比赛后，收到删除消息，刷新当前界面。
    _selectedRow = indexPath.row;
}

@end