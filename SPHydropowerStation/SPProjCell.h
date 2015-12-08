//
//  SPProjCell.h
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPProj.h"

@interface SPProjCell : UITableViewCell

- (void)bindDataWithLeft:(SPProj*)left
                   right:(SPProj*)right;

@end
