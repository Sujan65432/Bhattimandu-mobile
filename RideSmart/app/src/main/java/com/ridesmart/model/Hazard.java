package com.ridesmart.model;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

/**
 * Community hazard report entity persisted for offline sync.
 */
@Entity(tableName = "hazards")
public class Hazard {

    @PrimaryKey
    @NonNull
    public String id;

    @ColumnInfo(name = "title")
    public String title;

    @ColumnInfo(name = "description")
    public String description;

    @ColumnInfo(name = "lat")
    public double lat;

    @ColumnInfo(name = "lng")
    public double lng;

    @ColumnInfo(name = "userId")
    public String userId;

    @ColumnInfo(name = "synced")
    public boolean synced;

    public Hazard() {
        this.id = "";
    }
}
