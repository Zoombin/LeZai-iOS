//
//  ResultViewController.m
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "ResultViewController.h"
#import "LZService.h"
#import "PcSearchCell.h"
#import "UIViewController+HUD.h"

@interface ResultViewController ()

@end

@implementation ResultViewController {
    NSMutableArray *resultArray;
    int page;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"搜索结果";
        resultArray = [[NSMutableArray alloc] init];
        page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayHUD:@"加载中..."];
    [[LZService shared] pcSearchByStartCity:_beginCity endCity:_endCity sendDate:_sendDate page:1 count:5 withBlock:^(NSArray *result) {
        if (result &&[result count] > 0) {
            [self hideHUD:YES];
            [resultArray removeAllObjects];
            [resultArray addObjectsFromArray:result];
            [_resultTableView reloadData];
            if ([result count] == 5) {
                page++;
                [_resultTableView setTableFooterView:_footView];
            } else {
                [_resultTableView setTableFooterView:nil];
            }
        } else {
            [self displayHUDTitle:nil message:@"无相关结果"];
            NSLog(@"无相关结果");
        }
    }];
}

- (IBAction)loadMore:(id)sender
{
    [self displayHUD:@"加载中..."];
    [[LZService shared] pcSearchByStartCity:_beginCity endCity:_endCity sendDate:_sendDate page:page count:5 withBlock:^(NSArray *result) {
        if (result &&[result count] > 0) {
            [self hideHUD:YES];
            [resultArray addObjectsFromArray:result];
            [_resultTableView reloadData];
            if ([result count] == 5) {
                page++;
                [_resultTableView setTableFooterView:_footView];
            } else {
                [_resultTableView setTableFooterView:nil];
            }
        } else {
            [self displayHUDTitle:nil message:@"无相关结果"];
            NSLog(@"无相关结果");
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PcSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"PcSearchCell" owner:self options: nil];
        cell = [nib objectAtIndex:0];
    }
    [cell updateInfo:resultArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
}

@end
