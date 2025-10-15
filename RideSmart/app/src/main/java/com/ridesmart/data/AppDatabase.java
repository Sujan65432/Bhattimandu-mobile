package com.ridesmart.data;

import androidx.room.Database;
import androidx.room.RoomDatabase;

import com.ridesmart.model.CrashEvent;
import com.ridesmart.model.Hazard;
import com.ridesmart.model.Ride;

/**
 * Central Room database storing rides, hazards, and crash logs.
 */
@Database(entities = {Ride.class, Hazard.class, CrashEvent.class}, version = 1)
public abstract class AppDatabase extends RoomDatabase {

    public abstract RideDao rideDao();

    public abstract HazardDao hazardDao();

    public abstract CrashEventDao crashEventDao();
}
