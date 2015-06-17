//
//  ShareInterfaceDefine.h
//  gwWxbj
//
//  Created by xu banghui on 13-6-27.
//  Copyright (c) 2013年 gwsoft. All rights reserved.
//


#ifndef gwWxbj_ShareInterfaceDefine_h
#define gwWxbj_ShareInterfaceDefine_h




#define AppKey_ShareSDK        @"51dfe4b82768"

#define AppKey_UMeng         @"549cca5cfd98c575c300075a"  //@"532b9c0356240b2ce506971d"

#define AppKey_SinaWeibo        @"3950922018" //@"1770139386"
#define AppKey_TCWeibo          @"801556824"   //@"801399854"
//#define AppKey_TCQQ             @"100487556"
#define AppKey_WeiXin           @"wx9fbf8ca89a13c496"//@"wx8dd37ddd478b00e5"

#define AppSecret_SinaWeibo    @"ec0f16f8b84b631c966f2ab5d80f3852"    //@"d51096b339de50987651afead0cce340"

//#define AppSecret_TCQQ           @"038bf3b5c0d5c59f2a028c52717ff817"
#define AppSecret_TCWeibo      @"0571dfb3ac040bb4133f76b3ffa753e2"   //@"46af0ac86081ae9ab0c467ba97651b09"
#define AppSecret_WeiXin        @"777ad47c817f32b9dbfd25e7c8b55a72"  //@"44656c62d7035fe9c481bda4dae1be32"



#define RedirectURL_SinaWeibo    @"http://www.join4talk.com"


#define RedirectURL_TCWeibo    @"http://sns.whalecloud.com/app/FE1uS"// @"http://www.join4talk.com"
#define RedirectURL_WeiXin      @"http://www.join4talk.com"

extern NSString *const GWNotify_ShareInterfaceResponse;



typedef enum{
    SDK_Type_None=0,
    SDK_Type_WeiXinTimeline,
    SDK_Type_WeiXinSession,
    SDK_Type_TC_WeiBo,
    SDK_Type_TC_QQ,
    SDK_Type_SinaWeiBo,
    SDK_Type_Email
}SDK_Type;





#endif
