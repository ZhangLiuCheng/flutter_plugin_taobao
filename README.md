# flutter_taobao

## 功能说明

淘宝登录
    可以获取淘宝的openid 头像 昵称 opensid等信息

淘宝授权
    获取auth

商品详情


## 使用

    1.登录
        FlutterTaobao.taobaoLogin().then((result) {}).catchError((err) {});

    2.授权
        FlutterTaobao.taobaoAuth().then((result) {}).catchError((err) {});

    3.商品详情
         FlutterTaobao.taobaoOpenUrl("url");

    4.最好提前预先初始化，不调用也没关系。
        FlutterTaobao.taobaoInit();

## 对接

    一.Android
        将yw_1222.jpg拷贝到drawable目录下
        AndroidManifest.xml 里面添加 <meta-data android:name="com.alibaba.apmplus.app_key"
        android:value="26024449" />


    二.ios对接好了，还没添加到库里面，项目太赶时间，后续有时间在对接上去。有需要可以加qq群 176880648