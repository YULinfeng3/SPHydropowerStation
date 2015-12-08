//
//  SPProjCell.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPProjCell.h"
#import "MacroDefinition.h"
#import "SPAPI.h"

@interface SPProjCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet UIView *leftBkView;
@property (weak, nonatomic) IBOutlet UIView *rightBkView;

@end

@implementation SPProjCell

- (void)awakeFromNib {
    // Initialization code
    
    self.leftBkView.layer.borderWidth = 1;
    self.leftBkView.layer.borderColor = RGBACOLOR(211, 211, 211, 1).CGColor;
    self.leftBkView.layer.cornerRadius = 5;
    
    self.rightBkView.layer.borderWidth = 1;
    self.rightBkView.layer.borderColor = RGBACOLOR(211, 211, 211, 1).CGColor;
    self.rightBkView.layer.cornerRadius = 5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindDataWithLeft:(SPProj*)left
                   right:(SPProj*)right{
    self.leftTitleLabel.text = left.ProjName;
    self.rightTitleLabel.text = right.ProjName;

    
    [[SPAPI sharedInstance] getProjImagesWithId:left.ProjID succeed:^(NSArray* imageList){
        
    } failed:^(NSError *error) {
        
    }];
//    self.districtLabel.text = proj.District;
//    self.typeLabel.text = proj.ProjType;
//    self.introductionLabel.text = proj.Introduction;
}

@end
