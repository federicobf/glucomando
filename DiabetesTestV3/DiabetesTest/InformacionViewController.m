//
//  InformacionViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 9/9/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "InformacionViewController.h"

@interface InformacionViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionView;

@end

@implementation InformacionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.descriptionView.text = self.displayText;
    
}


- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
