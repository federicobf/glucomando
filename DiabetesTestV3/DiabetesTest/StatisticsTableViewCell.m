//
//  StatisticsTableViewCell.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "StatisticsTableViewCell.h"
#import "PureLayout.h"
#import "HealthManager.h"
#import "CurveView.h"

@implementation StatisticsTableViewCell {
    NSMutableArray* allDots;
    UIImageView * imageView;
}

- (id) init {
    
    self = [super init];
    
    if (self) {
        allDots = [NSMutableArray new];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
    }
    
    return self;
    
}


- (void) spaceUpItemsWithType: (NSNumber*) number {

    dispatch_async(dispatch_get_main_queue(), ^{

    
    NSInteger type = [number integerValue];
    
    NSMutableArray* points = [NSMutableArray new];
    for (UIView* currentView in allDots) {
        
        if (currentView.tag == type) {
            CGPoint point = currentView.center;
            point = CGPointMake(point.x*2,280 - point.y*2);
            [points addObject:[NSValue valueWithCGPoint:point]];
            
        }
    }
    
    NSArray *sortedArray;
    sortedArray = [points sortedArrayUsingComparator:^NSComparisonResult(NSValue* a, NSValue* b) {

        CGPoint pointA = [a CGPointValue];
        CGPoint pointB = [b CGPointValue];
        return pointA.x>pointB.x;
    }];
    
    
    CurveView* curveView = [[CurveView alloc] initWithFrame:self.contentView.frame];
    curveView.internalColor = type? [UIColor colorWithRed:155/255.f green:100/255.f blue:251/255.f alpha:.3f]:[UIColor colorWithRed:255/255.f green:33/255.f blue:162/255.f alpha:.3f];
    curveView.externalPoints = [NSMutableArray arrayWithArray:sortedArray];

    [self.contentView addSubview:curveView];
        
    });
    
}

- (void) configureWithHealthDay: (HealthDayDTO*) day {
    
    

    
    if (self.type == 2) {
        [self createDrawPoints:day.healthItems withType:0];
        [self createDrawPoints:day.healthItems withType:1];
    }
    else {
        [self createDrawPoints:day.healthItems withType: (int) self.type];
    }
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grid5"]];
    [self.contentView addSubview:imageView];
    [imageView autoPinEdgesToSuperviewEdges];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.alpha = .2f;
    
    [self addTitleLabel:day];
    [self addHelpers];
    
}

- (void) addHelpers {
    
    ///GLUCEMIA OK BARRA GRIS
    if (self.type == 0) {
        
        UIView* glucemiaOk = [[UIView alloc] initForAutoLayout];
        [self.contentView addSubview:glucemiaOk];
        [glucemiaOk autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [glucemiaOk autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
        glucemiaOk.backgroundColor = [UIColor colorWithRed:.4f green:.4f blue:.4f alpha:.5f];
        
        CGFloat centerGlucemia = ((kMinGlucemiaOK - kMinGlucemia) + ((kMaxGlucemiaOK - kMinGlucemiaOK) / 2)) / (kMaxGlucemia - kMinGlucemia);
        CGFloat heightRatioGlucemia = (kMaxGlucemiaOK - kMinGlucemiaOK) / (kMaxGlucemia - kMinGlucemia);
        
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:glucemiaOk
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier: (2 - 2* centerGlucemia)
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:glucemiaOk
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier: heightRatioGlucemia
                                                             constant:0],
                               ]
         ];
        
    }
    
    
    NSArray* helpersX = @[@"3AM",@"6AM",@"9AM",@"12PM",@"3PM",@"6PM",@"9PM"];
    CGFloat count = 0;
    for (NSString* str in helpersX) {

        count++;
        
        CGFloat multiplier = 2*(count/(helpersX.count+1));
        
        UILabel* label = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:label];
        label.text = str;
        [label autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
        [label setFont:[UIFont systemFontOfSize:10]];
        
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier: multiplier
                                                             constant:0]
                               ]
         ];
        
    }
    
    NSMutableArray* helpersY = [NSMutableArray new];
    
    if (self.type == 0) {
    
        for (int x = 0; x < 6; x++) {
           
            CGFloat currentValue = ((kMaxGlucemia - kMinGlucemia)* x/5.0f)+kMinGlucemia;
            [helpersY addObject:[NSString stringWithFormat:@"%i", (int) currentValue]];
            
        }
    
    }
    
    if (self.type == 1) {
        
        for (int x = 0; x < 6; x++) {
            
            CGFloat currentValue = ((kMaxCH - kMinCH)* x/5.0f)+kMinCH;
            [helpersY addObject:[NSString stringWithFormat:@"%i", (int) currentValue]];
            
        }
        
    }

    CGFloat count2 = 0;
    for (NSString* str in helpersY) {
        

        
        CGFloat multiplier = 2 - 2*(count2/(helpersY.count-1));
        if (multiplier==0) {multiplier=.1f;}
        if (multiplier==2) {multiplier=1.9f;}
        count2++;
        
        UILabel* label = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:label];
        label.text = str;
        [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [label setFont:[UIFont systemFontOfSize:10]];
        
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.contentView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier: multiplier
                                                             constant:0]
                               ]
         ];
        
    }
    
    


}

