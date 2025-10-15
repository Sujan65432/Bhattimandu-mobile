package com.ridesmart.ui;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.ridesmart.databinding.ActivityCrashDetectedBinding;
import com.ridesmart.service.CrashDetectionService;

/**
 * Full screen alert providing a cancel option before emergency actions execute.
 */
public class CrashDetectedActivity extends AppCompatActivity {

    private ActivityCrashDetectedBinding binding;
    private CountDownTimer timer;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityCrashDetectedBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        timer = new CountDownTimer(30000, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                binding.timerView.setText(String.valueOf(millisUntilFinished / 1000));
            }

            @Override
            public void onFinish() {
                finish();
            }
        }.start();

        binding.cancelButton.setOnClickListener(v -> {
            sendBroadcast(new Intent(CrashDetectionService.ACTION_CANCEL));
            finish();
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (timer != null) {
            timer.cancel();
        }
    }
}
