//
//  SPMenuItem.m
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/12/8.
//  Copyright © 2015年 SP. All rights reserved.
//

#import "SPMenuItem.h"

@implementation SPMenuItem

+ (SPMenuItem*)menuWithJSON:(NSDictionary*)json{
    SPMenuItem* model = [[SPMenuItem alloc] init];
    
    model.title = json[@"title"];
    model.imageName = json[@"icon"];
    model.show = [json[@"show"] boolValue];

    return model;
}

@end
