package com.ridesmart.ui;

import android.Manifest;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.os.Looper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.material.snackbar.Snackbar;
import com.ridesmart.R;
import com.ridesmart.databinding.FragmentEcoTrackerBinding;
import com.ridesmart.util.LocationUtils;

import dagger.hilt.android.AndroidEntryPoint;

/**
 * Fragment providing eco score feedback from live ride metrics.
 */
@AndroidEntryPoint
public class EcoTrackerFragment extends Fragment {

    private FragmentEcoTrackerBinding binding;
    private EcoTrackerViewModel viewModel;
    private FusedLocationProviderClient locationClient;
    private Location lastLocation;
    private final LocationCallback callback = new LocationCallback() {
        @Override
        public void onLocationResult(@NonNull LocationResult locationResult) {
            Location location = LocationUtils.extractBestLocation(locationResult);
            if (location == null) {
                return;
            }
            float acceleration = 0f;
            if (lastLocation != null) {
                float speedDiff = location.getSpeed() - lastLocation.getSpeed();
                float time = (location.getTime() - lastLocation.getTime()) / 1000f;
                if (time > 0) {
                    acceleration = Math.abs(speedDiff / time);
                }
            }
            lastLocation = location;
            viewModel.onLocationUpdate(location, acceleration);
        }
    };

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = FragmentEcoTrackerBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        viewModel = new ViewModelProvider(this).get(EcoTrackerViewModel.class);
        locationClient = LocationServices.getFusedLocationProviderClient(requireContext());

        binding.startRide.setOnClickListener(v -> {
            if (!hasLocationPermission()) {
                Snackbar.make(binding.getRoot(), R.string.permission_denied, Snackbar.LENGTH_SHORT).show();
                return;
            }
            lastLocation = null;
            viewModel.startRide();
            startLocationUpdates();
        });

        binding.stopRide.setOnClickListener(v -> {
            viewModel.stopRide();
            stopLocationUpdates();
        });

        viewModel.getEcoScore().observe(getViewLifecycleOwner(), score -> {
            if (score == null) {
                return;
            }
            binding.ecoProgress.setProgressCompat(score, true);
            binding.ecoScoreValue.setText(getString(R.string.eco_score_progress, score));
        });

        viewModel.getDistance().observe(getViewLifecycleOwner(), distance -> {
            if (distance == null) {
                return;
            }
            binding.distanceView.setText(getString(R.string.distance_format, distance));
        });

        viewModel.getSpeed().observe(getViewLifecycleOwner(), speed -> {
            if (speed == null) {
                return;
            }
            binding.speedView.setText(getString(R.string.speed_format, speed));
        });
    }

    private boolean hasLocationPermission() {
        return ContextCompat.checkSelfPermission(requireContext(), Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    private void startLocationUpdates() {
        LocationRequest request = LocationRequest.create();
        request.setInterval(3000);
        request.setFastestInterval(2000);
        request.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        locationClient.requestLocationUpdates(request, callback, Looper.getMainLooper());
    }

    private void stopLocationUpdates() {
        locationClient.removeLocationUpdates(callback);
    }

    @Override
    public void onStop() {
        super.onStop();
        stopLocationUpdates();
    }
}
