//
//  SPProjCell.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPProjCell.h"
#import "MacroDefinition.h"

@interface SPProjCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *districtLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (weak, nonatomic) IBOutlet UIView *bkView;

@end

@implementation SPProjCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bkView.layer.borderWidth = 1;
    self.bkView.layer.borderColor = RGBACOLOR(211, 211, 211, 1).CGColor;
    self.bkView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindData:(SPProj*)proj{
    self.titleLabel.text = proj.ProjName;
    self.districtLabel.text = proj.District;
    self.typeLabel.text = proj.ProjType;
    self.introductionLabel.text = proj.Introduction;
}

@end
