//
//  AuthViewController.h
//  Runner
//
//  Created by admin on 2019/4/28.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void(^AuthResultBlcok) (NSString *code);

NS_ASSUME_NONNULL_BEGIN

@interface AuthViewController : UIViewController

@property (nonatomic,copy)AuthResultBlcok callBackBlock;

@end

NS_ASSUME_NONNULL_END
