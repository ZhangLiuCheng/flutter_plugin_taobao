package com.boiling.point.plugin.flutter_taobao;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class AuthActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_auth);

        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        WebView webView = findViewById(R.id.webview);
        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        webView.setWebViewClient(new MyWebViewClient());
        String url = "https://oauth.taobao.com/authorize?response_type=code&client_id=25793646&redirect_uri=urn:ietf:wg:oauth:2.0:oob&view=wap";
        webView.loadUrl(url);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        setResult(Activity.RESULT_CANCELED);
        overridePendingTransition(0, 0);
    }

    private class MyWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            Uri uri = Uri.parse(url);
            String code = uri.getQueryParameter("code");
            if (!TextUtils.isEmpty(code)) {
                Intent intent = new Intent();
                intent.putExtra("code", code);
                setResult(Activity.RESULT_OK, intent);
                finish();
                overridePendingTransition(0, 0);
            }
            return super.shouldOverrideUrlLoading(view, url);
        }
    }
}
