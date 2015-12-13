//
//  SPAppInfo.h
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/12/13.
//  Copyright © 2015年 SP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPAppInfo : NSObject

@property (nonatomic,copy) NSString* apppath;
@property (nonatomic,retain) NSArray* updatedescribe;
@property (nonatomic,copy) NSString* updatetime;
@property (nonatomic,copy) NSString* version;

+ (SPAppInfo*)appInfoWithJSON:(NSDictionary*)json;

@end
