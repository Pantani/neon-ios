//
//  SendView.h
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright © 2016 Danilo Pantani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface SendView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgv_photo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_tel;
@property (weak, nonatomic) IBOutlet UITextField *txt_value;
@property (weak, nonatomic) IBOutlet UIButton *bt_send;

-(id)initWithController:(UIViewController*)controller;
-(void)toggleBox;
-(void)setContact:(Contact *)contact;

@end
