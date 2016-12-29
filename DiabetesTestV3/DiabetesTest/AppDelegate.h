//
//  AppDelegate.h
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/9/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "TabViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController* mainVC;
@property (strong, nonatomic) TabViewController* tabVC;

@end

