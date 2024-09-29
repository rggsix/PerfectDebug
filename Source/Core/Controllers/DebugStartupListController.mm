//
//  DebugStartupListController.m
//  PerfectDebug
//
//  Created by perfectword on 2020/11/27.
//

#import "DebugStartupListController.h"

#import "DebugLogDay.h"

#import "DebugLogManager.h"
#import "DebugOnceStart.h"
#import "PerfectDebug.h"
#import "DebugUtil.h"
#import "DebugLogListController.h"


@interface DebugStartupListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<DebugLogDay *> *days;

@end

@implementation DebugStartupListController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        if (@available(iOS 13.0, *)) {
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        } 
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    [DebugLogManager.shared loadLogDayList:^(NSArray<DebugLogDay *> * _Nonnull logDays) {
        self.days = logDays;
        [self.tableView reloadData];
    }];
}

- (void)setupUI {
    self.navigationItem.leftItemsSupplementBackButton = YES;
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:(UIBarButtonItemStylePlain) target:self action:@selector(closeItemClicked)];
    self.navigationItem.leftBarButtonItems = [DGNotNullArray(self.navigationItem.leftBarButtonItems) arrayByAddingObject:closeItem];
    
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:(UIBarButtonItemStylePlain) target:self action:@selector(clearAllLogs)];
    self.navigationItem.rightBarButtonItem = clearItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.days.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.days[section].starts.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.days[section].dateString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    DebugOnceStart *start = self.days[indexPath.section].starts[indexPath.row];
    NSString *text = start.dateString;
    UIColor *color = UIColor.blackColor;
    if (start.isCurrentStartup) {
        color = UIColor.systemBlueColor;
        text = [text stringByAppendingString:@" (本次启动)"];
    }
    
    cell.textLabel.text = text;
    cell.textLabel.textColor = color;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DebugOnceStart *start = self.days[indexPath.section].starts[indexPath.row];

    DebugLogListController *vc = [[DebugLogListController alloc] initWithOnceStart:start];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete){
        DebugOnceStart *start = self.days[indexPath.section].starts[indexPath.row];
        
        [DebugLogManager.shared deleteStart:start complete:^{
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - response func
- (void)closeItemClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearAllLogs {
    //  清空历史的
    [DebugLogManager.shared deleteAllStarts:^{
        [self.tableView reloadData];
    }];
}

@end
