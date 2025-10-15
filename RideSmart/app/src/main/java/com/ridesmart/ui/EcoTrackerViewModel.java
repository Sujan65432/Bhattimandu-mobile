package com.ridesmart.ui;

import android.location.Location;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import com.ridesmart.model.Ride;
import com.ridesmart.repository.RideRepository;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;

/**
 * ViewModel backing the eco tracker ride session.
 */
@HiltViewModel
public class EcoTrackerViewModel extends ViewModel {

    private final RideRepository rideRepository;
    private final MutableLiveData<Integer> ecoScore = new MutableLiveData<>(100);
    private final MutableLiveData<Double> distance = new MutableLiveData<>(0.0);
    private final MutableLiveData<Float> speed = new MutableLiveData<>(0f);
    private long startTime;
    private boolean rideActive = false;
    private Location lastLocation;
    private final List<Float> accelerations = new ArrayList<>();
    private final List<Float> speedSamples = new ArrayList<>();

    @Inject
    public EcoTrackerViewModel(RideRepository rideRepository) {
        this.rideRepository = rideRepository;
    }

    public LiveData<Integer> getEcoScore() {
        return ecoScore;
    }

    public LiveData<Double> getDistance() {
        return distance;
    }

    public LiveData<Float> getSpeed() {
        return speed;
    }

    public boolean isRideActive() {
        return rideActive;
    }

    public void startRide() {
        rideActive = true;
        startTime = System.currentTimeMillis();
        distance.setValue(0.0);
        accelerations.clear();
        speedSamples.clear();
    }

    public void stopRide() {
        if (!rideActive) {
            return;
        }
        rideActive = false;
        long end = System.currentTimeMillis();
        Ride ride = new Ride();
        ride.start = startTime;
        ride.end = end;
        ride.distance = distance.getValue() == null ? 0.0 : distance.getValue();
        ride.ecoScore = ecoScore.getValue() == null ? 0 : ecoScore.getValue();
        rideRepository.insertRide(ride);
    }

    public void onLocationUpdate(Location location, float acceleration) {
        if (!rideActive) {
            return;
        }
        if (lastLocation != null) {
            float delta = lastLocation.distanceTo(location);
            double total = distance.getValue() == null ? 0.0 : distance.getValue();
            total += delta / 1000.0;
            distance.postValue(total);
        }
        lastLocation = location;
        float speedMeters = location.getSpeed();
        speedSamples.add(speedMeters);
        float avgSpeed = computeAverage(speedSamples);
        speed.postValue(speedMeters * 3.6f);
        accelerations.add(acceleration);
        float avgAcceleration = computeAverage(accelerations);
        float speedDeviation = Math.abs(speedMeters - avgSpeed);
        int score = Math.max(0, 100 - Math.round(avgAcceleration * 3 + speedDeviation * 2));
        ecoScore.postValue(score);
    }

    private float computeAverage(List<Float> data) {
        if (data.isEmpty()) {
            return 0f;
        }
        float sum = 0f;
        for (Float value : data) {
            sum += value;
        }
        return sum / data.size();
    }
}
