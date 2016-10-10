//
//  KeyboardToolBar.h
//  keyboard
//
//  Created by Danilo Pantani on 14/03/13.
//  Copyright (c) 2013 Danilo Pantani. All rights reserved.
//

/*
 --KEYBOARD TOOLBAR--
 
 >Instanciar a classe KeyboardInputView
 
 @property (strong, nonatomic) KeyboardToolBar *keyTool;
 
 
 >Inicializar a classe KeyboardInputView
 
 self.keyTool = [[KeyboardToolBar alloc] init];
 
 
 >Inicializar o array de TextFields e TextViews em ordem de firstResponder
 
 self.keyTool.arrayTexts = @[self.txtNome,self.txtEmail,self.txtViewComentarios];
 
 
 >Se o componente for UITextField colocar no metodo de delgate textFieldShouldBeginEditing:
 
 -(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
 {
 textField.inputAccessoryView = self.keyTool;
 return YES;
 }
 
 >Se o componente for UITextView colocar no metodo viewDidLoad da viewController:
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 self.keyTool = [[KeyboardToolBar alloc] init];
 textView.inputAccessoryView=self.keyTool;
 }
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KeyboardToolBarDelegate <NSObject>

-(void)okDidPressed;

@end

@interface KeyboardToolBar : UIToolbar

@property (nonatomic) id<KeyboardToolBarDelegate> key_delegate;

-(void)fieldChanged;
-(void)previousButton:(UIButton*)sender;
-(void)nextButton:(UIButton*)sender;
-(void)setFields:(NSArray*)fields;
-(void)setColor:(UIColor*)color;

@end