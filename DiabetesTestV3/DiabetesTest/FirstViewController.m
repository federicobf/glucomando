//
//  FirstViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/9/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.field1.keyboardType = UIKeyboardTypeDecimalPad;
    self.field2.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.field1.delegate = self;
    self.field2.delegate = self;
    
    self.field1.inputAccessoryView = [self toolbarWithTag:1];
    self.field2.inputAccessoryView = [self toolbarWithTag:2];
    
}

- (UIToolbar*) toolbarWithTag: (NSInteger) toolbarNumber {
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Borrar" style:UIBarButtonItemStylePlain target:self action:@selector(borrarNumberPad:)];
    cancel.tag = toolbarNumber;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *ok = [[UIBarButtonItem alloc]initWithTitle:@"Aceptar" style:UIBarButtonItemStylePlain target:self action:@selector(returnNumberPad:)];
    ok.tag = toolbarNumber;
    numberToolbar.items = [NSArray arrayWithObjects:cancel,flex, ok, nil];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

-(void)borrarNumberPad: (UIBarButtonItem*) sender
{
    if (sender.tag == 1) {
        self.field1.text = @"";
    }
    
    if (sender.tag == 2) {
        self.field2.text = @"";
    }
}

-(void)returnNumberPad: (UIBarButtonItem*) sender
{
    if (sender.tag == 1) {
        [self.field1 resignFirstResponder];
    }
    
    if (sender.tag == 2) {
        [self.field2 resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    
    return YES;
}

- (UIRectEdge)edgesForExtendedLayout
{
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}

- (IBAction)calcular:(id)sender {
    
    CGFloat multiplication = [self.field1.text floatValue] * [self.field2.text floatValue];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Cantidad" message: [NSString stringWithFormat: @"El resultado de multiplicar estas variables da %.2f", multiplication] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
}

@end
