package com.bluebridge.utils;

import android.os.Handler;
import android.os.Looper;
import android.os.Process;
import android.util.Log;

import com.bluebridge.callback.OnSendMessageListener;
import com.bluebridge.model.Message;
import com.inuker.bluetooth.library.BluetoothClient;
import com.inuker.bluetooth.library.connect.response.BleWriteResponse;
import com.inuker.bluetooth.library.Constants;

import java.util.concurrent.LinkedBlockingQueue;

public class MessageHelper {
    private static final String TAG = "MessageHelper";

    private final LinkedBlockingQueue<Message> linkedBlockingQueue = new LinkedBlockingQueue<Message>();
    private ProcessThread processThread;
    private final Handler handler = new Handler(Looper.getMainLooper());

    public void putMessage(Message message) {
        if (message == null) {
            return;
        }
        try {
            linkedBlockingQueue.add(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Message takeTopMessage() {
        Message message = null;
        try {
            message = linkedBlockingQueue.take();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return message;
    }

    public void open() {
        synchronized (this) {
            if (processThread == null) {
                processThread = new ProcessThread(this);
                processThread.threadOperation(BaseThread.OPENTHREAD);
            }
        }
    }

    public void close() {
        synchronized (this) {
            if (processThread != null) {
                processThread.threadOperation(BaseThread.CLOSETHREAD);
                processThread = null;
            }
        }
        handler.removeCallbacksAndMessages(null);
    }

    public class ProcessThread extends BaseThread {

        private final MessageHelper messageHelper;

        public ProcessThread(MessageHelper messageHelper) {
            super(Process.THREAD_PRIORITY_BACKGROUND, 10);
            this.setName("ProcessThread");
            if (messageHelper == null) {
                throw new NullPointerException("messageHelper is null");
            } else {
                this.messageHelper = messageHelper;
            }
        }

        @Override
        public void doWork() {
            final Message message = messageHelper.takeTopMessage();
            try {
                Thread.sleep(message.getDelay());
                Log.d(TAG, "sendMessage:" + message.getBytes().toString());
                BluetoothClient bluetoothClient = message.getBluetoothClient();
                bluetoothClient.write(message.getMac(), message.getServiceUUID(), message.getCharUUID(), message.getBytes(), new BleWriteResponse() {
                    @Override
                    public void onResponse(int code) {
                        postStatus(code, message.getOnSendMessageListener());
                    }
                });
            } catch (Exception e) {
                postStatus(Constants.REQUEST_FAILED, message.getOnSendMessageListener());
                e.printStackTrace();
            }

        }
    }

    private void postStatus(final int statusCode, final OnSendMessageListener onSendMessageListener) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                if (onSendMessageListener != null) {
                    onSendMessageListener.onSendStatus(statusCode);
                }
            }
        });
    }
}
