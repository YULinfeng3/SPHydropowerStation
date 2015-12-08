//
//  SPMenuItem.h
//  SPHydropowerStation
//
//  Created by 余林峰 on 15/12/8.
//  Copyright © 2015年 SP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPMenuItem : NSObject

@property (nonatomic,copy) NSString* title;
@property (nonatomic,copy) NSString* imageName;
@property (nonatomic,assign) BOOL show;

+ (SPMenuItem*)menuWithJSON:(NSDictionary*)json;

@end
