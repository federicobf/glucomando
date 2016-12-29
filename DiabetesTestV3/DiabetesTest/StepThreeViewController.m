
//
//  StepThreeViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/10/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "StepThreeViewController.h"
#import "AppDelegate.h"
#import "HealthManager.h"

@interface StepThreeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *relacionLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *sensibilidadLabel;
@property (weak, nonatomic) IBOutlet UILabel *CHLabel;
@property (weak, nonatomic) IBOutlet UILabel *glucemiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *ejercicioLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultadoLabel;

@end

@implementation StepThreeViewController

- (void)viewDidLoad {


    self.CHLabel.text = [NSString stringWithFormat:@"%i",(int)[HealthManager sharedInstance].cantidadch];
    self.glucemiaLabel.text = [NSString stringWithFormat:@"%i",(int)[HealthManager sharedInstance].glucemia];
    self.relacionLabel.text = [NSString stringWithFormat:@"%i",(int)[HealthManager sharedInstance].relacionch];
    self.targetLabel.text = [NSString stringWithFormat:@"%i",(int)[HealthManager sharedInstance].target];
    self.sensibilidadLabel.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].sensibilidad];
    self.resultadoLabel.text = [NSString stringWithFormat:@"%.2fU",[HealthManager sharedInstance].calculoFinalBolo];
    
    self.ejercicioLabel.text = @"";
    self.ejercicioLabel.alpha = 0;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finish:(id)sender {


    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Guardar Dato" message:[NSString stringWithFormat:@"Guardar este registro le permitirá obtener datos estadísticos acerca de su progreso respecto a la diabetes. ¿Desea registrar estos datos?"] delegate: nil cancelButtonTitle: @"No" otherButtonTitles: @"Sí", nil];
    alert.delegate = self;
    [alert show];

}



- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    AppDelegate* appdelegate = [UIApplication sharedApplication].delegate;
    if (buttonIndex!=0) {
        [self saveValue];
        appdelegate.tabVC.selectedIndex = 2;
    }
    
    [appdelegate.mainVC dismissViewControllerAnimated:YES completion:nil];
}


- (void) saveValue {

    HealthDTO* dto = [HealthDTO new];
    dto.carbohidratos = [HealthManager sharedInstance].cantidadch;
    dto.glucemia = [HealthManager sharedInstance].glucemia;
    dto.insulina = self.resultadoLabel.text.floatValue;
    dto.date = [NSDate date];
    [[HealthManager sharedInstance] storeNewItem:dto];

}

- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ejercicioYes:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Dosis Parcial"
                                  message:@"Si tienes pensado realizar ejercicio debes aplicarte una dosis parcial acorde con el porcentaje de reducción recomendado por tu médico."
                                  preferredStyle:UIAlertControllerStyleAlert];

    for (NSNumber *value in @[@10,@20,@25,@30,@40,@50,@60,@70,@75,@80,@90]) {
        UIAlertAction* action = [UIAlertAction
                                 actionWithTitle:[NSString stringWithFormat:@"%.f%%", value.floatValue]
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];

                                         self.ejercicioLabel.text = [NSString stringWithFormat: @"Debes reducir tu \n dosis en un %.f%% \n Nuevo valor = %.2f", (double)value.integerValue, [HealthManager sharedInstance].calculoFinalBolo*(1 - value.integerValue/100.f)];
                                     
                                     [UIView animateWithDuration:.3f animations:^{
                                         self.ejercicioLabel.alpha = 1;
                                     }];
                                     
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


- (IBAction)ejercicioNo:(id)sender {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Dosis Completa" message:[NSString stringWithFormat:@"Si no tienes pensado realizar ejercicio debes aplicarte la dosis completa indicada en el recuadro superior."] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
    [alert show];
    
    [UIView animateWithDuration:.3f animations:^{
        self.ejercicioLabel.alpha = 0;
    }];
    
}


@end
