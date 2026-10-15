package com.bluebridge;

import android.Manifest;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.util.Log;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.bluebridge.callback.OnConnectListener;
import com.bluebridge.callback.OnSearchListener;
import com.bluebridge.callback.OnSendMessageResponseListener;
import com.bluebridge.utils.BlueToothManager;
import com.inuker.bluetooth.library.search.SearchResult;
import com.inuker.bluetooth.library.utils.ScanRecordUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener;


public class BluebridgePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener, RequestPermissionsResultListener {

    private static final String TAG = "BluebridgePlugin";
    private static final String PLUGIN_NAMESPACE = "blue_bridge_plugin";

    private static final int REQUEST_OPEN_SETTING = 1000;
    private static final int REQUEST_COARSE_LOCATION_PERMISSIONS = 1001;
    private static final int REQUEST_ENABLE_BLUETOOTH = 1002;
    private static final int REQUEST_DISCOVERABLE_BLUETOOTH = 1003;

    private MethodChannel channel;
    private Activity activity;
    private ActivityPluginBinding binding;

    private BluetoothAdapter bluetoothAdapter;
    private BlueToothManager blueToothManager;

    private PendingPermissionsCallbacks pendingPermissionsCallbacks;
    private Result pendingResultForActivityResultOpenSettings;
    private Result pendingResultForActivityResultRequestEnable;
    private Result pendingResultForActivityResultRequestDiscoverable;

    // Discovery
    private EventChannel discoveryChannel;
    private EventSink discoverySink;
    private StreamHandler discoveryStreamHandler;
    private BroadcastReceiver discoveryReceiver;

