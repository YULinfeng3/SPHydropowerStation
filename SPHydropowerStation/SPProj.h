//
//  SPProj.h
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/11/11.
//  Copyright © 2015年 SP. All rights reserved.
//

#import <Foundation/Foundation.h>

//CenterHeight = 0;
//CenterLatitude = "29.237";
//CenterLongitude = "103.208";
//District = "\U56db\U5ddd\U7701\U4e50\U5c71\U5e02\U5ce8\U8fb9\U5f5d\U65cf\U81ea\U6cbb\U53bf";
//GGDDIW = "<null>";
//Introduction = "\U5f00\U53d1\U6d4b\U8bd5\U7528";
//MDLZZ = "<null>";
//MonitorConcrete = 15;
//PlaybackInterval = "0.25";
//ProjID = TestID;
//ProjName = "\U6d4b\U8bd5\U6c34\U7535\U7ad9";
//ProjRadius = 2000;
//ProjType = "\U5e38\U89c4\U6c34\U7535\U7ad9";
//StatisticSpanConcrete = 7;
//StatisticSpanMixing = 1;
//StatisticSpanSurface = 7;
//StatisticSpanUser = 7;
//StatisticSpanVehicle = 7;
//SurfaceSyncLimit = 3;
//UserOffline = 100000;
//UserStatic = 10;
//VehicleOffline = 100000;
//VehicleSpeedLimit = 50;
//VehicleWait = 5;
//VehilceFlameout = 5;

@interface SPProj : NSObject

@property (nonatomic,assign) double CenterHeight;
@property (nonatomic,assign) double CenterLatitude;
@property (nonatomic,assign) double CenterLongitude;
@property (nonatomic,copy) NSString* District;
@property (nonatomic,copy) NSString* GGDDIW;
@property (nonatomic,copy) NSString* Introduction;
@property (nonatomic,copy) NSString* MDLZZ;
@property (nonatomic,copy) NSString* MonitorConcrete;
@property (nonatomic,copy) NSString* ProjID;
@property (nonatomic,copy) NSString* ProjName;
@property (nonatomic,copy) NSString* ProjRadius;
@property (nonatomic,copy) NSString* ProjType;
@property (nonatomic,copy) NSString* StatisticSpanConcrete;
@property (nonatomic,copy) NSString* StatisticSpanMixing;
@property (nonatomic,copy) NSString* StatisticSpanSurface;
@property (nonatomic,copy) NSString* StatisticSpanUser;
@property (nonatomic,copy) NSString* StatisticSpanVehicle;
@property (nonatomic,copy) NSString* SurfaceSyncLimit;
@property (nonatomic,copy) NSString* UserOffline;
@property (nonatomic,copy) NSString* UserStatic;
@property (nonatomic,copy) NSString* VehicleOffline;
@property (nonatomic,copy) NSString* VehicleSpeedLimit;
@property (nonatomic,copy) NSString* VehicleWait;
@property (nonatomic,copy) NSString* VehilceFlameout;

+ (SPProj*)projWithJSON:(NSDictionary*)json;

@end
