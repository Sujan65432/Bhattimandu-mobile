package com.ridesmart.data;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import com.ridesmart.model.CrashEvent;

import java.util.List;

/**
 * DAO for crash detection logs stored locally.
 */
@Dao
public interface CrashEventDao {

    @Insert
    long insert(CrashEvent event);

    @Update
    void update(CrashEvent event);

    @Query("SELECT * FROM crash_events ORDER BY id DESC LIMIT 50")
    List<CrashEvent> loadRecent();
}
