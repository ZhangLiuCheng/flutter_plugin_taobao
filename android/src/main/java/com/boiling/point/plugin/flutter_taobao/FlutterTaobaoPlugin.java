package com.boiling.point.plugin.flutter_taobao;

import android.app.Activity;
import android.util.Log;
import android.widget.Toast;

import com.ali.auth.third.core.model.Session;
import com.alibaba.baichuan.android.trade.AlibcTradeSDK;
import com.alibaba.baichuan.android.trade.adapter.login.AlibcLogin;
import com.alibaba.baichuan.android.trade.callback.AlibcLoginCallback;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeInitCallback;

import java.io.IOException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class FlutterTaobaoPlugin implements MethodCallHandler {

    private static Activity activity;

    public static void registerWith(Registrar registrar) {
        activity = registrar.activity();
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_taobao");
        channel.setMethodCallHandler(new FlutterTaobaoPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
//            this.okhttp();
            this.taobaoLogin();
            result.success("Android 1 " + android.os.Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }

    private void taobaoLogin() {
//        activity.runOnUiThread(
//                new Runnable() {
//                    @Override
//                    public void run() {
//                        AlibcTradeSDK.asyncInit(activity, new AlibcTradeInitCallback() {
//                            @Override
//                            public void onSuccess() {
//                                Toast.makeText(activity, "初始化成功 ", Toast.LENGTH_LONG).show();
//                                Log.v("TAG", "初始化: onSuccess");
//                            }
//
//                            @Override
//                            public void onFailure(int code, String msg) {
//                                Log.v("TAG", "初始化  onFailure:" + code + " --------  " + msg);
//
//                                Toast.makeText(activity, "初始化失败 ", Toast.LENGTH_LONG).show();
//                            }
//                        });
//                    }
//                }
//        );


        //初始化成功，设置相关的全局配置参数
        AlibcLogin alibcLogin = AlibcLogin.getInstance();
        alibcLogin.showLogin(activity, new AlibcLoginCallback() {
            @Override
            public void onSuccess() {
                Toast.makeText(activity, "登录成功 ", Toast.LENGTH_LONG).show();

                Session session = AlibcLogin.getInstance().getSession();
                String avatarUrl = AlibcLogin.getInstance().getSession().avatarUrl;//imgurl
                String nick = AlibcLogin.getInstance().getSession().nick;//nickname
                final String openId = AlibcLogin.getInstance().getSession().openId;//openid
                String openSid = AlibcLogin.getInstance().getSession().openSid;

                Log.v("TAG", "taobaoLogin: onSuccess" + session + " --------  " + openSid);
            }

            @Override
            public void onFailure(int code, String msg) {
                Toast.makeText(activity, "登录失败 ", Toast.LENGTH_LONG).show();

                Log.v("TAG", "taobaoLogin  onFailure:" + code + " --------  " + msg);

            }
        });
    }

    private void okhttp() {
        String url = "https://www.baidu.com";
        OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder()
                .url(url)
                .build();

        Call call = client.newCall(request);
        call.enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                Log.v("TAG", "exception:" + e.toString());
            }

            @Override
            public void onResponse(Call call, Response response) {
                try {
                    Log.v("TAG", "onResponse ===> " + response.body().string());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        });
    }
}
