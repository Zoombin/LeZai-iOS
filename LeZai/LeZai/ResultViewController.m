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
#import "PCObject.h"

#define RESULT_PER_PAGE  5

@interface ResultViewController ()

@end

#define INSERT_TIME_ASC    @"InsertTime ASC"
#define INSERT_TIME_DESC   @"InsertTime DESC"
#define KG_PRICE_ASC       @"KG_PRICE ASC"
#define KG_PRICE_DESC      @"KG_PRICE DESC"
#define LM_PRICE_ASC       @"LM_PRICE ASC"
#define LM_PRICE_DESC      @"LM_PRICE DESC"
#define MIN_PRICE_ASC      @"MIN_PRICE DESC"
#define MIN_PRICE_DESC     @"MIN_PRICE DESC"
#define ON_WAY_TIME_ASC    @"ON_WAY_TIME ASC"
#define ON_WAY_TIME_DESC   @"ON_WAY_TIME DESC"

@implementation ResultViewController {
    NSMutableArray *resultArray;
    NSArray *sortArray;
    NSString *sortType;
    int page;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"搜索结果";
        sortType = INSERT_TIME_ASC;
        sortArray = @[INSERT_TIME_ASC, INSERT_TIME_DESC, KG_PRICE_ASC, KG_PRICE_DESC, LM_PRICE_ASC, LM_PRICE_DESC, MIN_PRICE_ASC, MIN_PRICE_DESC, ON_WAY_TIME_ASC, ON_WAY_TIME_DESC];
        resultArray = [[NSMutableArray alloc] init];
        page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *orderButton = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStyleBordered target:self action:@selector(showSortList)];
    [self.navigationItem setRightBarButtonItem:orderButton];
    [self search:nil];
}

- (void)showSortList
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"排序" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布时间(升序)", @"发布时间(降序)", @"运价KG(升序)", @"运价KG(降序)", @"运价立方(升序)", @"运价立方(降序)", @"运价MIN(升序)", @"运价MIN(降序)", @"时效(升序)", @"时效(降序)", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        sortType = sortArray[buttonIndex];
        page = 1;
        [resultArray removeAllObjects];
        [_resultTableView reloadData];
        [self search:nil];
    }
}

- (IBAction)search:(id)sender
{
    [self displayHUD:@"加载中..."];
    [[LZService shared] pcSearchByStartCity:_beginCity
                                    endCity:_endCity
                                   sendDate:_sendDate
                                       sort:sortType
                                       page:page
                                      count:RESULT_PER_PAGE
                                  withBlock:^(NSArray *result) {
        if ([result count] > 0) {
            [self hideHUD:YES];
            [resultArray addObjectsFromArray:[PCObject createWithArray:result]];
            [_resultTableView reloadData];
            if ([result count] == RESULT_PER_PAGE) {
                page++;
                [_resultTableView setTableFooterView:_footView];
            } else {
                [_resultTableView setTableFooterView:nil];
            }
        } else {
            [self displayHUDTitle:nil message:@"无相关结果"];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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
    
}

@end
