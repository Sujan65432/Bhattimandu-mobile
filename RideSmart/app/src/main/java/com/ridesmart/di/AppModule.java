package com.ridesmart.di;

import android.content.Context;

import androidx.room.Room;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.firestore.FirebaseFirestore;
import com.ridesmart.data.AppDatabase;
import com.ridesmart.data.HazardDao;
import com.ridesmart.data.RideDao;
import com.ridesmart.repository.HazardRepository;
import com.ridesmart.repository.RideRepository;
import com.ridesmart.repository.SyncRepository;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;
import dagger.hilt.InstallIn;
import dagger.hilt.android.qualifiers.ApplicationContext;
import dagger.hilt.components.SingletonComponent;

/**
 * Provides core singleton dependencies for the application graph.
 */
@Module
@InstallIn(SingletonComponent.class)
public class AppModule {

    @Provides
    @Singleton
    public AppDatabase provideDatabase(@ApplicationContext Context context) {
        return Room.databaseBuilder(context, AppDatabase.class, "ridesmart.db")
                .fallbackToDestructiveMigration()
                .build();
    }

    @Provides
    public RideDao provideRideDao(AppDatabase db) {
        return db.rideDao();
    }

    @Provides
    public HazardDao provideHazardDao(AppDatabase db) {
        return db.hazardDao();
    }

    @Provides
    @Singleton
    public FirebaseAuth provideAuth() {
        return FirebaseAuth.getInstance();
    }

    @Provides
    @Singleton
    public FirebaseDatabase provideRealtimeDb() {
        FirebaseDatabase database = FirebaseDatabase.getInstance();
        try {
            database.setPersistenceEnabled(true);
        } catch (RuntimeException ignored) {
        }
        return database;
    }

    @Provides
    @Singleton
    public FirebaseFirestore provideFirestore() {
        return FirebaseFirestore.getInstance();
    }

    @Provides
    @Singleton
    public RideRepository provideRideRepository(RideDao rideDao) {
        return new RideRepository(rideDao);
    }

    @Provides
    @Singleton
    public HazardRepository provideHazardRepository(HazardDao hazardDao, FirebaseDatabase database) {
        return new HazardRepository(hazardDao, database);
    }

    @Provides
    @Singleton
    public SyncRepository provideSyncRepository(HazardRepository hazardRepository) {
        return new SyncRepository(hazardRepository);
    }
}
