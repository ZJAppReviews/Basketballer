//
//  StartGameViewController.h
//  Basketballer
//
//  Created by maoyu on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface StartGameViewController : UITableViewController
@property (nonatomic, weak) IBOutlet UISegmentedControl * gameModeView;
@property (nonatomic, weak) UITableViewCell * teamCell;

- (void)refreshTableData:(Team *) team;
- (IBAction)startGame:(id)sender;
@end
