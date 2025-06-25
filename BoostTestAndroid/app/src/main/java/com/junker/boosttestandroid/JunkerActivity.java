package com.junker.boosttestandroid;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.FlutterBoostRouteOptions;
import com.idlefish.flutterboost.containers.FlutterBoostActivity;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivityLaunchConfigs;

public class JunkerActivity extends AppCompatActivity {

    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_junker);
        findViewById(R.id.open_flutter_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Map<String,Object> param = new HashMap<>();
                param.put("data","我是从Android原生传过来的数据");
                FlutterBoost.instance().open(new FlutterBoostRouteOptions.Builder()
                        .pageName("simplePage")
                        .arguments(param)
                        .build());
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.e("TAG", "requestCode:"+requestCode+"|resultCode:"+resultCode+"|data = " + data);
        assert data != null;
        Bundle extras = data.getExtras();
        if (extras != null){
            HashMap activityResult = (HashMap) extras.get("ActivityResult");
            if (activityResult != null){
                String result = (String) activityResult.get("data"); //ActivityResult 是 flutter层返回数据给Android层，固定的 key
                Log.e("TAG", "requestCode:"+requestCode+"|resultCode:"+resultCode+"|result = " + result);
            }
        }

    }
}