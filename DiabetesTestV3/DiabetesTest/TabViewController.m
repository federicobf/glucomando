//
//  TabViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/16/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "TabViewController.h"
#import "AppDelegate.h"
@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.tabVC = self;
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
