package com.bluebridge.callback;


public interface OnConnectListener {

    void onWriteInitDescriptorStatus(String mac, int statusCode);

    void onNotifyInitStatus(String mac, int statusCode, boolean isIndicate);

    void onNotify(String mac, byte[] bytes, String serviceUuid, String characterUuid, boolean isIndicate);

    void onConnectStatusChanged(String mac, int statusCode);

    void onConnected(String mac);

    void onDisconnected(String mac);

    void onConnectedError(String mac, String error);

}