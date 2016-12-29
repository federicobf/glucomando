//
//  InfoViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/9/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "InfoViewController.h"
#import <MessageUI/MessageUI.h>

@interface InfoViewController () <MFMailComposeViewControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *telefonoTxtfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtfield;
@property (weak, nonatomic) IBOutlet UITextField *webTxtfield;
@property (weak, nonatomic) IBOutlet UILabel *textHelper;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textHelper.alpha = 0;
    self.textHelper.layer.borderWidth = 2;
    self.textHelper.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.telefonoTxtfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"TelefonoKey"];
    self.emailTxtfield.text = [[NSUserDefaults standardUserDefaults] objectForKey: @"EmailKey"];
    self.webTxtfield.text = [[NSUserDefaults standardUserDefaults] objectForKey: @"WebKey"];
    
    self.telefonoTxtfield.delegate = self;
    self.emailTxtfield.delegate = self;
    self.webTxtfield.delegate = self;
    
    self.telefonoTxtfield.keyboardType = UIKeyboardTypeNumberPad;
    self.emailTxtfield.keyboardType = UIKeyboardTypeEmailAddress;
    self.webTxtfield.keyboardType = UIKeyboardTypeDefault;
    
    self.telefonoTxtfield.inputAccessoryView = [self toolbarView];
    
    [self.telefonoTxtfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.emailTxtfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.webTxtfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.textHelper.text = textField.text;
    [UIView animateWithDuration:.3f animations:^{
        self.textHelper.alpha = 1;
    }];
}

-(void)textFieldDidChange :(UITextField *)textField{
    self.textHelper.text = textField.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UIView animateWithDuration:.3f animations:^{
        self.textHelper.alpha = 0;
    }];
    
    [textField resignFirstResponder];
    return YES;
}

- (UIToolbar*) toolbarView {
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Borrar" style:UIBarButtonItemStylePlain target:self action:@selector(borrarNumberPad:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *ok = [[UIBarButtonItem alloc]initWithTitle:@"Aceptar" style:UIBarButtonItemStylePlain target:self action:@selector(returnNumberPad:)];
    numberToolbar.items = [NSArray arrayWithObjects:cancel,flex, ok, nil];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

-(void)borrarNumberPad: (UIBarButtonItem*) sender
{
    self.telefonoTxtfield.text = @"";
    self.textHelper.text = @"";
}

-(void)returnNumberPad: (UIBarButtonItem*) sender
{
    [self.telefonoTxtfield resignFirstResponder];
    [UIView animateWithDuration:.3f animations:^{
        self.textHelper.alpha = 0;
    }];
    
}



- (IBAction)contact:(id)sender {
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]) {
        [composer setToRecipients:[NSArray arrayWithObjects:self.emailTxtfield.text, nil]];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:composer animated:YES completion:nil];
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)call:(id)sender {
    NSString* telefoneNumber = [NSString stringWithFormat:@"telprompt://%lu", (long) self.telefonoTxtfield.text.integerValue];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telefoneNumber]];
}

- (IBAction)web:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@", self.webTxtfield.text];

    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}

- (IBAction)save:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.telefonoTxtfield.text forKey:@"TelefonoKey"];
    [[NSUserDefaults standardUserDefaults] setObject:self.emailTxtfield.text forKey:@"EmailKey"];
    [[NSUserDefaults standardUserDefaults] setObject:self.webTxtfield.text forKey:@"WebKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Datos Guardados" message:[NSString stringWithFormat:@"La próxima vez que abras esta pantalla verás cargados automáticamente los valores ingresados actualmente."] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
    [alert show];
    
}

- (UIRectEdge)edgesForExtendedLayout
{
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}


@end
