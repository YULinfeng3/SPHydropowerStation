//
//  SPProj.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPProj.h"

@implementation SPProj

+ (SPProj*)projWithJSON:(NSDictionary*)json{
    SPProj* model = [[SPProj alloc] init];
    
    model.ProjID = json[@"ProjID"];
    model.ProjName = json[@"ProjName"];
    
    return model;
}

@end
