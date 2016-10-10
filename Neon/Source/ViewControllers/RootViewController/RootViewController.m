//
//  RootViewController.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "RootViewController.h"
#import "ContactViewController.h"
#import "TransactionViewController.h"
#import "User.h"
#import "SVProgressHUD.h"

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
    
    _lbl_name.text = _name;
    _lbl_email.text = _email;
    
    CALayer *sendLayer = self.bt_send.layer;
    [sendLayer setCornerRadius:25];
    [sendLayer setMasksToBounds:YES];
    
    CALayer *histLayer = self.bt_hist.layer;
    [histLayer setCornerRadius:25];
    [histLayer setMasksToBounds:YES];
    
    [self circleFilledWithOutline:_img_user fillColor:[UIColor clearColor] outlineColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Methods

- (void) circleFilledWithOutline:(UIView*)circleView fillColor:(UIColor*)fillColor outlineColor:(UIColor*)outlinecolor{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    float width = circleView.frame.size.width+210;
    float height = circleView.frame.size.height+210;
    [circleLayer setBounds:CGRectMake(2.0f, 2.0f, width-2.0f, height-2.0f)];
    [circleLayer setPosition:CGPointMake(width/2, height/2)];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(2.0f, 15.0f, width-2.0f, height-2.0f)];
    [circleLayer setPath:[path CGPath]];
    [circleLayer setFillColor:fillColor.CGColor];
    [circleLayer setStrokeColor:outlinecolor.CGColor];
    [circleLayer setLineWidth:2.0f];
    [[self.view layer] addSublayer:circleLayer];
    circleLayer.position = circleView.center;
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    CGPoint line_start = CGPointMake(circleView.center.x, circleLayer.position.y+circleLayer.frame.size.height/2+14);
    [linePath moveToPoint:line_start];
    CGPoint line_end = CGPointMake(circleView.center.x, _bt_send.center.y-10);
    [linePath addLineToPoint:line_end];
    [linePath stroke];
    [lineLayer setPath:[linePath CGPath]];
    [lineLayer setFillColor:fillColor.CGColor];
    [lineLayer setStrokeColor:outlinecolor.CGColor];
    [lineLayer setLineWidth:2.0f];
    [[self.view layer] addSublayer:lineLayer];
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
