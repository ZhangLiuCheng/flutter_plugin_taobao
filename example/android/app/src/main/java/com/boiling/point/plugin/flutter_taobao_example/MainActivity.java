package com.boiling.point.plugin.flutter_taobao_example;

import android.content.Intent;
import android.os.Bundle;

import com.boiling.point.plugin.flutter_taobao.FlutterTaobaoPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    FlutterTaobaoPlugin.onActivityResult(requestCode, resultCode, data);
  }
}
