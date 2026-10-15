package com.bluebridge.utils;

import android.os.Process;

public class BaseThread extends Thread {
    public static final int OPENTHREAD = 1;
    public static final int CLOSETHREADBYWAIT = 2;
    public static final int CLOSETHREAD = 3;


    private final int priority;
    private final int threadCycleSleepTime;

    private boolean isOpenThread = false;
    private boolean canRunThread = true;
    private boolean isRunningThread = false;

    public BaseThread() {
        priority = Process.THREAD_PRIORITY_BACKGROUND;
        threadCycleSleepTime = 10;
    }

    public BaseThread(int threadCycleSleepTime) {
        priority = Process.THREAD_PRIORITY_BACKGROUND;
        if (threadCycleSleepTime <= 0) {
            threadCycleSleepTime = 10;
        }
        this.threadCycleSleepTime = threadCycleSleepTime;
    }

    public BaseThread(int priority, int threadCycleSleepTime) {
        this.priority = priority;
        if (threadCycleSleepTime <= 0) {
            threadCycleSleepTime = 0;
        }
        this.threadCycleSleepTime = threadCycleSleepTime;
    }

    @Override
    public void run() {
        Process.setThreadPriority(priority);
        int i = 0;
        while (canRunThread) {
            if (threadCycleSleepTime == 0) {
                catchUnknownErrorWhenDoWork();
            } else {
                try {
                    Thread.sleep(10);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                i = i + 10;
                if (i >= threadCycleSleepTime) {
                    catchUnknownErrorWhenDoWork();
                    i = 0;
                }
            }
        }
        isRunningThread = false;
    }

    public synchronized void threadOperation(int type) {
        if (type == OPENTHREAD) {
            openThread();
        } else if (type == CLOSETHREADBYWAIT) {
            closeThreadByWait();
        } else if (type == CLOSETHREAD) {
            closeThread();
        }
    }

    private void openThread() {
        if (!isOpenThread) {
            canRunThread = true;
            start();
            isOpenThread = true;
        }
    }

    private void closeThreadByWait() {
        if (isOpenThread) {
            canRunThread = false;
            while (isRunningThread) {
                try {
                    Thread.sleep(2);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            isOpenThread = false;
        }
    }

    private void closeThread() {
        if (isOpenThread) {
            canRunThread = false;
            isOpenThread = false;
        }
    }

    private void catchUnknownErrorWhenDoWork() {
        try {
            doWork();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void doWork() {

    }

}
