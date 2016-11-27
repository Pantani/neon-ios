//
//  SendView.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright © 2016 Danilo Pantani. All rights reserved.
//

#import "SendView.h"
#import "Util.h"
#import "Services.h"
#import "Constants.h"
#import "SVProgressHUD.h"
#import "KeyboardToolBar.h"
#import "UIColor+Additions.h"
#import <QuartzCore/QuartzCore.h>

static int const kMaxHeight = 310;

@interface SendView () <KeyboardToolBarDelegate,UIToolbarDelegate,UITextFieldDelegate>

@property (strong, nonatomic) Contact *contact;
@property (strong, nonatomic) UIViewController *controller;
@property (strong, nonatomic) UIView *alphaView;
@property (assign, nonatomic) BOOL isShowing;
@property (assign, nonatomic) BOOL isAnimating;
@property (strong, nonatomic) KeyboardToolBar *keyTool;

@end

@implementation SendView

#pragma mark - LifeCycle

- (id)initWithController:(UIViewController*)controller
{
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SendView" owner:nil options:nil];
    
    if ([arrayOfViews count] < 1)
        return nil;
    
    self = (SendView*)[arrayOfViews objectAtIndex:0];
    if (self) {
        self.controller = controller;
        self.isShowing = false;
        self.isAnimating = false;
        
        self.keyTool = [[KeyboardToolBar alloc] init];
        [self.keyTool setFields:@[self.txt_value]];
        _txt_value.inputAccessoryView = _keyTool;
        _keyTool.delegate = self;
        _keyTool.key_delegate = self;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        float height = screenHeight-270;
        height = height>kMaxHeight?kMaxHeight:height;
        
        self.frame = CGRectMake(10, -self.frame.size.height-self.frame.size.height, screenWidth-20,height);
        
        
        self.alphaView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.alphaView.backgroundColor = [UIColor blackColor];
        self.alphaView.alpha = 0;
        
        [controller.view addSubview:self];
        [controller.view bringSubviewToFront:self];
        
        CALayer *selfLayer = self.layer;
        [selfLayer setCornerRadius:15];
        [selfLayer setMasksToBounds:YES];
        
        CALayer *txtLayer = self.txt_value.layer;
        [txtLayer setCornerRadius:14];
        [txtLayer setMasksToBounds:YES];
        
        CALayer *btLayer = self.bt_send.layer;
        [btLayer setCornerRadius:18];
        [btLayer setMasksToBounds:YES];
        
        _imgv_photo.image = [UIImage imageNamed:@"avatar.jpg"];
        [self imageAdjustment];
        
        if (screenHeight<=500)
            self.imgv_photo.hidden = YES;
        
    }
    return self;
}

#pragma mark - Private Methods
-(void)layoutMarginsDidChange
{
    [super layoutMarginsDidChange];
//    [self imageAdjustment];
}

-(void)imageAdjustment
{
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
    CGRect imgFrame = self.imgv_photo.frame;
    imgFrame.size.width = self.imgv_photo.frame.size.height;
    imgFrame.origin.x = self.frame.size.width/2.0 - imgFrame.size.width/2.0;
    self.imgv_photo.frame = imgFrame;
    
    CALayer *imageLayer = _imgv_photo.layer;
    [imageLayer setCornerRadius:_imgv_photo.frame.size.height/2.0];
    [imageLayer setMasksToBounds:YES];
    
    [Util circleFilledWithOutline:_imgv_photo frame:imgFrame fillColor:[UIColor clearColor] outlineColor:[UIColor neon_lineLightColor] andLineWidth:3];
    
    [_imgv_photo setNeedsLayout];
    [_imgv_photo setNeedsDisplay];
}

-(void)clear
{
    _txt_value.text = @"R$ 0,00";
    _lbl_name.text = @"";
    _lbl_tel.text = @"";
}

-(void)sendMoney{
    
    NSString *valueStr = [_txt_value text];
    
    valueStr = [valueStr stringByReplacingOccurrencesOfString:@"R" withString:@""];
    valueStr = [valueStr stringByReplacingOccurrencesOfString:@"$" withString:@""];
    valueStr = [valueStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    valueStr = [valueStr stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    if (valueStr==nil || valueStr.length==0 || valueStr.doubleValue<=0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Valor inválido!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Enviando..."];
    [Services sendMoneyToClient:_contact.clientID value:valueStr.doubleValue withBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"Atenção" message:@"Erro. Tente novamente mais tarde!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }else{
            [self toggleBox];
            [SVProgressHUD showSuccessWithStatus:@"Sucesso!"];
        }
    }];
}

#pragma mark - Public Methods

-(void)setContact:(Contact *)contact
{

    _contact = contact;
    _imgv_photo.image = contact.img_photo;
    
    _txt_value.text = @"R$ 0,00";
    _lbl_name.text = contact.name;
    _lbl_tel.text = contact.tel;
}

-(void)toggleBox{
    if (_isAnimating)
        return;
    
    _isAnimating = true;
    if (_isShowing) {
        [_controller.view addSubview:_alphaView];
        [self imageAdjustment];

        [_txt_value resignFirstResponder];
        [self endEditing:YES];
        
        [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _alphaView.alpha = 0;
            self.frame = CGRectMake(5, -self.frame.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
            
        } completion:^(BOOL finished) {
            [_alphaView removeFromSuperview];
            _isAnimating = false;
            _isShowing = false;
            [self clear];
            
            [_txt_value resignFirstResponder];
            [self endEditing:YES];
        }];
    }else{
        _alphaView.alpha = 0;
        [_controller.view addSubview:_alphaView];
        [_controller.view bringSubviewToFront:self];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        
        [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            _alphaView.alpha = 0.6;
            self.frame = CGRectMake(5, 74, screenWidth-10, self.frame.size.height);
            
        } completion:^(BOOL finished) {
            _isAnimating = false;
            _isShowing = true;
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMoney];
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text=[textField.text stringByAppendingString:string];
    textField.text = [Util currencyMaskWithText:textField.text andRange:range];
    return [Util returnForShouldChangeCharactersInRange:range];
}

#pragma mark - KeyboardToolBarDelegate

-(void)okDidPressed
{
    [self endEditing:YES];
}

#pragma mark - IBAction

- (IBAction)cancel:(UIButton *)sender{
    [self toggleBox];
}

-(IBAction)send:(UIButton*)sender
{
    [self sendMoney];
}

@end
