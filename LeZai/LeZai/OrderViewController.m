//
//  OrderViewController.m
//  LeZai
//
//  Created by 颜超 on 14-2-8.
//  Copyright (c) 2014年 颜超. All rights reserved.
//

#import "OrderViewController.h"
#import "LZService.h"
#import "UIViewController+HUD.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+ZBUtilites.h"

#define SEARCH_HISTORY  @"search_history"

@interface OrderViewController ()

@end

@implementation OrderViewController {
    NSMutableArray *historyArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"订单状态跟踪";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"order_search_hl"] withFinishedUnselectedImage:[UIImage imageNamed:@"order_search"]];
        historyArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_HISTORY];
    if (arr && [arr count] > 0) {
        [historyArray addObjectsFromArray:arr];
    }
    
    [_searchButton.layer setCornerRadius:7];
    
    [_resultTableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_resultTableView.layer setBorderWidth:.5];
    
    [_resultTextView.layer setCornerRadius:7];
    [_resultTextView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_resultTextView.layer setBorderWidth:.5];
}

- (IBAction)hidenKeyBoard:(id)sender
{
    [_searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:YES animated:YES];
    [_resultTableView setHidden:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_resultTableView setHidden:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //1310221000001
    [self searchOrder:nil];
}

- (IBAction)searchOrder:(id)sender
{
    [self hidenKeyBoard:nil];
    if ([_searchBar.text areAllCharactersSpace]) {
        [self displayHUDTitle:nil message:@"请输入订单号!"];
        return;
    }
    [self displayHUD:@"加载中..."];
    [[LZService shared] searchOrderByOrderNO:_searchBar.text withBlock:^(NSString *result) {
        if (result) {
            [_resultTextView setText:result];
            if ([historyArray containsObject:_searchBar.text]) {
                [historyArray removeObject:_searchBar.text];
            }
            [historyArray insertObject:_searchBar.text atIndex:0];
            [_resultTableView reloadData];
            [[NSUserDefaults standardUserDefaults] setObject:historyArray forKey:SEARCH_HISTORY];
            [self hideHUD:YES];
        } else {
            [self displayHUDTitle:nil message:@"未获取到相关信息" duration:1.0];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [historyArray count] >= 3 ? 3 : [historyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", historyArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _searchBar.text = [NSString stringWithFormat:@"%@", historyArray[indexPath.row]];
    [self searchOrder:nil];
}

@end
