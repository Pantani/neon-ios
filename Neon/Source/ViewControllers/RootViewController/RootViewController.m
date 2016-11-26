//
//  RootViewController.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "RootViewController.h"
#import "TransactionViewController.h"
#import "ContactViewController.h"
#import "UIColor+Additions.h"
#import "SVProgressHUD.h"
#import "User.h"
#import "Util.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UIButton *bt_send;
@property (weak, nonatomic) IBOutlet UIButton *bt_hist;
@property (weak, nonatomic) IBOutlet UIImageView *img_user;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_email;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;

@end

@implementation RootViewController

@synthesize name = _name;
@synthesize email = _email;

#pragma mark - LifeCycle

- (id)init
{
    self = (RootViewController*)[self initWithNibName:@"RootViewController" bundle:nil];
    if (self) {
        self.name = @"Danilo Pantani";
        self.email = @"danilo@pixon.mobi";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getToken];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [Util drawBackgroundView:self.view];
    
    _lbl_name.text = _name;
    _lbl_email.text = _email;
    _img_user.image = [UIImage imageNamed:@"img_photo.png"];
    
    CALayer *imageLayer = _img_user.layer;
    [imageLayer setCornerRadius:_img_user.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    
    [Util circleGradientFilledWithOutline:_img_user outlineColor:[UIColor neon_greenColor] gradientColor:[UIColor neon_alphaColor]];
    
    CALayer *sendLayer = self.bt_send.layer;
    [sendLayer setCornerRadius:25];
    [sendLayer setMasksToBounds:YES];
    
    CALayer *histLayer = self.bt_hist.layer;
    [histLayer setCornerRadius:25];
    [histLayer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

-(void)getToken
{
    [SVProgressHUD showWithStatus:@"Aguarde..."];
    self.view.window.userInteractionEnabled = NO;
    [[User currentUser] generateTokenWithName:_name andEmail:_email andBlock:^(BOOL succeeded, NSError *error)
    {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Erro. Tente novamente mais tarde!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
        self.view.window.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Public Methods

#pragma mark - IBAction

-(IBAction)send:(UIButton*)sender
{
    ContactViewController *vc = [[ContactViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)openHistory:(UIButton*)sender
{
    TransactionViewController *vc = [[TransactionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
