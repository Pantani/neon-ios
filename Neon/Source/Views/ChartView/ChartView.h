//
//  ChartView.h
//  Neon
//
//  Created by Danilo Pantani on 25/11/16.
//  Copyright © 2016 Danilo Pantani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView

-(id)initWithDataSource:(NSArray *)dataSource;
-(void)setDataSource:(NSArray *)dataSource;
-(void)refresh;

@end
