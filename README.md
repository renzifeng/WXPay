微信支付
=================================== 
移动支付盛行,app接入逐渐成为标配

今天和大家分享一下微信支付的接入

调起微信支付的整个流程是:

一、在appDelegate中配置，并写好方法接受微信返回信息，

二、调用后台接口(自定义)与微信交互,微信返回必要参数,其中最主要一个参数是prepay_id

三、使用appid、noncestr（下面有详细生成方法）package(目前为固定值,直接给@"Sign=WXPay")、partnerid（就是mchId）timestamp（时间戳）、prepayid生成签名sign

四、将必要参数传给PayReq对象

五、最后，使用WXApi的sendReq方法吊起微信。

下面开始贴方法：
----------------------------------- 
### 准备工作：

1.到微信开放平台,申请开通支付功能(唯一注意,bundleId需与工程一致),在财付通回馈的邮箱中获取以下信息(注:以下信息已修改,不可直接复制使用)

      APP_ID @"wxf120b5260432545"                                  //APPID
      APP_SECRET @"998d17563f0d6d0181b90ff543656ygrs"              //appsecret
      MCH_ID @"1269999401"                                        //商户号
      PARTNER_ID @"xbM5MBCVOj2sEAs8KrMfwla4djpcQKuvG9"            //商户API密钥

2.下载微信支付SDK

3.AppDelegate 可直接复制使用

    #import "WXApi.h"
    #import "WXApiObject.h"
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
    {
            // 1.注册微信
            [WXApi registerApp:WECHAT_APPID withDescription:@"weichatpayblog"];
            return YES;
    }
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
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
                  case WXErrCodeUserCancel:{
                        strMsg = @"支付已取消";
                        strNote = @"cancel";
                        break;
                  }
                  case WXErrCodeSentFail: {
                        strMsg = @"支付失败,请重新支付";
                        strNote = @"fail";
                        break;
                  }
                  default:{
                        strMsg = @"支付失败";
                        strNote = @"fail"; 
                        break;
                  }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:ORDER_PAY_NOTIFICATION object:strNote];
            [Alert showWithTitle:strMsg];
    }
    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
    {
            return [WXApi handleOpenURL:url delegate:self];
    }
4.调起支付

      #import "WXApi.h"
      #import "WXApiObject"
      #import "WXUtil.h"
      - (void)clickPayWithWechat
      {
            // 判断客户端是否安装微信/版本是否支持 
            if ([self isWXAppInstalled]) {
                  [self updateOrderInfoToWechat];
            }
      }
      - (BOOL)isWXAppInstalled
      {
            // 1.判断是否安装微信
            if (![WXApi isWXAppInstalled]) {
                  [Alert showWithTitle:@"您尚未安装\"微信App\",请先安装后再返回支付"];
                  return NO;
            }
            // 2.判断微信的版本是否支持最新Api
            if (![WXApi isWXAppSupportApi]) {
                  [Alert showWithTitle:@"您微信当前版本不支持此功能,请先升级微信应用"];
                  return NO;
            }
            return YES;
      }
      - (void)updateOrderInfoToWechat
      {
             // 调用自己后台接口
             // 返回 prePay_id  
             // wechatModel 为自定义模型 存储微信支付所需参数
            if (wechatModel.prepay_id != nil) {
                  DLog(@" %@ ",wechatModel.prepay_id);
                  NSString *package, *time_stamp, *nonce_str;
                  time_t now;
                  time(&now);
                  time_stamp = [NSString stringWithFormat:@"%ld",now];
                  nonce_str = [WXUtil md5:time_stamp];
                  package = @"Sign=WXPay";
                  NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
                  [signParams setObject:WECHAT_APPID forKey:@"appid"];
                  [signParams setObject:nonce_str forKey:@"noncestr"];
                  [signParams setObject:package forKey:@"package"];
                  [signParams setObject:WECHAT_MCH_ID forKey:@"partnerid"];
                  [signParams setObject:time_stamp forKey:@"timestamp"];
                  [signParams setObject:wechatModel.prepay_id forKey:@"prepayid"];
                  NSString *sign = [self createMd5Sign:signParams];
                  [signParams setObject:sign forKey:@"sign"];
                  // 这里 调起微信  一个参数也不能少  重要的事 我不想说三遍了,调不起会来看三遍的 哈哈哈....
                  PayReq *req = [[PayReq alloc] init];
                  req.openID = WECHAT_APPID;
                  req.partnerId = WECHAT_MCH_ID;
                  req.prepayId = wechatModel.prepay_id;
                  req.nonceStr = nonce_str;
                  req.timeStamp = time_stamp.intValue;
                  req.package = package;
                  req.sign = sign;
                  [WXApi sendReq:req];
            }    
      }
      -(NSString*) createMd5Sign:(NSMutableDictionary*)dict
      {
            NSMutableString *contentString  =[NSMutableString string];
            NSArray *keys = [dict allKeys];
            //按字母顺序排序
            NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                  return [obj1 compare:obj2 options:NSNumericSearch];
            }];
            //拼接字符串
            for (NSString *categoryId in sortedArray) {
                  if (![[dict objectForKey:categoryId] isEqualToString:@""] && ![categoryId isEqualToString:@"sign"] && ![categoryId isEqualToString:@"key"])
            {
                  [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
            }
        
            }
            //添加key字段
            [contentString appendFormat:@"key=%@", wechatModel.key];
            //得到MD5 sign签名
            NSString *md5Sign =[WXUtil md5:contentString];
            //    //输出Debug Info
            //    [debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
             return md5Sign;
      }
      
至此  应该已经成功调起微信支付了,在这个类当中,添加观察者,对跳转后的信息处理

将状态信息传给自己的后台 就结束了

 

过程中需要注意的是

1.传个PayReq对象的参数不能少

2.如果工程中使用了友盟,会出现冲突,因为友盟的包里包含了微信sdk,删掉友盟里重复即可,这里网上有相关资料,不再赘述

 

如仍有问题,欢迎留言 一起探讨 
