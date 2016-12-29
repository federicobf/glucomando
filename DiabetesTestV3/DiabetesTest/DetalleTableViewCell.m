//
//  DetalleTableViewCell.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/29/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "DetalleTableViewCell.h"

@implementation DetalleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) configureWithHealthDTO: (HealthDTO*) dto {

    self.glucemiaLabel.text = [NSString stringWithFormat:@"%g", dto.glucemia];
    self.chLabel.text = [NSString stringWithFormat:@"%g", dto.carbohidratos];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:dto.date];
    NSInteger daystr = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
                                    

    self.dayLabel.text = [NSString stringWithFormat:@"%02ld/%02ld/%li", (long)daystr, (long)month, (long)year];
    self.hourLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", hour, minute];
    
}

@end
