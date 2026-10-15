package com.bluebridge.utils;

import android.bluetooth.BluetoothGattDescriptor;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.RequiresApi;

import com.bluebridge.callback.OnConnectListener;
import com.bluebridge.callback.OnSearchListener;
import com.bluebridge.callback.OnSendMessageListener;
import com.bluebridge.callback.OnSendMessageResponseListener;
import com.bluebridge.model.Message;
import com.inuker.bluetooth.library.BluetoothClient;
import com.inuker.bluetooth.library.Constants;
import com.inuker.bluetooth.library.connect.listener.BleConnectStatusListener;
import com.inuker.bluetooth.library.connect.options.BleConnectOptions;
import com.inuker.bluetooth.library.connect.response.BleConnectResponse;
import com.inuker.bluetooth.library.connect.response.BleNotifyResponse;
import com.inuker.bluetooth.library.connect.response.BleWriteResponse;
import com.inuker.bluetooth.library.model.BleGattCharacter;
import com.inuker.bluetooth.library.model.BleGattDescriptor;
import com.inuker.bluetooth.library.model.BleGattProfile;
import com.inuker.bluetooth.library.model.BleGattService;
import com.inuker.bluetooth.library.search.SearchRequest;
import com.inuker.bluetooth.library.search.SearchResult;
import com.inuker.bluetooth.library.search.response.SearchResponse;
import com.inuker.bluetooth.library.beacon.Beacon;
import com.inuker.bluetooth.library.utils.ScanRecordUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;


public class BlueToothManager {
    private static final String TAG = "BlueToothManager";

    private static BlueToothManager blueToothManager;

    private final MessageHelper messageSendHelper = new MessageHelper();
    private final Handler handler = new Handler(Looper.getMainLooper());

    private BluetoothClient bluetoothClient;
    private Context context;
    private Map<String, SearchResult> devices = new HashMap<>();

    private boolean isConnected=false;
    private String mac;
    private OnConnectListener onConnectListener;
    private BleGattProfile bleGattProfile;
    private UUID serviceUUID;
    private UUID charUUID;
    private UUID desUUID;
    private BleConnectStatusListener bleConnectStatusListener;

    private long lastRetryConnect=0;

    private BlueToothManager(Context context) {
        this.context = context;
    }

    public static synchronized BlueToothManager getInstance(Context context) {
        if (blueToothManager == null) {
            blueToothManager = new BlueToothManager(context.getApplicationContext());
        }
        return blueToothManager;
    }

    public void init() {
        if (bluetoothClient == null) {
            bluetoothClient = new BluetoothClient(context);
            bluetoothClient.openBluetooth();
            messageSendHelper.open();
        }
    }

    public void destory() {
        if (bluetoothClient != null) {
            stopSearch();
            disConnect(true);
            messageSendHelper.close();
            handler.removeCallbacksAndMessages(null);
            bluetoothClient = null;
        }
    }

