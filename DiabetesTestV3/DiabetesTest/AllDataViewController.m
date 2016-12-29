//
//  AllDataViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 9/6/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "AllDataViewController.h"
#import "HealthManager.h"
#import "InformacionViewController.h"

@interface AllDataViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation AllDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadGlucemiaData];
}
- (IBAction)changeFilter:(id)sender {
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [self loadGlucemiaData];
            break;
        case 1:
            [self loadCarbohidratosData];
            break;
        case 2:
            [self loadInsulinaData];
            break;
            
        default:
            break;
    }
    
}

- (void) loadGlucemiaData {
    
    self.dWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForDesayuno:[self allWeekItems]]]];
    self.dFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForDesayuno:[self allFortnightItems]]]];
    self.dMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForDesayuno:[self allMonthItems]]]];
    self.dPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForDesayuno:[self allPreviousMonthItems]]]];
    
    self.aWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allWeekItems]]]];
    self.aFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allFortnightItems]]]];
    self.aMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allMonthItems]]]];
    self.aPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allPreviousMonthItems]]]];
    
    self.mWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForMerienda:[self allWeekItems]]]];
    self.mFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForMerienda:[self allFortnightItems]]]];
    self.mMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForMerienda:[self allMonthItems]]]];
    self.mPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForMerienda:[self allPreviousMonthItems]]]];
    
    self.cWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForCena:[self allWeekItems]]]];
    self.cFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForCena:[self allFortnightItems]]]];
    self.cMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForCena:[self allMonthItems]]]];
    self.cPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForCena:[self allPreviousMonthItems]]]];
    
    [self checkFields];
}

- (void) loadCarbohidratosData {
    
    self.dWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allWeekItems]]]];
    self.dFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allFortnightItems]]]];
    self.dMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allMonthItems]]]];
    self.dPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allPreviousMonthItems]]]];
    
    self.aWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allWeekItems]]]];
    self.aFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allFortnightItems]]]];
    self.aMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allMonthItems]]]];
    self.aPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allPreviousMonthItems]]]];
    
    self.mWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allWeekItems]]]];
    self.mFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allFortnightItems]]]];
    self.mMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allMonthItems]]]];
    self.mPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allPreviousMonthItems]]]];
    
    self.cWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForCena:[self allWeekItems]]]];
    self.cFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForCena:[self allFortnightItems]]]];
    self.cMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForCena:[self allMonthItems]]]];
    self.cPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForCena:[self allPreviousMonthItems]]]];
    
    [self checkFields];
}

- (void) loadInsulinaData {
    
    self.dWeek.text             = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForDesayuno:[self allWeekItems]]]];
    self.dFortnight.text        = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForDesayuno:[self allFortnightItems]]]];
    self.dMonth.text            = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForDesayuno:[self allMonthItems]]]];
    self.dPreviousMonth.text    = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForDesayuno:[self allPreviousMonthItems]]]];
    
    self.aWeek.text             = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allWeekItems]]]];
    self.aFortnight.text        = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allFortnightItems]]]];
    self.aMonth.text            = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allMonthItems]]]];
    self.aPreviousMonth.text    = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allPreviousMonthItems]]]];
    
    self.mWeek.text             = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForMerienda:[self allWeekItems]]]];
    self.mFortnight.text        = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForMerienda:[self allFortnightItems]]]];
    self.mMonth.text            = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForMerienda:[self allMonthItems]]]];
    self.mPreviousMonth.text    = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForMerienda:[self allPreviousMonthItems]]]];
    
    self.cWeek.text             = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForCena:[self allWeekItems]]]];
    self.cFortnight.text        = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForCena:[self allFortnightItems]]]];
    self.cMonth.text            = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForCena:[self allMonthItems]]]];
    self.cPreviousMonth.text    = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForCena:[self allPreviousMonthItems]]]];
    
    [self checkFields];
    
}

- (void) checkFields {

    for (UIView* v in self.view.subviews) {
    
        if ([v isKindOfClass:[UILabel class]]) {
         
            UILabel* lbl = (UILabel*) v;
            if ([lbl.text isEqualToString:@"nan"]) {
                lbl.text = @"-";
                lbl.backgroundColor = [UIColor grayColor];
            }
            else {
                
                if ([lbl.text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) {
                    lbl.backgroundColor = self.segmentedControl.selectedSegmentIndex==0? [UIColor colorWithRed:155/255.f green:100/255.f blue:251/255.f alpha:1]:
                    self.segmentedControl.selectedSegmentIndex == 1? [UIColor colorWithRed:255/255.f green:33/255.f blue:162/255.f alpha:1] :
                    [UIColor colorWithRed:200/255.f green:100/255.f blue:162/255.f alpha:1] ;
                }
            }
            
            
        }
    
    }

}




- (CGFloat) sumUpInsulina: (NSMutableArray*) items {
    CGFloat sumup = 0;
    NSInteger count = 0;
    for (HealthDTO* dto in items) {
        if (dto.insulina != 0) {count++;}
        sumup= sumup + dto.insulina;
    }
    
    sumup = sumup / count;
    
    return sumup;
}

- (CGFloat) sumUpGlucemia: (NSMutableArray*) items {
    CGFloat sumup = 0;
    NSInteger count = 0;
    for (HealthDTO* dto in items) {
        if (dto.glucemia != 0) {count++;}
        sumup= sumup + dto.glucemia;
    }
    
    sumup = sumup / count;
    
    return sumup;
}

- (CGFloat) sumUpCarbohidratos: (NSMutableArray*) items {
    CGFloat sumup = 0;
    for (HealthDTO* dto in items) {
        sumup= sumup + dto.carbohidratos;
    }
    return sumup / items.count;
}

- (NSMutableArray*) filterItemsForDesayuno: (NSMutableArray*) items {

    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==1) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}

- (NSMutableArray*) filterItemsForAlmuerzo: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==2) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}

- (NSMutableArray*) filterItemsForMerienda: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==3) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}

- (NSMutableArray*) filterItemsForCena: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==4) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}


- (NSInteger) timeframeForDate: (NSDate*) date {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:date];
    NSInteger hour = [components hour];
    if (0<=hour&&hour<6)   { return 4;}
    if (6<=hour&&hour<12)  { return 1;}
    if (12<=hour&&hour<16) { return 2;}
    if (16<=hour&&hour<20) { return 3;}
    if (20<=hour&&hour<24) { return 4;}
    return 0;
}



- (NSMutableArray*) allWeekItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* weekItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)<60*60*24*7) {
            [weekItems addObject:dto];
        }
    }
    return weekItems;
}

- (NSMutableArray*) allFortnightItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* fortItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)<60*60*24*15) {
            [fortItems addObject:dto];
        }
    }
    return fortItems;
}

- (NSMutableArray*) allMonthItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* monthItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)<60*60*24*30) {
            [monthItems addObject:dto];
        }
    }
    return monthItems;
}

- (NSMutableArray*) allPreviousMonthItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* monthItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)>60*60*24*30&&(-dto.date.timeIntervalSinceNow)<60*60*24*60) {
            [monthItems addObject:dto];
        }
    }
    return monthItems;
}

- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier hasPrefix: @"showPopover"]) {
        InformacionViewController *destVC = segue.destinationViewController;
        destVC.displayText = kHelpGrafico;
        
    }
}


@end
