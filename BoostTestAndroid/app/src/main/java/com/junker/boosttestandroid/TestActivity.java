package com.junker.boosttestandroid;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.FlutterBoostRouteOptions;
import com.idlefish.flutterboost.containers.FlutterBoostActivity;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivityLaunchConfigs;

public class TestActivity extends AppCompatActivity {
    private final static String TAG = TestActivity.class.getSimpleName();

    private TextView textView, textView2;

    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_test);
        Objects.requireNonNull(getSupportActionBar()).setTitle("TestActivity");

        textView = findViewById(R.id.test_content);
        textView2 = findViewById(R.id.test_callback_content);
        initData();

        findViewById(R.id.test_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Map<String, Object> param = new HashMap<>();
                param.put("data", "我是从TestActivity传过来的数据");
                FlutterBoost.instance().open(new FlutterBoostRouteOptions.Builder()
                        .pageName("mainPage")
                        .arguments(param)
                        .requestCode(1002)
                        .build());
            }
        });

        findViewById(R.id.test_callback_flutter_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    private void initData() {
        Bundle bundle = getIntent().getExtras();
        assert bundle != null;
        String data = bundle.getString("data");

        textView.setText(data);
    }

    @Override
    public void finish() {
//        Map<String,Object> map = new HashMap<>();
//        map.put("key1","value11111");
//        FlutterBoost.instance().sendEventToFlutter("eventToFlutter",map);

        Intent intent = new Intent();
        intent.putExtra("msg","This message is from Native!!!");
        intent.putExtra("bool", true);
        intent.putExtra("int", 666);
        setResult(123, intent);  // 返回结果给dart
        super.finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        assert data != null;
        Bundle extras = data.getExtras();
        if (extras != null){
            HashMap activityResult = (HashMap) extras.get("ActivityResult");
            if (activityResult != null){
                String result = (String) activityResult.get("data"); //ActivityResult 是 flutter层返回数据给Android层，固定的 key
                Log.e(TAG, "requestCode:"+requestCode+"|resultCode:"+resultCode+"|result = " + result);
                textView2.setText(result);
            }
        }

    }
}