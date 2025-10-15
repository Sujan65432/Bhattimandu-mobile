package com.ridesmart.ui;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.widget.Toast;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.NavController;
import androidx.navigation.fragment.NavHostFragment;
import androidx.navigation.ui.NavigationUI;

import com.google.android.material.snackbar.Snackbar;
import com.ridesmart.R;
import com.ridesmart.databinding.ActivityMainBinding;
import com.ridesmart.service.CrashDetectionService;

import dagger.hilt.android.AndroidEntryPoint;

/**
 * Host activity wiring the navigation graph and runtime permissions.
 */
@AndroidEntryPoint
public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;
    private NavController navController;
    private MainViewModel viewModel;

    private final ActivityResultLauncher<String[]> permissionLauncher =
            registerForActivityResult(new ActivityResultContracts.RequestMultiplePermissions(), result -> {
                boolean granted = true;
                for (Boolean value : result.values()) {
                    granted = granted && Boolean.TRUE.equals(value);
                }
                if (!granted) {
                    Snackbar.make(binding.getRoot(), R.string.permission_denied, Snackbar.LENGTH_LONG).show();
                } else {
                    startCrashDetection();
                }
            });

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        setSupportActionBar(binding.toolbar);

        NavHostFragment host = (NavHostFragment) getSupportFragmentManager().findFragmentById(R.id.nav_host_fragment);
        if (host != null) {
            navController = host.getNavController();
            NavigationUI.setupWithNavController(binding.bottomNav, navController);
        }

        viewModel = new ViewModelProvider(this).get(MainViewModel.class);
        viewModel.getSyncResults().observe(this, count -> {
            if (count != null && count > 0) {
                Toast.makeText(this, getString(R.string.sync_toast, count), Toast.LENGTH_SHORT).show();
            }
        });
        viewModel.triggerManualSync();

        requestCriticalPermissions();
    }

    private void requestCriticalPermissions() {
        boolean sensorsGranted = ContextCompat.checkSelfPermission(this, Manifest.permission.BODY_SENSORS) == PackageManager.PERMISSION_GRANTED;
        boolean locationGranted = ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
        boolean smsGranted = ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED;
        if (sensorsGranted && locationGranted && smsGranted) {
            startCrashDetection();
        } else {
            permissionLauncher.launch(new String[]{
                    Manifest.permission.BODY_SENSORS,
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.SEND_SMS
            });
        }
    }

    private void startCrashDetection() {
        Intent intent = new Intent(this, CrashDetectionService.class);
        ContextCompat.startForegroundService(this, intent);
    }
}
