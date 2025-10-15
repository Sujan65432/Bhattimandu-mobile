package com.ridesmart.repository;

import androidx.lifecycle.LiveData;

import com.ridesmart.data.RideDao;
import com.ridesmart.model.Ride;

import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.inject.Inject;
import javax.inject.Singleton;

/**
 * Repository orchestrating ride persistence operations.
 */
@Singleton
public class RideRepository {

    private final RideDao rideDao;
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @Inject
    public RideRepository(RideDao rideDao) {
        this.rideDao = rideDao;
    }

    public LiveData<List<Ride>> getRecentRides() {
        return rideDao.loadRecent();
    }

    public void insertRide(final Ride ride) {
        executor.execute(() -> rideDao.insert(ride));
    }
}
