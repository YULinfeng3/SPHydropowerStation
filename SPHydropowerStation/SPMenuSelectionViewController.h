//
//  SPMenuSelectionViewController.h
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/12/8.
//  Copyright © 2015年 SP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPMenuSelectionViewController : UIViewController

@property (nonatomic,retain) NSArray* menuList;

@property (nonatomic,copy) void (^menuEditCompletion)(NSArray* menuList);

@end