- (void) addTitleLabel: (HealthDayDTO*) day {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:day.date];
    NSInteger daystr = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    

    UILabel* label = [[UILabel alloc] initForAutoLayout];
    [self.contentView addSubview:label];
    label.text = [NSString stringWithFormat:@"%02ld-%02ld del %li", (long)daystr, (long)month, (long)year];
    [label autoSetDimension:ALDimensionHeight toSize:22];
    [label setFont:[UIFont systemFontOfSize:15.f]];
    label.textAlignment = NSTextAlignmentRight;
    [label autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:label.superview withOffset:-10];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:label.superview];

    
    UILabel* label2 = [[UILabel alloc] initForAutoLayout];
    [self.contentView addSubview:label2];
    label2.text = self.type==0? @"Glucemia" : self.type==1? @"Carbohidratos" : @"Vista compuesta";
    [label2 autoSetDimension:ALDimensionHeight toSize:15];
    [label2 setFont:[UIFont boldSystemFontOfSize:12.f]];
    [label2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:label2.superview withOffset:-10];
    [label2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label];
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = self.type==0?  [UIColor colorWithRed:255/255.f green:33/255.f blue:162/255.f alpha:1] : self.type==1? [UIColor colorWithRed:155/255.f green:100/255.f blue:251/255.f alpha:1]: [UIColor magentaColor];
}

- (void) createDrawPoints: (NSMutableArray*) dtos withType: (int) type {
    
    
    for (HealthDTO* dto in dtos) {
        
    UIView* v = [[UIView new] initForAutoLayout];
    v.layer.cornerRadius = 2;
        v.tag = type;
        
        v.backgroundColor = type? [UIColor colorWithRed:155/255.f green:100/255.f blue:251/255.f alpha:1]:[UIColor colorWithRed:255/255.f green:33/255.f blue:162/255.f alpha:1];
        
    if (!(type==0 && dto.glucemia == 0)) {
        
    [self.contentView addSubview:v];
    [v autoSetDimensionsToSize:CGSizeMake(5, 5)];
        
    CGFloat multiplierDate = (dto.date.timeIntervalSince1970 - [dto getSimpleDate].timeIntervalSince1970)/ 60/60/24;
    CGFloat multiplierValue = type==0?  (dto.glucemia - kMinGlucemia) / (kMaxGlucemia - kMinGlucemia) : (dto.carbohidratos - kMinCH) / (kMaxCH - kMinCH);
        
    if (multiplierValue<=0) {multiplierValue=0.01f;}
    if (multiplierValue>=1) {multiplierValue=0.99f;}
        
    [self addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:v
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:2-multiplierValue*2.f
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:v
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual 
                                                                toItem:self.contentView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:multiplierDate*2.f
                                                              constant:0]
                                ]];
        

        [allDots addObject:v];
    }
        
    }
    
    [self.contentView setNeedsUpdateConstraints];
    [self.contentView layoutIfNeeded];
    [self spaceUpItemsWithType:[NSNumber numberWithInt:type]];
    
}

@end
