//
//  AllDataViewController.h
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 9/6/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllDataViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dWeek;
@property (weak, nonatomic) IBOutlet UILabel *dFortnight;
@property (weak, nonatomic) IBOutlet UILabel *dMonth;
@property (weak, nonatomic) IBOutlet UILabel *dPreviousMonth;
@property (weak, nonatomic) IBOutlet UILabel *aWeek;
@property (weak, nonatomic) IBOutlet UILabel *aFortnight;
@property (weak, nonatomic) IBOutlet UILabel *aMonth;
@property (weak, nonatomic) IBOutlet UILabel *aPreviousMonth;
@property (weak, nonatomic) IBOutlet UILabel *mWeek;
@property (weak, nonatomic) IBOutlet UILabel *mFortnight;
@property (weak, nonatomic) IBOutlet UILabel *mMonth;
@property (weak, nonatomic) IBOutlet UILabel *mPreviousMonth;
@property (weak, nonatomic) IBOutlet UILabel *cWeek;
@property (weak, nonatomic) IBOutlet UILabel *cFortnight;
@property (weak, nonatomic) IBOutlet UILabel *cMonth;
@property (weak, nonatomic) IBOutlet UILabel *cPreviousMonth;

@end
