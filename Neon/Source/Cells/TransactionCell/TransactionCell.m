//
//  TransactionCell.m
//  Neon
//
//  Created by Danilo Pantani on 09/10/16.
//  Copyright (c) 2016 Pixon. All rights reserved.
//

#import "TransactionCell.h"
#import "Constants.h"

@implementation TransactionCell

#pragma mark - LifeCycle

- (id)init
{
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TransactionCell" owner:nil options:nil];
    
    if ([arrayOfViews count] < 1)
        return nil;
    
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]])
        return nil;
    
    self = (TransactionCell*)[arrayOfViews objectAtIndex:0];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    _imgv_photo.image = [UIImage imageNamed:@"avatar.jpg"];
    _lbl_name.text = @"";
    _lbl_tel.text = @"";
    _lbl_value.text = @"";
}

#pragma mark - Public Methods


#pragma mark - Private Methods

@end
