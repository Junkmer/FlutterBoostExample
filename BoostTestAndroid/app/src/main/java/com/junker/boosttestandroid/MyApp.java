package com.junker.boosttestandroid;

import android.app.Application;
import android.content.Intent;

import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.FlutterBoostDelegate;
import com.idlefish.flutterboost.FlutterBoostRouteOptions;
import com.idlefish.flutterboost.containers.FlutterBoostActivity;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivityLaunchConfigs;

public class MyApp extends Application {
    private final static String TAG = MyApp.class.getSimpleName();

    @Override
    public void onCreate() {
        super.onCreate();
        FlutterBoost.instance().setup(this, new FlutterBoostDelegate() {
            @Override
            public void pushNativeRoute(FlutterBoostRouteOptions options) {
                Log.d(TAG,"pushNativeRoute...1111111");
                switch (options.pageName()){
                    case "native_test":
                        //这里根据options.pageName来判断你想跳转哪个页面，这里简单给一个
                        Intent intent = new Intent(FlutterBoost.instance().currentActivity(), TestActivity.class);
                        intent.putExtra("data", (String) options.arguments().get("data"));
//                        FlutterBoost.instance().currentActivity().startActivity(intent);
                        FlutterBoost.instance().currentActivity().startActivityForResult(intent, options.requestCode());
                        break;
                }
            }

            @Override
            public void pushFlutterRoute(FlutterBoostRouteOptions options) {
                Log.d(TAG,"pushFlutterRoute...222222");
                Intent intent = new FlutterBoostActivity.CachedEngineIntentBuilder(FlutterBoostActivity.class)
                        .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                        .destroyEngineWithActivity(false)
                        .uniqueId(options.uniqueId())
                        .url(options.pageName())
                        .urlParams(options.arguments())
                        .build(FlutterBoost.instance().currentActivity());
                if (options.requestCode() > 1000){//返回上一个页面时，需要返回结果
                    FlutterBoost.instance().currentActivity().startActivityForResult(intent, options.requestCode());
                }else {
                    FlutterBoost.instance().currentActivity().startActivity(intent);
                }
            }
        }, engine -> {
        });
    }
}