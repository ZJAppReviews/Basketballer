//
//  BDActionTableController.h
//  Basketballer
//
//  Created by sungeo on 15/3/6.
//
//

#import <Foundation/Foundation.h>

@interface BCActionTableController : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, weak) UIViewController * superViewController;

- (void)clearRowSelection;

@end
