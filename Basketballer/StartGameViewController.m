//
//  StartGameViewController.m
//  Basketballer
//
//  Created by maoyu on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StartGameViewController.h"
#import "TeamChoiceViewController.h"
#import "TeamManager.h"
#import "PlayGameViewController.h"
#import "GameSetting.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface StartGameViewController () {
    NSArray * _sectionsTitle;
    Team * _hostTeam;
    Team * _guestTeam;
    NSInteger _curClickRowIndex;
}
@end

@implementation StartGameViewController

@synthesize gameModeView = _gameModeView;
@synthesize teamCell = _teamCell;

#pragma 私有函数
/*显示提示信息*/
- (void)showAlertView:(NSString *) message{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
    [alertView show];
}

/*初始化赛事模式*/
- (void)initGameModeView {
    NSArray * modes = [[GameSetting defaultSetting] gameModeNames];
    if(modes != nil) {
        NSInteger size = [modes count];
        for (NSInteger index = 0; index < size; index++) {
            [self.gameModeView setTitle:[modes objectAtIndex:index] forSegmentAtIndex:index];
        }
    }
}

- (void)dismissMyself{

    [[AppDelegate delegate].navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma 类成员函数
- (void)refreshTableData:(Team *) team{
    if(team == nil) {
        return;
    }
    if(_curClickRowIndex == 0) {
        _hostTeam = team;
    }else if(_curClickRowIndex == 1){
        _guestTeam = team;
    }
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:_curClickRowIndex];
    UITableViewCell  *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIImageView * profileImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel * label = (UILabel *)[cell viewWithTag:2]; 
    profileImageView.image = [[TeamManager defaultManager] imageForTeam:team];
    label.text = team.name;
}

#pragma 事件函数
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem * item;
    item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered
                                           target:self action:@selector(dismissMyself)];
    self.navigationItem.leftBarButtonItem = item;    
    [self setTitle:@"开始比赛"];
    _sectionsTitle = [NSArray arrayWithObjects:@"主队",@"客队",nil];
    [self initGameModeView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super   viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)startGame:(id)sender {
    if (_hostTeam == nil || _guestTeam == nil) {
        [self showAlertView:@"请选择球队信息"];
        return;
    }
    
    if(_hostTeam == _guestTeam) {
        [self showAlertView:@"不能选择相同球队进行比赛"];
        return;
    }
    
    PlayGameViewController * playGameViewController = [[PlayGameViewController alloc] initWithNibName: @"PlayGameViewController" bundle:nil];
    playGameViewController.hostTeam = _hostTeam;
    playGameViewController.guestTeam = _guestTeam;
    playGameViewController.gameMode = (self.gameModeView.selectedSegmentIndex == 0 ? kGameModeTwoHalf : kGameModeFourQuarter);
    [self.navigationController pushViewController:playGameViewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionsTitle objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView * profileImageView;
    if(cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [[NSBundle mainBundle] loadNibNamed:@"TeamRecordCell" owner:self options:nil];
        cell = _teamCell;
        self.teamCell = nil;
        
        // 图片圆角化。
        profileImageView = (UIImageView *)[cell viewWithTag:1];
        profileImageView.layer.masksToBounds = YES;
        profileImageView.layer.cornerRadius = 5.0f;
        profileImageView.frame = CGRectMake(2.0, 1.0, 42.0, 42.0);
    }
    profileImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel * label = (UILabel *)[cell viewWithTag:2]; 
    Team * team = [[TeamManager defaultManager].teams objectAtIndex:indexPath.section];
    if (indexPath.section == 0) {
        _hostTeam = team;
    }else {
        _guestTeam = team;
    }
    
    profileImageView.image = [[TeamManager defaultManager] imageForTeam:team];
    label.text = team.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _curClickRowIndex = indexPath.section;
    TeamChoiceViewController *teamChoiceViewController = [[TeamChoiceViewController alloc] initWithNibName:@"TeamChoiceViewController" bundle:nil];
    teamChoiceViewController.parentController = self;
    [self.navigationController pushViewController:teamChoiceViewController animated:YES];
}

@end
