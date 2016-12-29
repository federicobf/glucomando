//
//  StepOneViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/10/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "StepOneViewController.h"
#import "AppDelegate.h"
#import "CustomPopoverViewController.h"
#import "InformacionViewController.h"

@interface StepOneViewController () <UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *CHLabel;
@property (weak, nonatomic) IBOutlet UILabel *glucemiaLabel;
@property (weak, nonatomic) IBOutlet UIButton *glucemiaHelp;
@property (weak, nonatomic) IBOutlet UIButton *CHHelp;
@property (weak, nonatomic) IBOutlet UILabel *glucemiaDescriptor;

@end

@implementation StepOneViewController {
    UITextField* invisibleTextField;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.glucemiaHelp.layer.cornerRadius = 25;
    self.CHHelp.layer.cornerRadius = 25;
    self.CHLabel.layer.cornerRadius = 25;
    self.glucemiaLabel.layer.cornerRadius = 25;
    
    UITapGestureRecognizer *tapGestureCH = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCH)];
    UITapGestureRecognizer *tapGestureGlucemia = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGlucemia)];
    
    self.glucemiaLabel.userInteractionEnabled = YES;
    self.CHLabel.userInteractionEnabled = YES;
    
    [self.glucemiaLabel addGestureRecognizer:tapGestureGlucemia];
    [self.CHLabel addGestureRecognizer:tapGestureCH];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self checkEntryTimeAllowed]) {
        
        
        self.glucemiaLabel.backgroundColor = [UIColor grayColor];
        self.glucemiaDescriptor.textColor = [UIColor grayColor];
        self.glucemiaLabel.text = @"0";
        
    }
    
    
    if (self.preloadedCH) {
        self.CHLabel.text = [NSString stringWithFormat:@"%.2f", self.preloadedCH];
    }
    

}

- (BOOL) checkEntryTimeAllowed {

   CGFloat spareTime = [[HealthManager sharedInstance] timeSinceLastEntry];
   CGFloat hours = spareTime/60.0f/60.0f;
    
    return hours > [self tiempoInsulinaActiva];
    
}


- (void) tapCH {

    invisibleTextField = [UITextField new];
    invisibleTextField.text = self.CHLabel.text;
    invisibleTextField.tag = 1;
    [invisibleTextField becomeFirstResponder];
    invisibleTextField.keyboardType = UIKeyboardTypeDecimalPad;
    invisibleTextField.inputAccessoryView = [self toolbarWithTag:1];
    invisibleTextField.delegate = self;
    [self.view addSubview: invisibleTextField];
    
}

- (void) tapGlucemia {
    
    if (![self checkEntryTimeAllowed]) {
        [self glucemiaActivaFlow];
        return;
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"InsulinaActivaKey"]) {
        [self cambiarInsulinaActiva: NO];
        return;
    }
    
    
    invisibleTextField = [UITextField new];
    invisibleTextField.tag = 2;
    invisibleTextField.text = self.glucemiaLabel.text;
    [invisibleTextField becomeFirstResponder];
    invisibleTextField.keyboardType = UIKeyboardTypeDecimalPad;
    invisibleTextField.inputAccessoryView = [self toolbarWithTag:2];
    invisibleTextField.delegate = self;
    [self.view addSubview: invisibleTextField];
    
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
        
        
        if (textField.tag == 1) {
            self.CHLabel.text  = newString;
        }
        if (textField.tag == 2) {
            self.glucemiaLabel.text  = newString;
        }
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
    if (sender.tag == 1) {
        invisibleTextField.text = @"0";
        self.CHLabel.text = @"0";
    }
    
    if (sender.tag == 2) {
        invisibleTextField.text = @"0";
        self.glucemiaLabel.text = @"0";
    }
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

- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier hasPrefix: @"showPopover"]) {
        InformacionViewController *destVC = segue.destinationViewController;
        

        NSString* text;
        if ([segue.identifier hasSuffix:@"1"]) { text = kHelpCarbohidratos;}
        if ([segue.identifier hasSuffix:@"2"]) { text = kHelpGlucemia;}
        destVC.displayText = text;

    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (IBAction)foodmenu:(id)sender {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Cálculo de Carbohidratos" message:[NSString stringWithFormat:@"Usted está a punto de avanzar a la sección de cálculo de carbohidratos.\n ¿Está seguro de que desea realizar esta acción?"] delegate: nil cancelButtonTitle: @"Cancelar" otherButtonTitles: @"Continuar", nil];
    alert.delegate = self;
    [alert show];

}


- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex!=0) {
        AppDelegate* appdelegate = [UIApplication sharedApplication].delegate;
        appdelegate.tabVC.selectedIndex = 1;
        [appdelegate.mainVC dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)continuar:(id)sender {
    CGFloat chValue = self.CHLabel.text.floatValue;
    CGFloat glucemiaValue = self.glucemiaLabel.text.floatValue;
    
    //ERROR
    
    if (chValue < kMinCH || chValue > kMaxCH) {
       UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor que está fuera de los límites permitidos: \n Carbohidratos Mínimo: %.2f \n Carbohidratos Máximo: %.2f ", kMinCH, kMaxCH] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];
        return;
    }
    
    if ((glucemiaValue < kMinGlucemia || glucemiaValue > kMaxGlucemia)&& [self checkEntryTimeAllowed]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor que está fuera de los límites permitidos: \n Glucemia Mínimo: %.2f \n Glucemia Máximo: %.2f ", kMinGlucemia, kMaxGlucemia] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];
        return;
    }
    
    //HIPOGLUCEMIA
    
    if (glucemiaValue >= kMinGlucemia && glucemiaValue < kMinGlucemiaOK) {
        [self hipoglucemiaFlow];
        return;
    }
    
    [HealthManager sharedInstance].cantidadch = chValue;
    [HealthManager sharedInstance].glucemia = glucemiaValue;
    
    [self performSegueWithIdentifier:@"continuar" sender:nil];
}

- (void) hipoglucemiaFlow {

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Hipoglucemia"
                                  message:@"Usted ha indicado un valor de glucemia demasiado bajo, estando el mismo considerado dentro del rango de la hipoglucemia. Por tanto, no debe aplicarse ninguna dosis de insulina. \n ¿Desea igualmente guardar este registro para que sea tomado en cuenta dentro de las estadísticas?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* action = [UIAlertAction
                                 actionWithTitle:@"Sí"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {

                                     HealthDTO* dto = [HealthDTO new];
                                     dto.carbohidratos = self.CHLabel.text.floatValue;
                                     dto.glucemia =  self.glucemiaLabel.text.floatValue;
                                     dto.insulina = 0;
                                     dto.date = [NSDate date];
                                     [[HealthManager sharedInstance] storeNewItem:dto];
                                     
                                     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [alert addAction:action];

    UIAlertAction* cancelar = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:cancelar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (CGFloat) tiempoInsulinaActiva {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"InsulinaActivaKey"]) {
        return 2;
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"InsulinaActivaKey"] floatValue];
}

- (void) glucemiaActivaFlow {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Campo bloqueado"
                                  message:[NSString stringWithFormat:@"Tienen que pasar al menos %.f horas para que pueda volver a aplicarse una dosis relativa a su glucemia.", [self tiempoInsulinaActiva]]
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction
                             actionWithTitle:@"De acuerdo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:action];
    
    UIAlertAction* cambiar = [UIAlertAction
                               actionWithTitle:@"Modificar duración"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   [self cambiarInsulinaActiva: YES];
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:cambiar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) cambiarInsulinaActiva: (BOOL) dismiss {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Modificar duración de insulina activa"
                                  message:@"Elija la cantidad de horas indicada por su médico acerca del lapso de tiempo mínimo que debe transcurrir entre la aplicación de una dosis y la siguiente."
                                  preferredStyle:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)? UIAlertControllerStyleAlert: UIAlertControllerStyleActionSheet];
    
    for (NSNumber *value in @[@1,@2,@3,@4,@5,@6]) {
        UIAlertAction* action = [UIAlertAction
                                 actionWithTitle:[NSString stringWithFormat:@"%.f horas", value.floatValue]
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"InsulinaActivaKey"];
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     if (dismiss) {
                                         [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                     }
                                     else {
                                         [self tapGlucemia];
                                     }
                                     
                                 }];
        [alert addAction:action];
    }
    
    UIAlertAction* cancelar = [UIAlertAction
                               actionWithTitle:@"Cancelar"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:cancelar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
