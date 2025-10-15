package com.ridesmart.service;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.telephony.SmsManager;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.ridesmart.R;
import com.ridesmart.data.CrashEventDao;
import com.ridesmart.model.CrashEvent;
import com.ridesmart.ui.CrashDetectedActivity;
import com.ridesmart.util.SensorUtils;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.inject.Inject;

import dagger.hilt.android.AndroidEntryPoint;

/**
 * Foreground service that monitors accelerometer/gyroscope readings to detect crashes.
 */
@AndroidEntryPoint
public class CrashDetectionService extends Service implements SensorEventListener {

    public static final String ACTION_CANCEL = "com.ridesmart.CANCEL_CRASH";
    private static final String CHANNEL_ID = "crash_channel";
    private static final float ACCELERATION_THRESHOLD = 25f;
    private static final long CRASH_WINDOW_MS = 300;

    private SensorManager sensorManager;
    private Sensor accelerometer;
    private Sensor gyroscope;
    private long thresholdStart = 0L;
    private boolean crashPending = false;
    private Handler handler;
    private Runnable smsRunnable;
    private FusedLocationProviderClient locationClient;
    private ExecutorService executor;
    private double pendingLat;
    private double pendingLon;
    private long pendingEventId;

    @Inject
    CrashEventDao crashEventDao;

    private final BroadcastReceiver cancelReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (crashPending) {
                crashPending = false;
                handler.removeCallbacks(smsRunnable);
                updateCrashConfirmation(false);
            }
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();
        handler = new Handler();
        executor = Executors.newSingleThreadExecutor();
        sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
        accelerometer = sensorManager != null ? sensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION) : null;
        gyroscope = sensorManager != null ? sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE) : null;
        locationClient = LocationServices.getFusedLocationProviderClient(this);
        registerReceiver(cancelReceiver, new IntentFilter(ACTION_CANCEL));
        startForeground(1, buildNotification());
        if (sensorManager != null && accelerometer != null) {
            sensorManager.registerListener(this, accelerometer, 100000);
        }
        if (sensorManager != null && gyroscope != null) {
            sensorManager.registerListener(this, gyroscope, 100000);
        }
    }

    private Notification buildNotification() {
        createChannel();
        Intent intent = new Intent(this, CrashDetectedActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_IMMUTABLE);
        return new NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_launcher_foreground)
                .setContentTitle(getString(R.string.crash_notification_title))
                .setContentText(getString(R.string.crash_notification_body))
                .setContentIntent(pendingIntent)
                .build();
    }

    private void createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "Crash detection", NotificationManager.IMPORTANCE_LOW);
            NotificationManager manager = getSystemService(NotificationManager.class);
            if (manager != null) {
                manager.createNotificationChannel(channel);
            }
        }
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (sensorManager != null) {
            sensorManager.unregisterListener(this);
        }
        unregisterReceiver(cancelReceiver);
        handler.removeCallbacksAndMessages(null);
        executor.shutdownNow();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        float magnitude = SensorUtils.magnitude(event.values[0], event.values[1], event.values[2]);
        if (magnitude > ACCELERATION_THRESHOLD) {
            if (thresholdStart == 0L) {
                thresholdStart = System.currentTimeMillis();
            } else if (!crashPending && System.currentTimeMillis() - thresholdStart > CRASH_WINDOW_MS) {
                triggerCrashFlow();
            }
        } else {
            thresholdStart = 0L;
        }
    }

    private void triggerCrashFlow() {
        crashPending = true;
        smsRunnable = this::sendEmergencySms;
        handler.postDelayed(smsRunnable, 30000);
        fetchLocation();
        Intent intent = new Intent(this, CrashDetectedActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
        pendingEventId = logCrash(false);
    }

    private void fetchLocation() {
        try {
            locationClient.getLastLocation().addOnSuccessListener(location -> {
                if (location != null) {
                    pendingLat = location.getLatitude();
                    pendingLon = location.getLongitude();
                }
            });
        } catch (SecurityException ignored) {
        }
    }

    private void sendEmergencySms() {
        crashPending = false;
        final double lat = pendingLat;
        final double lon = pendingLon;
        executor.execute(() -> {
            SmsManager smsManager = SmsManager.getDefault();
            String message = getString(R.string.emergency_sms_message, lat, lon);
            smsManager.sendTextMessage("+9770000000000", null, message, null, null);
            updateCrashConfirmation(true);
        });
    }

    private long logCrash(boolean confirmed) {
        CrashEvent event = new CrashEvent();
        event.timestamp = System.currentTimeMillis();
        event.lat = pendingLat;
        event.lon = pendingLon;
        event.confirmed = confirmed;
        return crashEventDao.insert(event);
    }

    private void updateCrashConfirmation(boolean confirmed) {
        executor.execute(() -> {
            CrashEvent event = new CrashEvent();
            event.id = pendingEventId;
            event.timestamp = System.currentTimeMillis();
            event.lat = pendingLat;
            event.lon = pendingLon;
            event.confirmed = confirmed;
            crashEventDao.update(event);
        });
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
}
