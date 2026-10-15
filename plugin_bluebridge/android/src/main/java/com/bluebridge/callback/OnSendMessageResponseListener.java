package com.bluebridge.callback;


public interface OnSendMessageResponseListener {

    void onSuccess(int statusCode);

    void onFailed(int statusCode);

}