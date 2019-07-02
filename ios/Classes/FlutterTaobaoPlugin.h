#import <Flutter/Flutter.h>

@interface FlutterTaobaoPlugin : NSObject<FlutterPlugin>

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistry>*)registry;

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

@end
