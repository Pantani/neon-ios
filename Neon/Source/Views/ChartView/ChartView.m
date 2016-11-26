//
//  ChartView.m
//  Neon
//
//  Created by Danilo Pantani on 25/11/16.
//  Copyright © 2016 Danilo Pantani. All rights reserved.
//

#import "ChartView.h"
#import "Util.h"
#import "Chart.h"
#import "Constants.h"
#import "UIColor+Additions.h"
#import <QuartzCore/QuartzCore.h>

static int const kBarWidth = 80;
static int const kLineSpacing = 10;
static int const kPhotoSize = 45;
static int const kLabelHeight = 70;
static int const kCircleSize = 10;
static int const kHeaderSize = 182;

@interface ChartView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) UIView *view_scroll;

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation ChartView
@synthesize dataSource = _dataSource;
@synthesize view_scroll = _view_scroll;

#pragma mark - LifeCycle

-(id)initWithDataSource:(NSArray *)dataSource
{
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ChartView" owner:nil options:nil];
    
    if ([arrayOfViews count] < 1)
        return nil;
    
    self = (ChartView*)[arrayOfViews objectAtIndex:0];
    if (self) {
        self.dataSource = dataSource;
        
    }
    return self;
}

#pragma mark - Private Methods

-(void)draw
{
    CGFloat width = _dataSource.count*kBarWidth;
    CGFloat height = kHeaderSize-8;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                            width,
                                                            height)];
    view.backgroundColor = [UIColor clearColor];
    [view setClipsToBounds:NO];
    [_scroll addSubview:view];
    _scroll.contentSize = CGSizeMake(width,height);
    
    // Horizontal lines
    int lines = ((height-kPhotoSize) / kLineSpacing)+2;
    for (int i = 0; i<lines; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(-200,
                                                                    kLineSpacing*i,
                                                                    width+400, 1)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = lineView.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor neon_chartSeparatorColor] CGColor], (id)[[UIColor neon_lineDarkColor] CGColor], nil];
        [lineView.layer insertSublayer:gradient atIndex:0];
        lineView.alpha = .7f;
        [view addSubview:lineView];
    }
    
    float max = [[_dataSource valueForKeyPath:@"@max.value"] floatValue];
    float barSpacing = kBarWidth-kPhotoSize/2.0;
    float scale = (height-kLabelHeight) / max;
    
    for (int i = 0; i<_dataSource.count; i++) {
        
        Chart *chart = _dataSource[i];
        
        float x = (barSpacing+kBarWidth*i)-barSpacing/2.0;
        float y = height-kPhotoSize;
        float lineHeight = (chart.value*scale);
        float circleY = height-kPhotoSize-lineHeight;
        float labelY = circleY-kPhotoSize;

        
        // Vertical Line
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x+kPhotoSize/2.0-1,
                                                                    y, 3,
                                                                    -lineHeight)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = lineView.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor neon_lineDarkColor] CGColor], (id)[[UIColor neon_lineLightColor] CGColor], nil];
        [lineView.layer insertSublayer:gradient atIndex:0];
        [view addSubview:lineView];
        
        
        //Circle
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        [circleLayer setStrokeColor:[[UIColor neon_lineDarkColor] CGColor]];
        [circleLayer setFillColor:[[UIColor neon_lineDarkColor] CGColor]];
        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(x+kPhotoSize/2.0-kCircleSize/2.0,
                                                                                circleY,
                                                                                kCircleSize,
                                                                                kCircleSize)] CGPath]];
        [[view layer] addSublayer:circleLayer];
        
        
        
        // Photo
        UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(x,y,
                                                                           kPhotoSize,
                                                                           kPhotoSize)];
        photo.image = chart.contact.img_photo;
        CALayer *imageLayer = photo.layer;
        [imageLayer setCornerRadius:25];
        [imageLayer setMasksToBounds:YES];
        
        [Util circleFilledWithOutline:photo fillColor:[UIColor clearColor] outlineColor:[UIColor neon_lineLightColor] andLineWidth:3];
        [view addSubview:photo];
        
        
        //Label
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake((kBarWidth*i)-3,
                                                                 labelY,
                                                                 kBarWidth+barSpacing/2,
                                                                 kLabelHeight)];
        [lbl setFont:[UIFont systemFontOfSize:13]];
        lbl.text = [Util formatNumber:chart.value];
        
        [lbl setTextAlignment:NSTextAlignmentCenter];
        lbl.textColor = [UIColor neon_lineLightColor];
        [view addSubview:lbl];
    }
}

-(void)clean
{
    [[_scroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)refresh
{
    [self clean];
    [self draw];
}

#pragma mark - Public Methods

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self refresh];
}

@end
