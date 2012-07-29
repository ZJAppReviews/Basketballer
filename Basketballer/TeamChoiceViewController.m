//
//  TeamChoiceViewController.m
//  Basketballer
//
//  Created by maoyu on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TeamManager.h"
#import "TeamChoiceViewController.h"
#import "StartGameViewController.h"
#import "EditTeamInfoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TeamChoiceViewController (){
    UIBarButtonItem * _rightBarButtonItem;
}
@end

@implementation TeamChoiceViewController
@synthesize parentController = _parentController;
@synthesize teamCell = _teamCell;
@synthesize viewControllerMode = _viewControllerMode;

- (void)addTeam{
    [self editTeam:nil];
}

- (void)editTeam:(Team *)team{
    EditTeamInfoViewController * editTeam = [[EditTeamInfoViewController alloc] initWithNibName:@"EditTeamInfoViewController" bundle:nil];
    if (nil == team) {
        editTeam.operateMode = Insert;
    }else{
        editTeam.operateMode = Update;
        editTeam.team = team;
    }
    [self.navigationController pushViewController:editTeam animated:YES];
}

- (void)teamChangedHandler:(NSNotification *)notification{
    NSLog(@"TeamChoiceViewController before handle %@", notification.name);
    [self.tableView reloadData];
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
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(teamChangedHandler:) name:kTeamChanged object:nil];    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_viewControllerMode == UITeamChoiceViewControllerModeChoose) {
        self.navigationItem.rightBarButtonItem = nil;
        [self setTitle:@"球队列表"];
    }else{
        if (nil == _rightBarButtonItem) {
            _rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTeam)];
        }
        self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    NSArray * teams = [TeamManager defaultManager].teams;
    return teams.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView * profileImageView;
    UILabel * label = (UILabel *)[cell viewWithTag:2]; 
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TeamRecordCell" owner:self options:nil];
        cell = _teamCell;
        self.teamCell = nil;
        
        // 图片圆角化。
        profileImageView = (UIImageView *)[cell viewWithTag:1];
        profileImageView.layer.masksToBounds = YES;
        profileImageView.layer.cornerRadius = 5.0f;
        profileImageView.frame = CGRectMake(5.0, 5.0, 60.0, 60.0);
        
        label = (UILabel *)[cell viewWithTag:2]; 
        label.frame = CGRectMake(80.0, 25.0, 200.0, 21.0);
    }
    profileImageView = (UIImageView *)[cell viewWithTag:1];
    label = (UILabel *)[cell viewWithTag:2]; 
    NSArray * teams = [[TeamManager defaultManager] teams];
    Team * team = [teams objectAtIndex:indexPath.row];
    profileImageView.image = [[TeamManager defaultManager] imageForTeam:team];
    label.text = team.name;
    
    label = (UILabel *)[cell viewWithTag:3];
    label.hidden = YES;
    
    if (_viewControllerMode == UITeamChoiceViewControllerModeSet) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
   
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * teams = [[TeamManager defaultManager] teams];
    Team * team = [teams objectAtIndex:indexPath.row];

    if (_viewControllerMode == UITeamChoiceViewControllerModeSet) {
        [self editTeam:team];   
    }else{        
        [self.parentController refreshTableData:team];
        [self.navigationController popViewControllerAnimated:YES];        
    }
}

@end
