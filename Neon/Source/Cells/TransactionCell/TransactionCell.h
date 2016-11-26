//
//  TransactionCell.h
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgv_photo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_tel;
@property (weak, nonatomic) IBOutlet UILabel *lbl_value;

@end
