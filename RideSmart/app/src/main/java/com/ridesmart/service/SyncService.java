package com.ridesmart.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;

import com.ridesmart.work.HazardSyncWorker;

/**
 * Triggers WorkManager uploads when the app regains connectivity.
 */
public class SyncService extends Service {

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        OneTimeWorkRequest request = new OneTimeWorkRequest.Builder(HazardSyncWorker.class).build();
        WorkManager.getInstance(this).enqueue(request);
        stopSelf();
        return START_NOT_STICKY;
    }
}
