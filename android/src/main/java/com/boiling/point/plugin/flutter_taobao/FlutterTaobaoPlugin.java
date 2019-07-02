package com.boiling.point.plugin.flutter_taobao;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.util.Log;
import android.widget.Toast;

import com.ali.auth.third.core.model.Session;
import com.ali.auth.third.ui.context.CallbackContext;
import com.alibaba.baichuan.android.trade.AlibcTrade;
import com.alibaba.baichuan.android.trade.AlibcTradeSDK;
import com.alibaba.baichuan.android.trade.adapter.login.AlibcLogin;
import com.alibaba.baichuan.android.trade.callback.AlibcLoginCallback;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeCallback;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeInitCallback;
import com.alibaba.baichuan.android.trade.model.AlibcShowParams;
import com.alibaba.baichuan.android.trade.model.OpenType;
import com.alibaba.baichuan.android.trade.model.TradeResult;
import com.alibaba.baichuan.android.trade.page.AlibcBasePage;
import com.alibaba.baichuan.android.trade.page.AlibcPage;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterTaobaoPlugin implements MethodCallHandler {

    public static final int REQUEST_AUTH = 1001;

    private static Activity activity;
    private static MethodChannel.Result sAuthResult;

    private Handler handler = new Handler();
    private boolean initSuccess;


    public static void registerWith(Registrar registrar) {
        activity = registrar.activity();
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_taobao");
        channel.setMethodCallHandler(new FlutterTaobaoPlugin());
    }

    public static void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_AUTH) {
            if (sAuthResult != null) {
                if (resultCode == Activity.RESULT_OK) {
                    try {
                        String code = data.getStringExtra("code");
                        sAuthResult.success(code);
                    } catch (Exception ex) {
                        sAuthResult.error("授权失败", "-2", ex.toString());
                    }
                } else {
                    sAuthResult.error("授权失败", "-1", "用户取消授权");
                }
                sAuthResult = null;
            }
        } else {
            CallbackContext.onActivityResult(requestCode, resultCode, data);
        }
    }

    @Override
    public void onMethodCall(MethodCall methodCall, Result result) {
        if (methodCall.method.equals("taobaoInit")) {
            this.taobaoInit(null);
        } else if (methodCall.method.equals("taobaoLogin")) {
            if (initSuccess) {
                this.taobaoLogin(result);
            } else {
                taobaoLoginWithInit(result);
            }
        } else if (methodCall.method.equals("taobaoAuth")) {
            this.taobaoAuth(result);
        } else if (methodCall.method.equals("taobaoOpenUrl")) {
            String url = methodCall.argument("taboUrl");
            if (initSuccess) {
                this.openTaobaoUrl(url, result);
            } else {
                this.openTaobaoUrlWithInit(url, result);
            }
        } else {
            result.notImplemented();
        }
    }

    private void taobaoInit(final TaobaoInitListener listener) {
        AlibcTradeSDK.asyncInit(activity, new AlibcTradeInitCallback() {
            @Override
            public void onSuccess() {
//                Toast.makeText(activity, "初始化成功 ", Toast.LENGTH_LONG).show();
//                Log.e("TAG", "初始化: onSuccess");

                initSuccess = true;

                AlibcTradeSDK.setSyncForTaoke(true);
                if (null != listener) {
                    listener.success();
                }
            }

            @Override
            public void onFailure(int code, String msg) {
                if (null != listener) {
                    listener.failure(code, msg);
                }
//                Log.e("TAG", "初始化  onFailure:" + code + " --------  " + msg);

//                Toast.makeText(activity, "初始化失败 ", Toast.LENGTH_LONG).show();
                initSuccess = false;
            }
        });
    }

    private void taobaoLoginWithInit(final MethodChannel.Result result) {
        this.taobaoInit(new TaobaoInitListener() {
            @Override
            public void success() {
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        taobaoLogin(result);
                    }
                }, 100);
            }

            @Override
            public void failure(int code, String msg) {
                result.error("淘宝授权失败", code + "" , msg);
            }
        });
    }

    private void taobaoLogin(final MethodChannel.Result result) {
        AlibcLogin alibcLogin = AlibcLogin.getInstance();
        alibcLogin.showLogin(activity, new AlibcLoginCallback() {
            @Override
            public void onSuccess() {
                Session session = AlibcLogin.getInstance().getSession();
                Map<String, String> loginResult = new HashMap<>();
                loginResult.put("avatarUrl", session.avatarUrl);
                loginResult.put("nick", session.nick);
                loginResult.put("openId", session.openId);
                loginResult.put("openSid", session.openSid);
                result.success(loginResult);
            }

            @Override
            public void onFailure(int code, String msg) {
                result.error("淘宝授权失败", code + "" , msg);
            }
        });
    }

    private void taobaoAuth(MethodChannel.Result result) {
        sAuthResult = result;
        Intent intent = new Intent(activity, AuthActivity.class);
        activity.startActivityForResult(intent, REQUEST_AUTH);
        activity.overridePendingTransition(0, 0);
    }

    private void openTaobaoUrlWithInit(final String couponUrl, final MethodChannel.Result result) {
        this.taobaoInit(new TaobaoInitListener() {
            @Override
            public void success() {
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        openTaobaoUrl(couponUrl, result);
                    }
                }, 100);
            }

            @Override
            public void failure(int code, String msg) {
                result.error("打开失败", code + "" , msg);
            }
        });
    }

    private void openTaobaoUrl(String couponUrl, final MethodChannel.Result result) {
        AlibcBasePage page = new AlibcPage(couponUrl);
        AlibcShowParams showParams = new AlibcShowParams(OpenType.Native, false);

        try {
            AlibcTrade.show(activity, page, showParams, null, null, new AlibcTradeCallback() {
                @Override
                public void onTradeSuccess(TradeResult tradeResult) {
                    //打开电商组件，用户操作中成功信息回调。tradeResult：成功信息（结果类型：加购，支付；支付结果）
                    Log.e("TAG", "openTaobaoUrl: onTradeSuccess" + tradeResult);
                }

                @Override
                public void onFailure(int code, String msg) {
                    //打开电商组件，用户操作中错误信息回调。code：错误码；msg：错误信息
                    result.error("打开失败", code + "" , msg);
                }
            });
            result.success("打开成功");
        } catch (Exception ex) {
            result.error("打开失败",  "-1" , ex.toString());
        }

    }

    /*
    private void disableAPIDialog() {
        if (Build.VERSION.SDK_INT < 28) return;
        try {
            Class clazz = Class.forName("android.app.ActivityThread");
            Method currentActivityThread = clazz.getDeclaredMethod("currentActivityThread");
            currentActivityThread.setAccessible(true);
            Object activityThread = currentActivityThread.invoke(null);
            Field mHiddenApiWarningShown = clazz.getDeclaredField("mHiddenApiWarningShown");
            mHiddenApiWarningShown.setAccessible(true);
            mHiddenApiWarningShown.setBoolean(activityThread, true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    */

    private interface TaobaoInitListener{
        void success();
        void failure(int code, String msg);
    }
}
