package com.ridesmart.data;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import com.ridesmart.model.Ride;

import java.util.List;

/**
 * DAO exposing ride persistence queries.
 */
@Dao
public interface RideDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    long insert(Ride ride);

    @Query("SELECT * FROM rides ORDER BY id DESC LIMIT 20")
    LiveData<List<Ride>> loadRecent();
}
