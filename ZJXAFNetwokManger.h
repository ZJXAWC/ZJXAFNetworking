//
//  ZJXAFNetwokManger.h
//  ICLibrary
//
//  Created by 曾健新 on 15/8/23.
//  Copyright (c) 2015年 曾健新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef  void(^ZJXAFNetwokMangerBlock)(NSString*);

@interface ZJXAFNetwokManger : AFHTTPRequestOperationManager

//block可以改变
@property(nonatomic,copy)__block NSString *netWorkingState;


+(instancetype)shareManager;
+(ZJXAFNetwokManger*)getNetWorkingState;

//设置block
-(void)setHomePageBlock:(ZJXAFNetwokMangerBlock)mangerBlock;


@end
