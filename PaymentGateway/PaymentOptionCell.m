//
//  PaymentOptionCell.m
//  PaymentGateway
//
//  Created by Aaron Ang on 12/10/2018.
//  Copyright © 2018 AaronAng. All rights reserved.
//

#import "PaymentOptionCell.h"

@interface PaymentOptionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation PaymentOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateDisplay:(NSString *)title {
    self.titleLabel.text = title;
}

@end