    private EventChannel connectChannel;
    private EventSink connectSink;
    private StreamHandler connectStreamHandler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        BinaryMessenger binaryMessenger = flutterPluginBinding.getFlutterEngine().getDartExecutor();
        channel = new MethodChannel(binaryMessenger, PLUGIN_NAMESPACE + "/bluebridge");
        channel.setMethodCallHandler(this);
        initEventChannel(binaryMessenger);
    }

    private void startDiscovery() {
        IntentFilter intent = new IntentFilter();
        intent.addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
        intent.addAction(BluetoothDevice.ACTION_FOUND);
        activity.registerReceiver(discoveryReceiver, intent);
        bluetoothAdapter.startDiscovery();
    }

    private void cancelDiscovery() {
        try {
            activity.unregisterReceiver(discoveryReceiver);
        } catch (IllegalArgumentException ex) {
        }
        if (bluetoothAdapter != null) {
            bluetoothAdapter.cancelDiscovery();
        }
        if (discoverySink != null) {
            discoverySink.endOfStream();
            discoverySink = null;
        }
    }

    private void cancelConnect() {
        if (connectSink != null) {
            connectSink.endOfStream();
            connectSink = null;
        }
    }

    private boolean checkIsDeviceConnected(BluetoothDevice device) {
        try {
            java.lang.reflect.Method method;
            method = device.getClass().getMethod("isConnected");
            boolean value = (Boolean) method.invoke(device);
            return value;
        } catch (Exception ex) {
            return false;
        }
    }

    private void initEventChannel(BinaryMessenger binaryMessenger) {
        discoveryReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                final String action = intent.getAction();
                switch (action) {
                    case BluetoothDevice.ACTION_FOUND:
                        final BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                        //final BluetoothClass deviceClass = intent.getParcelableExtra(BluetoothDevice.EXTRA_CLASS);
                        //final String extraName = intent.getStringExtra(BluetoothDevice.EXTRA_NAME);
                        final int deviceRSSI = intent.getShortExtra(BluetoothDevice.EXTRA_RSSI, Short.MIN_VALUE);

                        Map<String, Object> discoveryResult = new HashMap<>();
                        discoveryResult.put("address", device.getAddress());
                        discoveryResult.put("name", device.getName());
                        discoveryResult.put("type", device.getType());
                        //discoveryResult.put("class", deviceClass);
                        discoveryResult.put("isConnected", checkIsDeviceConnected(device));
                        discoveryResult.put("bondState", device.getBondState());
                        discoveryResult.put("rssi", deviceRSSI);
                        Log.d(TAG, "Discovered " + device.getAddress());
                        if (discoverySink != null) {
                            discoverySink.success(discoveryResult);
                        }
                        break;
                    case BluetoothAdapter.ACTION_DISCOVERY_FINISHED:
                        Log.d(TAG, "Discovery finished");
                        cancelDiscovery();
                        break;
                    default:
                        Log.d(TAG, "Discovery other action:" + action);
                        break;
                }
            }
        };
        //discoveryChannel
        discoveryChannel = new EventChannel(binaryMessenger, PLUGIN_NAMESPACE + "/discovery");
        discoveryStreamHandler = new StreamHandler() {
            @Override
            public void onListen(Object o, EventSink eventSink) {
                discoverySink = eventSink;
            }

            @Override
            public void onCancel(Object o) {
                Log.d(TAG, "Canceling discovery (stream closed)");
                cancelDiscovery();
            }
        };
        discoveryChannel.setStreamHandler(discoveryStreamHandler);

        //connectChannel
        connectChannel = new EventChannel(binaryMessenger, PLUGIN_NAMESPACE + "/connect");
        connectStreamHandler = new StreamHandler() {
            @Override
            public void onListen(Object o, EventSink eventSink) {
                connectSink = eventSink;
            }

            @Override
            public void onCancel(Object o) {
                Log.d(TAG, "Canceling connect (stream closed)");
                cancelConnect();
            }
        };
        connectChannel.setStreamHandler(connectStreamHandler);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        if (bluetoothAdapter == null) {
            if ("isAvailable".equals(call.method)) {
                result.success(false);
                return;
            }
            result.error("bluetooth_unavailable", "bluetooth is not available", null);
            return;
        }
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "isEnabled":
                result.success(bluetoothAdapter.isEnabled());
                break;
            case "requestPermissions":
                checkPermissions(new PendingPermissionsCallbacks() {
                    @Override
                    public void onResult(boolean granted) {
                        result.success(granted);
                    }
                });
                break;
            case "openSettings":
                pendingResultForActivityResultOpenSettings = result;
                ActivityCompat.startActivityForResult(activity, new Intent(Settings.ACTION_BLUETOOTH_SETTINGS), REQUEST_OPEN_SETTING, null);
                break;
            case "requestEnable":
                if (!bluetoothAdapter.isEnabled()) {
                    pendingResultForActivityResultRequestEnable = result;
                    ActivityCompat.startActivityForResult(activity, new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), REQUEST_ENABLE_BLUETOOTH, null);
                } else {
                    result.success(false);
                }
                break;
            case "requestDisable":
                if (bluetoothAdapter.isEnabled()) {
                    bluetoothAdapter.disable();
                    result.success(true);
                } else {
                    result.success(false);
                }
                break;
            case "requestDiscoverable":
                Intent intent = new Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE);
                if (call.hasArgument("duration")) {
                    try {
                        int duration = (int) call.argument("duration");
                        intent.putExtra(BluetoothAdapter.EXTRA_DISCOVERABLE_DURATION, duration);
                    } catch (ClassCastException ex) {
                        result.error("invalid_argument", "'duration' argument is required to be integer", null);
                        break;
                    }
                }
                pendingResultForActivityResultRequestDiscoverable = result;
                ActivityCompat.startActivityForResult(activity, intent, REQUEST_DISCOVERABLE_BLUETOOTH, null);
                break;
            case "isDiscovering":
                result.success(bluetoothAdapter.isDiscovering());
                break;
            case "getBondedDevices":
                checkPermissions(new PendingPermissionsCallbacks() {
                    @Override
                    public void onResult(boolean granted) {
                        if (!granted) {
                            result.error("no_permissions", "discovering other devices requires location access permission", null);
                            return;
                        }
                        List<Map<String, Object>> list = new ArrayList<>();
                        for (BluetoothDevice device : bluetoothAdapter.getBondedDevices()) {
                            Map<String, Object> entry = new HashMap<>();
                            Log.d(TAG, "-------getBondedDevices  " + device.toString());
                            entry.put("address", device.getAddress());
                            entry.put("name", device.getName());
                            entry.put("type", device.getType());
                            entry.put("isConnected", checkIsDeviceConnected(device));
                            entry.put("bondState", BluetoothDevice.BOND_BONDED);
                            list.add(entry);
                        }
                        result.success(list);
                    }
                });
                break;
            case "startDiscovery":
                checkPermissions(new PendingPermissionsCallbacks() {
                    @Override
                    public void onResult(boolean granted) {
                        if (!granted) {
                            result.error("no_permissions", "discovering other devices requires location access permission", null);
                            return;
                        }
                        startDiscovery();
                        result.success(true);
                    }
                });
                break;
            case "cancelDiscovery":
                cancelDiscovery();
                result.success(true);
                break;
            case "init":
                blueToothManager.init();
                result.success(true);
                break;
            case "destory":
                blueToothManager.destory();
                result.success(true);
                break;
            case "searchDevices":
                blueToothManager.search(new OnSearchListener() {
                    @Override
                    public void onResult(List<SearchResult> devices, int status) {
                        List<Map<String, Object>> list = new ArrayList<>();
                        for (int i = 0; i < devices.size(); i++) {
                            SearchResult searchResult = devices.get(i);
                            if(searchResult.rssi == 0){
                                // 过滤掉离线的设备
                                continue;
                            }
                            Map<String, Object> entry = new HashMap<>();
                            Log.d(TAG, "-------searchDevicesonResult  " + searchResult.toString());
                            entry.put("address", searchResult.getAddress());
                            entry.put("name", searchResult.getName());
                            entry.put("type", searchResult.device.getType());
                            entry.put("isConnected", checkIsDeviceConnected(searchResult.device));
                            entry.put("bondState", searchResult.device.getBondState());
                            entry.put("rssi", searchResult.rssi);
                            list.add(entry);
                        }
                        result.success(list);
                    }
                });
                break;
            case "connect":
                String mac = null;
                if (call.hasArgument("mac")) {
                    mac = (String) call.argument("mac");
                }
                boolean res = blueToothManager.connect(mac, new OnConnectListener() {
                    @Override
                    public void onWriteInitDescriptorStatus(String mac, int statusCode) {
                        Map<String, Object> response = new HashMap<>();
                        response.put("operate", 1);
                        response.put("mac", mac);
                        response.put("statusCode", statusCode);
                        if (connectSink != null) {
                            connectSink.success(response);
                        }
                    }

                    @Override
                    public void onNotifyInitStatus(String mac, int statusCode, boolean isIndicate) {
                        Map<String, Object> response = new HashMap<>();
                        response.put("operate", 2);
                        response.put("mac", mac);
                        response.put("statusCode", statusCode);
                        response.put("isIndicate", isIndicate);
                        if (connectSink != null) {
                            connectSink.success(response);
                        }
                    }

                    @Override
                    public void onNotify(String mac, byte[] bytes, String serviceUuid, String characterUuid, boolean isIndicate) {
                        Map<String, Object> response = new HashMap<>();
                        response.put("operate", 3);
                        response.put("mac", mac);
                        response.put("bytes", bytes);
                        response.put("serviceUuid", serviceUuid);
                        response.put("characterUuid", characterUuid);
                        response.put("isIndicate", isIndicate);
                        if (connectSink != null) {
                            connectSink.success(response);
                        }
                    }

                    @Override
                    public void onConnectStatusChanged(String mac, int statusCode) {
                        Map<String, Object> response = new HashMap<>();
                        response.put("operate", 4);
                        response.put("mac", mac);
                        response.put("status", statusCode);
                        if (connectSink != null) {
                            connectSink.success(response);
                        }
                    }

                    @Override
                    public void onConnected(String mac) {
                        Map<String, Object> response = new HashMap<>();
                        response.put("operate", 5);
                        response.put("mac", mac);
                        if (connectSink != null) {
                            connectSink.success(response);
                        }
                    }

                    @Override
                    public void onDisconnected(String mac) {
                        Map<String, Object> response = new HashMap<>();
                        response.put("operate", 6);
                        response.put("mac", mac);
                        if (connectSink != null) {
                            connectSink.success(response);
                        }
                    }

                    @Override
                    public void onConnectedError(String mac, String error) {
                        Map<String, Object> response = new HashMap<>();
                        response.put("operate", 7);
                        response.put("mac", mac);
                        response.put("error", error);
                        if (connectSink != null) {
                            connectSink.success(response);
                        }
                    }
                },false);
                result.success(res);
                break;
            case "disConnect":
                blueToothManager.disConnect(true);
                result.success(true);
                break;
            case "sendMessage":
                try {
                    if (call.hasArgument("bytes")) {
                        // 确保 bytes 参数存在且类型正确
                        byte[] bytes = call.argument("bytes");
                        if (bytes != null && bytes.length > 0) {
                            blueToothManager.sendMessage(bytes, true, new OnSendMessageResponseListener() {
                                private boolean callbackInvoked = false; // 防止多次回调

                                @Override
                                public void onSuccess(int statusCode) {
                                    if (!callbackInvoked) {
                                        callbackInvoked = true;
                                        result.success(true);
                                    }
                                }

                                @Override
                                public void onFailed(int statusCode) {
                                    if (!callbackInvoked) {
                                        callbackInvoked = true;
                                        result.success(false); // 或者使用 result.error
                                    }
                                }
                            });
                        } else {
                            // 空数据直接返回错误
                            result.success(false);
                        }
                    } else {
                        // 缺少参数直接返回错误
                        result.success(false);
                    }
                } catch (Exception e) {
                    // 捕获所有异常并返回错误
                    result.success(false);
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        if (activity != null) {
            cancelDiscovery();
        }
        cancelConnect();
        channel.setMethodCallHandler(null);
    }

    private void onAttadched(ActivityPluginBinding binding) {
        activity = binding.getActivity();
        this.binding = binding;
        binding.addRequestPermissionsResultListener(this);
        binding.addActivityResultListener(this);
        BluetoothManager bluetoothManager = (BluetoothManager) activity.getSystemService(Context.BLUETOOTH_SERVICE);
        bluetoothAdapter = bluetoothManager.getAdapter();
        blueToothManager = BlueToothManager.getInstance(activity);
    }

    private void onDetached() {
        if (binding != null) {
            binding.removeRequestPermissionsResultListener(this);
            binding.removeActivityResultListener(this);
        }
        binding = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        onAttadched(binding);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetached();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        onAttadched(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        onDetached();
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case REQUEST_COARSE_LOCATION_PERMISSIONS:
                pendingPermissionsCallbacks.onResult(grantResults[0] == PackageManager.PERMISSION_GRANTED);
                pendingPermissionsCallbacks = null;
                return true;
        }
        return false;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case REQUEST_OPEN_SETTING:
                pendingResultForActivityResultOpenSettings.success(resultCode != 0);
                return true;
            case REQUEST_ENABLE_BLUETOOTH:
                pendingResultForActivityResultRequestEnable.success(resultCode != 0);
                return true;
            case REQUEST_DISCOVERABLE_BLUETOOTH:
                pendingResultForActivityResultRequestDiscoverable.success(resultCode == 0 ? -1 : resultCode);
                return true;
            default:
                return false;
        }
    }

    private void checkPermissions(PendingPermissionsCallbacks callbacks) {
        // android api 31
        List<String> requestList = new ArrayList<String>();
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            requestList.add(Manifest.permission.BLUETOOTH_SCAN);
            requestList.add(Manifest.permission.BLUETOOTH_ADVERTISE);
            requestList.add(Manifest.permission.BLUETOOTH_CONNECT);
            ActivityCompat.requestPermissions(activity,requestList.toArray(new String[0]),REQUEST_COARSE_LOCATION_PERMISSIONS);
            pendingPermissionsCallbacks = callbacks;
        } 
        else if (ContextCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED||ContextCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.ACCESS_COARSE_LOCATION,Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_COARSE_LOCATION_PERMISSIONS);
            pendingPermissionsCallbacks = callbacks;
        } else {
            callbacks.onResult(true);
        }
    }

    private interface PendingPermissionsCallbacks {
        void onResult(boolean granted);
    }
}
