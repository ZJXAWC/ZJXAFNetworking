//
//  ZJXAFNetwokManger.m
//  ICLibrary
//
//  Created by 曾健新 on 15/8/23.
//  Copyright (c) 2015年 曾健新. All rights reserved.
//

#import "ZJXAFNetwokManger.h"

@interface ZJXAFNetwokManger()

//block用copy
@property(nonatomic,copy)ZJXAFNetwokMangerBlock homePageBlock;

@end

@implementation ZJXAFNetwokManger

static ZJXAFNetwokManger *manager = nil;

+(instancetype)shareManager
{
    if (manager == nil) {
        @synchronized (self)
        {
         manager = [ZJXAFNetwokManger getNetWorkingState];
        }
    }
    return manager;
}

+(ZJXAFNetwokManger*)getNetWorkingState
{
    ZJXAFNetwokManger *AFManager = [[ZJXAFNetwokManger alloc]initWithBaseURL:[NSURL URLWithString:@"www.baidu.com"]];
    AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __weak typeof(AFManager) weakManager = AFManager;
    [AFManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                weakManager.netWorkingState = @"未知网络";
                //无缓存才下载
                weakManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                weakManager.netWorkingState = @"断开网络";
                //加载缓存，没有就失败
                weakManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                weakManager.netWorkingState = @"手机网络";
                //无缓存才下载
                weakManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                weakManager.netWorkingState = @"WIFI网络";
                //无缓存才下载
                weakManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
            }
                break;
            default:
            {
                weakManager.netWorkingState = @"获取失败";
            }
                break;
        }
        
        static unsigned int i = 0;
        
        if (weakManager.homePageBlock) {
            if (!([weakManager.netWorkingState isEqualToString:@"手机网络" ] || [weakManager.netWorkingState isEqualToString:@"WIFI网络" ])) {
                 weakManager.homePageBlock(weakManager.netWorkingState);
            }else if(i > 0)
            {
                 weakManager.homePageBlock(weakManager.netWorkingState);
            }
        }
        i = 1;
    }];
    [AFManager.reachabilityManager startMonitoring];
    return AFManager;
}


-(void)setHomePageBlock:(ZJXAFNetwokMangerBlock)mangerBlock;
{
    _homePageBlock = [mangerBlock copy];
}


@end
