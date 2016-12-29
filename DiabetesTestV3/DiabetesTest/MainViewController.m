//
//  MainViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/10/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "InformacionViewController.h"
#import "HealthManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.mainVC = self;
    
    // Do any additional setup after loading the view.
}

- (UIRectEdge)edgesForExtendedLayout
{
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier hasPrefix: @"showPopover"]) {
        InformacionViewController *destVC = segue.destinationViewController;
        destVC.displayText = kHelpGeneral;
        
    }
}


@end
