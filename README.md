移动支付盛行,app接入逐渐成为标配

今天和大家分享一下微信支付的接入

调起微信支付的整个流程是:

一、在appDelegate中配置，并写好方法接受微信返回信息，

二、调用后台接口(自定义)与微信交互,微信返回必要参数,其中最主要一个参数是prepay_id

三、使用appid、noncestr（下面有详细生成方法）package(目前为固定值,直接给@"Sign=WXPay")、partnerid（就是mchId）timestamp（时间戳）、prepayid生成签名sign

四、将必要参数传给PayReq对象

五、最后，使用WXApi的sendReq方法吊起微信。

下面开始贴方法：

准备工作：

到微信开放平台,申请开通支付功能(唯一注意,bundleId需与工程一致),在财付通回馈的邮箱中获取以下信息(注:以下信息已修改,不可直接复制使用)

APP_ID @"wxf120b5260432545"                                  //APPID

APP_SECRET @"998d17563f0d6d0181b90ff543656ygrs"  //appsecret

MCH_ID @"1269999401"                                              //商户号
PARTNER_ID @"xbM5MBCVOj2sEAs8KrMfwla4djpcQKuvG9"   //商户API密钥

2.下载微信支付SDK

3.AppDelegate 可直接复制使用
    1 #import "WXApi.h"
    #import "WXApiObject.h"
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   // 1.注册微信
   [WXApi registerApp:WECHAT_APPID withDescription:@"weichatpayblog"];
 
    return YES;
    }
    
    - (BOOL)application:(UIApplication *)application
    openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
    annotation:(id)annotation
    {
    return [WXApi handleOpenURL:url delegate:self];
    }
    
   - (void)onResp:(BaseResp *)resp
    {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d",resp.errCode];
    NSString *strTitle;
    NSString *strNote;
    if ([resp isKindOfClass:[PayResp class]]) {
    // 支付返回结果,实际支付结果需要去微信服务器端查询
   strTitle = @"支付结果";
    }
    
    switch (resp.errCode) {
    case WXSuccess:{
    strMsg = @"支付成功,可以进行洗车";
   strNote = @"success";
    break;
   }
   case WXErrCodeUserCancel:
   strMsg = @"支付已取消";
    strNote = @"cancel";
    break;
    case WXErrCodeSentFail:
    strMsg = @"支付失败,请重新支付";
    strNote = @"fail";
   break;
   default:{
   strMsg = @"支付失败";
    strNote = @"fail";
   break;
    }
    }
    
    //    NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:strNote];
   //    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORDER_PAY_NOTIFICATION object:strNote];
    [Alert showWithTitle:strMsg];
    }
  
    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
   {
    return [WXApi handleOpenURL:url delegate:self];
   }

  
