//
//  DetalleTableViewCell.h
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/29/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDTO.h"

@interface DetalleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chLabel;
@property (weak, nonatomic) IBOutlet UILabel *glucemiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

- (void) configureWithHealthDTO: (HealthDTO*) dto;

@end
