//
//  ContactViewController.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "ContactViewController.h"
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>
#import "ContactCell.h"
#import "SendView.h"
#import "Services.h"
#import "Contact.h"
#import "CacheDB.h"

@interface ContactViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) SendView* sendView;

@end

@implementation ContactViewController

#pragma mark - LifeCycle

- (id)init
{
    self = (ContactViewController*)[self initWithNibName:@"ContactViewController" bundle:nil];
    if (self) {
        self.sendView = [[SendView alloc] initWithController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_table addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(getContacts) forControlEvents:UIControlEventValueChanged];
    
    [self getContacts];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"ENVIAR DINHEIRO";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowSize;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact *contact = _dataSource[indexPath.row];
    [_sendView setContact:contact];
    [_sendView toggleBox];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ContactCell";
    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[ContactCell alloc] init];
        cell.preservesSuperviewLayoutMargins = YES;
    }
    
    Contact *contact = _dataSource[indexPath.row];
    cell.lbl_name.text = contact.name;
    cell.lbl_tel.text = contact.tel;
    cell.imgv_photo.image = contact.img_photo;
    CALayer *imageLayer = cell.imgv_photo.layer;
    [imageLayer setCornerRadius:23];
    [imageLayer setMasksToBounds:YES];
    
    return cell;
}

#pragma mark - Private Methods

-(void)getContacts{
    _dataSource = [CacheDB listUsers];
    [_refreshControl endRefreshing];
}

#pragma mark - Public Methods

@end
