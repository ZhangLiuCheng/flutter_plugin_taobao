import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_taobao/flutter_taobao.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
    @override
    _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    String _platformVersion = 'Unknown';
    
    @override
    void initState() {
        super.initState();
        initPlatformState();
        
        FlutterTaobao.taobaoInit();
    }
    
    Future<void> initPlatformState() async {
        String platformVersion;
        try {
            platformVersion = await FlutterTaobao.platformVersion;
        } on PlatformException {
            platformVersion = 'Failed to get platform version.';
        }
        
        if(!mounted) return;
        
        setState(() {
            _platformVersion = platformVersion;
        });
    }
    
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    title: const Text('Plugin example app'),
                ),
                body: Center(
                    child: Column(
                        children: <Widget>[
                            Text('Running on: $_platformVersion\n'),
                            FlatButton(onPressed: () {
                                FlutterTaobao.taobaoLogin().then((result) {}).catchError((err1) {});
                            }, child: Text("淘宝登录")),
                            
                            FlatButton(onPressed: () {
                                FlutterTaobao.taobaoAuth().then((result) {}).catchError((err1) {});
                            }, child: Text("淘宝授权")),
                            
                            FlatButton(onPressed: () {
                                FlutterTaobao.taobaoOpenUrl(
                                    "http://s.click.taobao.com/t?e=m%3D2%26s%3DqO174X7ddK4cQipKwQzePOeEDrYVVa64lwnaF1WLQxlyINtkUhsv0Nu7N%2BQHttnQtpJN%2F%2BiWF9oPuZkIjhEX%2Fp6spV2BkZQgREhtoEPB67xCtfzqDcyS878SqJW29L6LQ46khh5dizk%2FAHAqp8fw3IKqi6RyWyKrjB7r%2B0aDb9HA690f%2B0EVnrAWYDo4DlP%2FO7KVcE3z2EnGDF1NzTQoPw%3D%3D&scm=null&pvid=100_11.139.248.213_64083_811556084410875480&app_pvid=59590_11.9.37.67_70854_1556084410872&ptl=floorId:2836;pvid:100_11.139.248.213_64083_811556084410875480;app_pvid:59590_11.9.37.67_70854_1556084410872&xId=DTBjWqEYm1wum3nQKd3oPWmgQBudIVYYQHCplmx60rPgmHdasJoHKSLxZzgJ2SpQTr3TgH5ziwkQhRnlvHRa6Q&union_lens=lensId:0b092543_0c71_16a4ddbca28_6279&relation_id=2105068944");
                            }, child: Text("优惠劵详情"))
                        ],
                    )
                ),
            ),
        );
    }
}
