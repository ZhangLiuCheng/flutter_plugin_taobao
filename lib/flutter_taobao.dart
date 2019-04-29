import 'dart:async';

import 'package:flutter/services.dart';

class FlutterTaobao {
    static const MethodChannel _channel = const MethodChannel('flutter_taobao');
    
    static Future<String> get platformVersion async {
        final String version = await _channel.invokeMethod('getPlatformVersion');
        return version;
    }

    static taobaoInit() async {
        return await _channel.invokeMethod("taobaoInit");
    }
    
    static taobaoLogin() async {
        return await _channel.invokeMethod("taobaoLogin");
    }
    
    static taobaoAuth() async {
        return await _channel.invokeMethod("taobaoAuth");
    }
    
    static taobaoOpenUrl(couponUrl) async {
        return await _channel.invokeMethod("taobaoOpenUrl", {"taboUrl": couponUrl});
    }
}
