//
//  KeyboardToolBar.m
//  keyboard
//
//  Created by Danilo Pantani on 14/03/13.
//  Copyright (c) 2013 Danilo Pantani. All rights reserved.
//

#import "KeyboardToolBar.h"
#import "Constants.h"

#define kButtonColor [UIColor whiteColor]

@interface KeyboardToolBar ()

@property (strong, nonatomic) NSArray* fields;

@end

@implementation KeyboardToolBar
@synthesize fields = _fields;

#pragma mark - LifeCycle

- (id)init
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 320, 50)];
        self.barStyle = UIBarStyleBlackTranslucent;
        self.backgroundColor = kColor;
        self.barTintColor = kColor;
        [self sizeToFit];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [self fieldChanged];
}

#pragma mark - Public Methods

-(void)setColor:(UIColor*)color
{
    self.backgroundColor = color;
    self.barTintColor = color;
}

-(void)setFields:(NSArray *)fields
{
    _fields = fields;
    UIBarButtonItem *bt_ok = [[UIBarButtonItem alloc]initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:self action:@selector(ok:)];
    [bt_ok setTintColor:kButtonColor];
    if (_fields.count==1) {
        self.items = [NSArray arrayWithObjects:
                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      bt_ok,nil];
    }else if (_fields.count>1) {
        
        UIBarButtonItem *bt_back = [[UIBarButtonItem alloc]initWithTitle:LString(@"preview") style:UIBarButtonItemStyleDone target:self action:@selector(previousButton:)];
        [bt_back setTintColor:kButtonColor];
        
        UIBarButtonItem *bt_next = [[UIBarButtonItem alloc]initWithTitle:LString(@"next") style:UIBarButtonItemStyleDone target:self action:@selector(nextButton:)];
        [bt_next setTintColor:kButtonColor];
        
        self.items = [NSArray arrayWithObjects:
                      bt_back,
                      bt_next,
                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      bt_ok,nil];
    }
    [self sizeToFit];
}

-(void)fieldChanged
{
    if (_fields.count>1) {
        
        if ([(UITextField*)[_fields objectAtIndex:0]isFirstResponder] ) {
            ((UIButton*)[self.items objectAtIndex:0]).enabled=NO;
        }else{
            ((UIButton*)[self.items objectAtIndex:0]).enabled=YES;
        }
        
        if ([(UITextField*)[_fields objectAtIndex:_fields.count-1]isFirstResponder] ) {
            ((UIButton*)[self.items objectAtIndex:1]).enabled=NO;
        }else{
            ((UIButton*)[self.items objectAtIndex:1]).enabled=YES;
        }
        
        if (_fields.count==0) {
            ((UIButton*)[self.items objectAtIndex:0]).enabled=NO;
            ((UIButton*)[self.items objectAtIndex:1]).enabled=NO;
            ((UIButton*)[self.items objectAtIndex:3]).enabled=NO;
        }
    }
}

#pragma mark - IBActions

-(void)previousButton:(UIButton*)sender
{
    for (id text in _fields) {
        if ( [text isKindOfClass:[UITextField class]] ){
            if ([text isFirstResponder]) {
                NSInteger index = [_fields indexOfObject:text];
                if (index>0){
                    [((UITextField*)[_fields objectAtIndex:index-1]) becomeFirstResponder];
                    [self fieldChanged];
                    break;
                }
            }
        }else if ( [text isKindOfClass:[UITextView class]] ){
            if ([text isFirstResponder]) {
                NSInteger index = [_fields indexOfObject:text];
                if (index>0){
                    [((UITextView*)[_fields objectAtIndex:index-1]) becomeFirstResponder];
                    [self fieldChanged];
                    break;
                }
            }
        }else if ( [text isKindOfClass:[UISearchBar class]] ){
            if ([text isFirstResponder]) {
                NSInteger index = [_fields indexOfObject:text];
                if (index>0){
                    [((UISearchBar*)[_fields objectAtIndex:index-1]) becomeFirstResponder];
                    [self fieldChanged];
                    break;
                }
            }
        }
    }
}

-(void)nextButton:(UIButton*)sender
{
    for (id text in _fields) {
        if ( [text isKindOfClass:[UITextField class]] ){
            if ([text isFirstResponder]) {
                NSInteger index = [_fields indexOfObject:text];
                if (index<_fields.count-1){
                    [((UITextField*)[_fields objectAtIndex:index+1]) becomeFirstResponder];
                    [self fieldChanged];
                    break;
                }
            }
        }else if ( [text isKindOfClass:[UITextView class]] ){
            if ([text isFirstResponder]) {
                NSInteger index = [_fields indexOfObject:text];
                if (index<_fields.count-1){
                    [((UITextView*)[_fields objectAtIndex:index+1]) becomeFirstResponder];
                    [self fieldChanged];
                    break;
                }
            }
        }else if ( [text isKindOfClass:[UISearchBar class]] ){
            if ([text isFirstResponder]) {
                NSInteger index = [_fields indexOfObject:text];
                if (index<_fields.count-1){
                    [((UISearchBar*)[_fields objectAtIndex:index+1]) becomeFirstResponder];
                    [self fieldChanged];
                    break;
                }
            }
        }
    }
}

-(void)ok:(UIButton*)sender
{
    [self endEditing:YES];
    for (id text in _fields)
        if ([text isFirstResponder]){
            [_key_delegate okDidPressed];
            [text resignFirstResponder];
        }
}

@end
