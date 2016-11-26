//
//  TransactionViewController.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "TransactionViewController.h"
#import "UIColor+Additions.h"
#import "TransactionCell.h"
#import "SVProgressHUD.h"
#import "Transaction.h"
#import "Constants.h"
#import "ChartView.h"
#import "Services.h"
#import "Chart.h"
#import "Util.h"
#import <QuartzCore/QuartzCore.h>

@interface TransactionViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ChartView *view_chart;

@end

@implementation TransactionViewController

#pragma mark - LifeCycle

- (id)init
{
    self = (TransactionViewController*)[self initWithNibName:@"TransactionViewController" bundle:nil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_table addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    _view_chart = [[ChartView alloc] initWithDataSource:nil];
    _table.tableHeaderView = _view_chart;

    [self refreshTable];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"HISTÓRICO DE ENVIOS";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [Util drawBackgroundView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowSize;
}

#pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TransactionCell";
    
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[TransactionCell alloc] init];
    }
    
    Transaction *transaction = _dataSource[indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@",transaction.contact.name];
    cell.lbl_name.text = name;
    cell.lbl_tel.text = transaction.contact.tel;
    cell.imgv_photo.image = transaction.contact.img_photo;

    CALayer *imageLayer = cell.imgv_photo.layer;
    [imageLayer setCornerRadius:cell.imgv_photo.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    
    [Util circleFilledWithOutline:cell.imgv_photo fillColor:[UIColor clearColor] outlineColor:[UIColor neon_lineLightColor] andLineWidth:3];
    
    NSString *number = [Util formatNumber:transaction.value];
    cell.lbl_value.text = [NSString stringWithFormat:@"R$ %@",number];

    return cell;
}

#pragma mark - Private Methods

-(void)refreshTable
{
    __typeof(self) __weak weakSelf = self;
    self.view.window.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"Aguarde..."];
    [Services getTransfers:^(NSArray *result, NSError *error)
     {
         self.view.window.userInteractionEnabled = YES;
         [weakSelf.refreshControl endRefreshing];
         if (result && !error) {
             NSMutableArray *dataSource = [NSMutableArray arrayWithArray:result];
             weakSelf.dataSource = dataSource;
             [weakSelf refreshHeaderView:dataSource];
             [weakSelf.table reloadData];
         }else{
             [[[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Erro. Tente novamente mais tarde!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
         }
         [SVProgressHUD dismiss];
         [_refreshControl endRefreshing];
     }];
}

-(void)refreshHeaderView:(NSArray*)result
{
    [_view_chart setDataSource:[self getChartDataSource:result]];
    [_view_chart refresh];
}

-(NSArray*)getChartDataSource:(NSArray*)transactions
{
    NSMutableDictionary *ordered = [NSMutableDictionary dictionary];
    for (Transaction *transaction in transactions)
    {
        Chart *chart = [ordered objectForKey:transaction.contact.clientID];
        if (chart) {
            chart.value += transaction.value;
        }else{
            chart = [[Chart alloc] initWithContact:transaction.contact value:transaction.value];
            [ordered setObject:chart forKey:transaction.contact.clientID];
        }
    }
    
    NSMutableArray *dataSource = [NSMutableArray array];
    for (NSString* key in ordered) {
        Chart *chart = [ordered objectForKey:key];
        [dataSource addObject:chart];
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"value" ascending:NO];
    NSArray *result = [dataSource sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    return result;
}

#pragma mark - Public Methods

@end
