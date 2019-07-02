#import "FlutterTaobaoPlugin.h"
#import "AlibcTradeSDK/AlibcTradeSDK.h"
#import "AlibabaAuthSDK/albbsdk.h"
#import "AuthViewController.h"

static NSString *const CHANNEL_NAME = @"com.boiling.point.coupon/pluginTaobao";

@interface FlutterTaobaoPlugin()

@property (nonatomic, retain) UIViewController *viewController;

- (instancetype)initWithViewController:(UIViewController *)viewController;

@end

@implementation FlutterTaobaoPlugin

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistry>*)registry {
    
    NSObject<FlutterPluginRegistrar> *registrar = [registry registrarForPlugin:CHANNEL_NAME];
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME binaryMessenger:registrar.messenger];
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    FlutterTaobaoPlugin* instance = [[FlutterTaobaoPlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    [FlutterTaobaoPlugin initAlibcTradeSDK];
}

+ (void) initAlibcTradeSDK {
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        NSLog(@"淘宝注册成功");
    } failure:^(NSError *error) {
        NSLog(@"淘宝注册失败 %@", error.description);
    }];
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[AlibcTradeSDK sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [[AlibcTradeSDK sharedInstance] application:application openURL:url options:options];
}


- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"taobaoLogin" isEqualToString:call.method]) {
        [self taobaoLogin: result];
    } else if ([@"taobaoAuth" isEqualToString:call.method]) {
        [self taobaoAuth:result];
    } else if ([@"taobaoOpenUrl" isEqualToString:call.method]) {
        NSDictionary *dic = [call arguments];
        NSString *url = [dic objectForKey:@"taboUrl"];
        [self taobaoOpenUrl: url];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)taobaoLogin: (FlutterResult)result {
    loginSuccessCallback loginSuccessCallback= ^(ALBBSession *session){
        ALBBUser *user = [session getUser];
        NSDictionary *loginData = [NSMutableDictionary new];
        [loginData setValue:user.avatarUrl forKey:@"avatarUrl"];
        [loginData setValue:user.nick forKey:@"nick"];
        [loginData setValue:user.openId forKey:@"openId"];
        [loginData setValue:user.openSid forKey:@"openSid"];
        result(loginData);
    };
    
    loginFailureCallback loginFailedCallback = ^(ALBBSession *session, NSError *error){
        FlutterError *flutterError = [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.localizedDescription details:@"淘宝登录失败"];
        result(flutterError);
    };
    [[ALBBSDK sharedInstance] auth:self.viewController successCallback:loginSuccessCallback failureCallback:loginFailedCallback];
}

- (void)taobaoAuth: (FlutterResult)result {
    AuthViewController *controller = [AuthViewController new];
    
    __block FlutterResult flutterResult = result;
    controller.callBackBlock = ^(NSString *code) {
        if (code != NULL) {
            flutterResult(code);
        } else {
            FlutterError *error = [FlutterError errorWithCode:@"-1" message:@"授权失败" details:@"用户取消授权"];
            flutterResult(error);
        }
    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.viewController presentViewController: nav animated:NO completion: nil];
}

- (void)taobaoOpenUrl: (NSString *)url {
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeNative;
    showParam.isNeedPush = YES;
    
    id<AlibcTradePage> page = [AlibcTradePageFactory page: url];
    [[AlibcTradeSDK sharedInstance].tradeService show: self.viewController page:page showParams:showParam taoKeParams: nil trackParam: nil tradeProcessSuccessCallback:^(AlibcTradeResult * result) {
    } tradeProcessFailedCallback:^(NSError *error){
        NSLog(@"打开链接失败");
    }];
}
@end
