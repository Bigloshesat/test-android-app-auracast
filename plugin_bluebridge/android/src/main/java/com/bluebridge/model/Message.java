package com.bluebridge.model;

import com.bluebridge.callback.OnSendMessageListener;
import com.inuker.bluetooth.library.BluetoothClient;

import java.util.UUID;

public class Message {
    private byte[] bytes;
    private BluetoothClient bluetoothClient;
    private String mac;
    private UUID serviceUUID;
    private UUID charUUID;
    private OnSendMessageListener onSendMessageListener;
    private int delay = 200;


    public Message(byte[] bytes, BluetoothClient bluetoothClient, String mac, UUID serviceUUID, UUID charUUID, OnSendMessageListener onSendMessageListener) {
        this.bytes = bytes;
        this.bluetoothClient = bluetoothClient;
        this.mac = mac;
        this.serviceUUID = serviceUUID;
        this.charUUID = charUUID;
        this.onSendMessageListener = onSendMessageListener;
    }

    public byte[] getBytes() {
        return bytes;
    }

    public void setBytes(byte[] bytes) {
        this.bytes = bytes;
    }

    public BluetoothClient getBluetoothClient() {
        return bluetoothClient;
    }

    public void setBluetoothClient(BluetoothClient bluetoothClient) {
        this.bluetoothClient = bluetoothClient;
    }

    public String getMac() {
        return mac;
    }

    public void setMac(String mac) {
        this.mac = mac;
    }

    public UUID getServiceUUID() {
        return serviceUUID;
    }

    public void setServiceUUID(UUID serviceUUID) {
        this.serviceUUID = serviceUUID;
    }

    public UUID getCharUUID() {
        return charUUID;
    }

    public void setCharUUID(UUID charUUID) {
        this.charUUID = charUUID;
    }

    public OnSendMessageListener getOnSendMessageListener() {
        return onSendMessageListener;
    }

    public void setOnSendMessageListener(OnSendMessageListener onSendMessageListener) {
        this.onSendMessageListener = onSendMessageListener;
    }

    public int getDelay() {
        return delay;
    }

    public void setDelay(int delay) {
        this.delay = delay;
    }
}
