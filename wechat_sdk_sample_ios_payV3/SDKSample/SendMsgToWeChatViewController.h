//
//  SendMsgToWeChatViewController.h
//  ApiClient
//
//  Created by Tencent on 12-2-27.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"

@protocol sendMsgToWeChatViewDelegate <NSObject>
- (void) changeScene:(NSInteger)scene;
- (void) sendTextContent;
- (void) sendImageContent;
- (void) sendPay;
- (void) sendPay_demo;
@end

@interface SendMsgToWeChatViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate,NSObject> delegate;

@end
