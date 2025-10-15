package com.ridesmart.model;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

/**
 * Crash detection events stored for history and sync.
 */
@Entity(tableName = "crash_events")
public class CrashEvent {

    @PrimaryKey(autoGenerate = true)
    public long id;

    @ColumnInfo(name = "timestamp")
    public long timestamp;

    @ColumnInfo(name = "lat")
    public double lat;

    @ColumnInfo(name = "long")
    public double lon;

    @ColumnInfo(name = "confirmed")
    public boolean confirmed;
}
