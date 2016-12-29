//
//  StepTwoViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/12/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "StepTwoViewController.h"
#import "HealthManager.h"
#import "CustomPopoverViewController.h"
#import "InformacionViewController.h"

@interface StepTwoViewController () <UIPopoverPresentationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sensibilidadHelp;
@property (weak, nonatomic) IBOutlet UIButton *targetHelp;
@property (weak, nonatomic) IBOutlet UIButton *relacionHelp;
@property (weak, nonatomic) IBOutlet UILabel *relacionLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *sensibilidadLabel;

@end

@implementation StepTwoViewController {
    UITextField* invisibleTextField;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.sensibilidadHelp.layer.cornerRadius = 25;
    self.targetHelp.layer.cornerRadius = 25;
    self.relacionHelp
    .layer.cornerRadius = 25;
    
    UITapGestureRecognizer *tapGestureRelacion = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRelacion)];
    UITapGestureRecognizer *tapGestureTarget = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTarget)];
    UITapGestureRecognizer *tapGestureSensibilidad = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSensibilidad)];
    
    self.relacionLabel.userInteractionEnabled = YES;
    self.targetLabel.userInteractionEnabled = YES;
    self.sensibilidadLabel.userInteractionEnabled = YES;
    
    [self.relacionLabel addGestureRecognizer:tapGestureRelacion];
    [self.targetLabel addGestureRecognizer:tapGestureTarget];
    [self.sensibilidadLabel addGestureRecognizer:tapGestureSensibilidad];
    
    [self displayValuesForTimeframe:[self timeframeForCurrentHour]];
    self.segmentedControl.selectedSegmentIndex = [self timeframeForCurrentHour]-1;
    
    NSLog(@"num? %lu", [self timeframeForCurrentHour]);
}

- (NSInteger) timeframeForCurrentHour {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    NSLog(@"hour?? %i", hour);
    if (0<=hour&&hour<6)   { return 4;}
    if (6<=hour&&hour<12)  { return 1;}
    if (12<=hour&&hour<16) { return 2;}
    if (16<=hour&&hour<20) { return 3;}
    if (20<=hour&&hour<24) { return 4;}
    return 0;
}

- (void) tapRelacion {
    [self tapTextfieldWithTag:1];
}

- (void) tapTarget {
    [self tapTextfieldWithTag:2];
}

- (void) tapSensibilidad {
    [self tapTextfieldWithTag:3];
}


- (void) tapTextfieldWithTag: (NSInteger) tag {
    
    UILabel* label = [self labelForTag:tag];

    
    invisibleTextField = [UITextField new];
    invisibleTextField.text = label.text;
    invisibleTextField.tag = tag;
    [invisibleTextField becomeFirstResponder];
    invisibleTextField.keyboardType = UIKeyboardTypeDecimalPad;
    invisibleTextField.inputAccessoryView = [self toolbarWithTag:tag];
    invisibleTextField.delegate = self;
    [self.view addSubview: invisibleTextField];

}

- (UILabel*) labelForTag: (NSInteger) tag {
    UILabel* label;
    switch (tag) {
        case 1: label = self.relacionLabel; break;
        case 2: label = self.targetLabel; break;
        case 3: label = self.sensibilidadLabel; break;
        default: break;
    }
    return label;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    BOOL continuar = newLength <= 6;
    
    if (continuar) {
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([newString hasPrefix:@"0"]) {
            newString = [newString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString: @""];
        }
        
        if ([newString isEqualToString: @""]) {
            newString = @"0";
            textField.text = @"0";
        }
        
        UILabel* label = [self labelForTag:textField.tag];
        label.text = newString;
    }
    
    return continuar;
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
    UILabel* label = [self labelForTag:sender.tag];
    label.text = @"0";
    invisibleTextField.text = @"0";

}

-(void)returnNumberPad: (UIBarButtonItem*) sender
{
    [invisibleTextField resignFirstResponder];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier hasPrefix: @"showPopover"]) {
        InformacionViewController *destVC = segue.destinationViewController;
        
        
        NSString* text;
        if ([segue.identifier hasSuffix:@"3"]) { text = kHelpRelacion;}
        if ([segue.identifier hasSuffix:@"5"]) { text = kHelpTarget;}
        if ([segue.identifier hasSuffix:@"4"]) { text = kHelpSensibilidad;}
        destVC.displayText = text;
        
    }
}

- (BOOL) checkValues {
    CGFloat relacionValue = self.relacionLabel.text.floatValue;
    CGFloat targetValue = self.targetLabel.text.floatValue;
    CGFloat sensibilidadValue = self.sensibilidadLabel.text.floatValue;
    
    if (relacionValue < kMinRelacion || relacionValue > kMaxRelacion) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor que está fuera de los límites permitidos: \n Relación Mínimo: %.2f \n Relación Máximo: %.2f ", kMinRelacion, kMaxRelacion] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];
        return NO;
    }
    
    if (targetValue < kMinTarget || targetValue > kMaxTarget) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor que está fuera de los límites permitidos: \n Target Mínimo: %.2f \n Target Máximo: %.2f ", kMinTarget, kMaxTarget] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];
        return NO;
    }
    
    if (sensibilidadValue < kMinSensibilidad || sensibilidadValue > kMaxSensibilidad) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor que está fuera de los límites permitidos: \n Sensibilidad Mínimo: %.2f \n Sensibilidad Máximo: %.2f ", kMinSensibilidad, kMaxSensibilidad] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];
        return NO;
    }
    
    return YES;
    
}

