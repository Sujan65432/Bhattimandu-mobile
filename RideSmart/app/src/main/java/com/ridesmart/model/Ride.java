package com.ridesmart.model;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

/**
 * Room entity describing a locally persisted ride summary.
 */
@Entity(tableName = "rides")
public class Ride {

    @PrimaryKey(autoGenerate = true)
    public long id;

    @ColumnInfo(name = "start")
    public long start;

    @ColumnInfo(name = "end")
    public long end;

    @ColumnInfo(name = "distance")
    public double distance;

    @ColumnInfo(name = "ecoScore")
    public int ecoScore;
}
