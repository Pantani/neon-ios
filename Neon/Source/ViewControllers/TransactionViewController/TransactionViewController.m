//
//  TransactionViewController.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "TransactionViewController.h"
#import "TransactionCell.h"
#import "Transaction.h"
#import "Constants.h"
#import "Services.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>


@interface TransactionViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *dataSource;

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
    
    [self refreshTable];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"HISTÓRICO DE ENVIOS";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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
    NSString *name = [NSString stringWithFormat:@"%@ - R$%.2f",transaction.contact.name,transaction.value];
    cell.lbl_name.text = name;
    cell.lbl_tel.text = transaction.contact.tel;
    cell.imgv_photo.image = transaction.contact.img_photo;
    CALayer *imageLayer = cell.imgv_photo.layer;
    [imageLayer setCornerRadius:23];
    [imageLayer setMasksToBounds:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormatterCell];
    cell.lbl_date.text = [formatter stringFromDate:transaction.date];

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
             weakSelf.dataSource = [NSMutableArray arrayWithArray:result];
             [weakSelf.table reloadData];
         }else{
             [[[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Erro. Tente novamente mais tarde!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
         }
        [SVProgressHUD dismiss];
        [_refreshControl endRefreshing];
     }];
}

#pragma mark - Public Methods

@end
