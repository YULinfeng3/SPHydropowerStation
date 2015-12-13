//
//  SPAppInfo.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/12/13.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPAppInfo.h"

@implementation SPAppInfo

+ (SPAppInfo*)appInfoWithJSON:(NSDictionary*)json{
    SPAppInfo* model = [[SPAppInfo alloc] init];
    model.apppath = json[@"apppath"];
    model.updatetime = json[@"updatetime"];
    model.version = json[@"version"];
    model.updatedescribe = json[@"updatedescribe"];
    
    return model;
}

@end