- (IBAction)guardarValores:(id)sender {
    
    if (![self checkValues]) {
        return;
    }
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Guardar valores"
                                  message:@"Elige cual es la comida en la que quieres que se carguen automáticamente estos datos:"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* opt1 = [UIAlertAction
                         actionWithTitle:@"Desayuno"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self saveValuesForTimeframe:1];
                             [self displayMessageForSaving:@"6AM a 12PM"];
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* opt2 = [UIAlertAction
                             actionWithTitle:@"Almuerzo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self saveValuesForTimeframe:2];
                                 [self displayMessageForSaving:@"12PM a 4PM"];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    UIAlertAction* opt3 = [UIAlertAction
                             actionWithTitle:@"Merienda"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self saveValuesForTimeframe:3];
                                 [self displayMessageForSaving:@"4PM a 8PM"];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    UIAlertAction* opt4 = [UIAlertAction
                             actionWithTitle:@"Cena"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self saveValuesForTimeframe:4];
                                 [self displayMessageForSaving:@"8PM a 6AM"];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    UIAlertAction* opt5 = [UIAlertAction
                           actionWithTitle:@"Todos"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [self saveValuesForTimeframe:1];
                               [self saveValuesForTimeframe:2];
                               [self saveValuesForTimeframe:3];
                               [self saveValuesForTimeframe:4];
                               [self displayMessageForSaving:@"Todo el dia"];
                               [alert dismissViewControllerAnimated:YES completion:nil];
                           }];
    
    UIAlertAction* opt6 = [UIAlertAction
                           actionWithTitle:@"Cancelar"
                           style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action)
                           {
                               [alert dismissViewControllerAnimated:YES completion:nil];
                           }];
    
    [alert addAction:opt1];
    [alert addAction:opt2];
    [alert addAction:opt3];
    [alert addAction:opt4];
    [alert addAction:opt5];
    [alert addAction:opt6];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}

- (void) displayValuesForTimeframe: (NSInteger) timeframe {
    
    CGFloat relacionValue = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat: @"relationValue-%lu", timeframe]];
    CGFloat targetValue = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat: @"targetValue-%lu", timeframe]];
    CGFloat sensibilidadValue = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat: @"sensibilidadValue-%lu", timeframe]];
    
    self.relacionLabel.text = [NSString stringWithFormat:@"%g", relacionValue];
    self.targetLabel.text = [NSString stringWithFormat:@"%g", targetValue];
    self.sensibilidadLabel.text = [NSString stringWithFormat:@"%g", sensibilidadValue];
}
- (IBAction)segmentedControlChanged:(id)sender {
    
    [self displayValuesForTimeframe:self.segmentedControl.selectedSegmentIndex+1];
    
    
    NSString* comida;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: comida = @"DESAYUNO"; break;
        case 1: comida = @"ALMUERZO"; break;
        case 2: comida = @"MERIENDA"; break;
        case 3: comida = @"CENA"; break;
        default:comida = @"ERROR";  break;
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Valores Predeterminados" message:[NSString stringWithFormat:@"Acabas de cargar manualmente los datos correspondientes a la siguiente comida: %@", comida] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
    [alert show];
    
}

- (void) saveValuesForTimeframe: (NSInteger) timeframe {

    CGFloat relacionValue = self.relacionLabel.text.floatValue;
    CGFloat targetValue = self.targetLabel.text.floatValue;
    CGFloat sensibilidadValue = self.sensibilidadLabel.text.floatValue;
    
    [[NSUserDefaults standardUserDefaults] setFloat:relacionValue forKey:[NSString stringWithFormat: @"relationValue-%lu", timeframe]];
    [[NSUserDefaults standardUserDefaults] setFloat:targetValue forKey:[NSString stringWithFormat: @"targetValue-%lu", timeframe]];
    [[NSUserDefaults standardUserDefaults] setFloat:sensibilidadValue forKey:[NSString stringWithFormat: @"sensibilidadValue-%lu", timeframe]];


}

- (void) displayMessageForSaving: (NSString*) message {

    
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Valores Predeterminados" message:[NSString stringWithFormat:@"En los próximos usos estos valores serán cargados de antemano durante el siguiente periodo: %@", message] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];

}

- (IBAction)continuar:(id)sender {

    if (![self checkValues]) {
        return;
    }
    
    CGFloat relacionValue = self.relacionLabel.text.floatValue;
    CGFloat targetValue = self.targetLabel.text.floatValue;
    CGFloat sensibilidadValue = self.sensibilidadLabel.text.floatValue;
    
    [HealthManager sharedInstance].relacionch = relacionValue;
    [HealthManager sharedInstance].target = targetValue;
    [HealthManager sharedInstance].sensibilidad = sensibilidadValue;
    
    [self performSegueWithIdentifier:@"continuar" sender:nil];
}

- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
