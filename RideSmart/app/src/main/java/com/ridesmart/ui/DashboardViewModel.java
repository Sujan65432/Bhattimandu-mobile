package com.ridesmart.ui;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.ViewModel;

import com.ridesmart.model.Ride;
import com.ridesmart.repository.RideRepository;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;

/**
 * ViewModel exposing summary cards for the dashboard screen.
 */
@HiltViewModel
public class DashboardViewModel extends ViewModel {

    private final RideRepository rideRepository;
    private final LiveData<List<Ride>> rides;

    @Inject
    public DashboardViewModel(RideRepository rideRepository) {
        this.rideRepository = rideRepository;
        this.rides = rideRepository.getRecentRides();
    }

    public LiveData<List<Ride>> getRides() {
        return rides;
    }

    public String formatRide(Ride ride) {
        DateFormat format = DateFormat.getDateTimeInstance();
        return format.format(new Date(ride.start)) + " - EcoScore " + ride.ecoScore;
    }

    public int calculateAverageScore(List<Ride> rideList) {
        if (rideList == null || rideList.isEmpty()) {
            return 0;
        }
        int total = 0;
        for (Ride ride : rideList) {
            total += ride.ecoScore;
        }
        return total / rideList.size();
    }
}
