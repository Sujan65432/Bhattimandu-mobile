package com.ridesmart.data;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import androidx.room.Update;

import com.ridesmart.model.Hazard;

import java.util.List;

/**
 * DAO for hazard map cache and sync state.
 */
@Dao
public interface HazardDao {

    @Query("SELECT * FROM hazards")
    LiveData<List<Hazard>> loadAll();

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void insert(Hazard hazard);

    @Update
    void update(Hazard hazard);

    @Query("SELECT * FROM hazards WHERE synced = 0")
    List<Hazard> loadPending();
}
