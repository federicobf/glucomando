//
//  CustomPopoverViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "CustomPopoverViewController.h"

@interface CustomPopoverViewController ()

@end

@implementation CustomPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionLabel.text = self.myText;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