    public void search(final OnSearchListener onSearchListener) {
        if (!bluetoothClient.isBluetoothOpened()) {
            bluetoothClient.openBluetooth();
            Log.e(TAG, "try open bluetooth");
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    doSearch(onSearchListener);
                }
            }, 2200);
        }else {
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    doSearch(onSearchListener);
                }
            }, 500);
        }
    }

    private void doSearch(final OnSearchListener onSearchListener){
        SearchRequest searchRequest = new SearchRequest.Builder()
                .searchBluetoothLeDevice(2000, 2)
                .searchBluetoothClassicDevice(2000)
                .searchBluetoothLeDevice(2000, 1)
                .build();
        try {
            bluetoothClient.search(searchRequest, new SearchResponse() {
                @Override
                public void onSearchStarted() {

                }

                @Override
                public void onDeviceFounded(SearchResult searchResult) {
                    // Beacon beacon = new Beacon(searchResult.scanRecord);
                    // Log.d(TAG,"beacon: " + beacon.toString() + " mac: " + searchResult.toString());
                    // Log.d(TAG,"scanRecord: " + ScanRecordUtil.parseFromBytes(searchResult.scanRecord).getDeviceName() + " mac: " + searchResult.toString());
                    devices.put(searchResult.getAddress(), searchResult);
                }

                @Override
                public void onSearchStopped() {
                    onSearchListener.onResult(MapUtil.mapToList(devices), 1);
                }

                @Override
                public void onSearchCanceled() {
                    onSearchListener.onResult(MapUtil.mapToList(devices), 0);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
            onSearchListener.onResult(new ArrayList(), -1);
        }
    }

    public void stopSearch() {
        bluetoothClient.stopSearch();
    }


    public boolean connect(final String mac, final OnConnectListener onConnectListener,final boolean fromReconnect) {
        if (mac == null || onConnectListener == null) {
            return false;
        }
        init();
        try {
            disConnect(false);
            bleConnectStatusListener = new BleConnectStatusListener() {
                @Override
                public void onConnectStatusChanged(String mac, int status) {
                    onConnectListener.onConnectStatusChanged(mac, status);
                    if (status == Constants.STATUS_DISCONNECTED) {
                        onConnectListener.onDisconnected(mac);
                    }
                }
            };
            bluetoothClient.registerConnectStatusListener(mac, bleConnectStatusListener);
            BleConnectOptions bleConnectOptions = new BleConnectOptions.Builder()
                    .setConnectRetry(2)
                    .setConnectTimeout(3000)
                    .setServiceDiscoverRetry(2)
                    .setServiceDiscoverTimeout(2000)
                    .build();
            bluetoothClient.connect(mac, bleConnectOptions, new BleConnectResponse() {
                @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
                @Override
                public void onResponse(int code, BleGattProfile bleGattProfile) {
                    if (code == Constants.REQUEST_SUCCESS) {
                        if(!fromReconnect) {
                            onConnectListener.onConnected(mac);
                        }
                        BlueToothManager.this.bleGattProfile = bleGattProfile;
                        initConfig(bleGattProfile, onConnectListener);
                    }else{
                        if(!fromReconnect) {
                            onConnectListener.onConnectedError(mac, String.valueOf(code));
                        }
                    }
                }
            });
            BlueToothManager.this.isConnected=true;
            BlueToothManager.this.mac = mac;
            BlueToothManager.this.onConnectListener = onConnectListener;
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if(!fromReconnect) {
                onConnectListener.onConnectedError(mac, "connect error");
            }
        }
        return false;
    }

    public void disConnect(boolean cleanOld) {
        if (isConnected) {
            try {
                bluetoothClient.disconnect(mac);
                bluetoothClient.unregisterConnectStatusListener(mac, bleConnectStatusListener);
                bleConnectStatusListener = null;
                if(cleanOld){
                    mac=null;
                    onConnectListener=null;
                    bleGattProfile=null;
                }
                isConnected=false;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
    public void initConfig(BleGattProfile bleGattProfile, final OnConnectListener onConnectListener) {
        if (mac == null || bleGattProfile == null || onConnectListener == null) {
            return;
        }
        try {
            for (BleGattService bleGattService : bleGattProfile.getServices()) {//All UUID is get the childs first
                serviceUUID = bleGattService.getUUID();
                for (BleGattCharacter bleGattCharacter : bleGattService.getCharacters()) {
                    charUUID = bleGattCharacter.getUuid();
                    List<BleGattDescriptor> descriptors = bleGattCharacter.getDescriptors();
                    for (BleGattDescriptor bleGattDescriptor : descriptors) {
                        desUUID = bleGattDescriptor.getmUuid().getUuid();
                    }
                }
            }
            bluetoothClient.writeDescriptor(mac, serviceUUID, charUUID, desUUID, BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE, new BleWriteResponse() {
                @Override
                public void onResponse(int code) {
                    if (code == Constants.REQUEST_SUCCESS) {
                        bluetoothClient.notify(mac, serviceUUID, charUUID, new BleNotifyResponse() {
                            @Override
                            public void onNotify(UUID service, UUID character, byte[] value) {
                                Log.e(TAG, "notify data is : " + ByteUtil.bytesToHex(value));
                                onConnectListener.onNotify(mac, value, service.toString(), character.toString(), false);
                            }

                            @Override
                            public void onResponse(int code) {
                                if (code == Constants.REQUEST_SUCCESS) {
                                    Log.e(TAG, "notify success");
                                } else {
                                    Log.e(TAG, "notify fail");
                                }
                                onConnectListener.onNotifyInitStatus(mac, code, false);
                            }
                        });
                        bluetoothClient.indicate(mac, serviceUUID, charUUID, new BleNotifyResponse() {
                            @Override
                            public void onNotify(UUID service, UUID character, byte[] value) {
                                Log.e(TAG, "indicate data is : " + ByteUtil.bytesToHex(value));
                                onConnectListener.onNotify(mac, value, service.toString(), character.toString(), true);
                            }

                            @Override
                            public void onResponse(int code) {
                                if (code == Constants.REQUEST_SUCCESS) {
                                    Log.e(TAG, "indicate success");
                                } else {
                                    Log.e(TAG, "indicate fail");
                                }
                                onConnectListener.onNotifyInitStatus(mac, code, true);
                            }
                        });
                    }
                    onConnectListener.onWriteInitDescriptorStatus(mac, code);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
            onConnectListener.onWriteInitDescriptorStatus(mac, Constants.REQUEST_FAILED);
        }
    }

    public void sendMessage(final byte[] bytes, final boolean needRetry, final OnSendMessageResponseListener onSendMessageResponseListener) {
        if (mac == null) {
            Log.e(TAG, "bluetooth connect is not init");
            sendMessageResponse(onSendMessageResponseListener,Constants.REQUEST_FAILED);
            return;
        }
        OnSendMessageListener onSendMessageListener = new OnSendMessageListener() {
            @Override
            public void onSendStatus(int statusCode) {
                if (statusCode != Constants.REQUEST_SUCCESS) {
                    Log.e(TAG, "connect is closed,retry connect:" + mac + "__" + statusCode);
                    if (needRetry) {
                        retryConnectAndSendMessage(bytes, statusCode, onSendMessageResponseListener);
                    } else {
                        sendMessageResponse(onSendMessageResponseListener,statusCode);
                    }
                } else {
                    sendMessageResponse(onSendMessageResponseListener,statusCode);
                }
            }
        };
        messageSendHelper.putMessage(new Message(bytes, bluetoothClient, mac, serviceUUID, charUUID, onSendMessageListener));
    }

    private void sendMessageResponse(OnSendMessageResponseListener onSendMessageResponseListener,int statusCode){
        if(onSendMessageResponseListener==null){
            return;
        }
        if(statusCode==Constants.REQUEST_SUCCESS){
            onSendMessageResponseListener.onSuccess(statusCode);
        }else{
            onSendMessageResponseListener.onFailed(statusCode);
        }
    }


    private void retryConnectAndSendMessage(final byte[] bytes, final int statusCode, final OnSendMessageResponseListener onSendMessageResponseListener) {
        boolean res;
        if (System.currentTimeMillis() - lastRetryConnect > 10000) {
            res = connect(mac, onConnectListener,true);
            lastRetryConnect= System.currentTimeMillis();
        }else {
            res=true;
        }
        if (res) {
            handler.postDelayed(new Runnable() {//when try connect again resend the message
                @Override
                public void run() {
                    sendMessage(bytes, false, onSendMessageResponseListener);
                }
            }, 1000);
        } else {
            Log.e(TAG, "bluetooth retry connect failed");
            sendMessageResponse(onSendMessageResponseListener,statusCode);
        }
    }
}
