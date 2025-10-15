package com.ridesmart.util;

import android.location.Location;

import com.google.android.gms.location.LocationResult;

import java.util.List;

/**
 * Helper calculations for location metrics used throughout the eco tracker.
 */
public final class LocationUtils {

    private LocationUtils() {
    }

    public static double metersToKm(double meters) {
        return meters / 1000.0;
    }

    public static float averageSpeed(List<Float> speeds) {
        if (speeds == null || speeds.isEmpty()) {
            return 0f;
        }
        float total = 0f;
        for (Float speed : speeds) {
            total += speed;
        }
        return total / speeds.size();
    }

    public static Location extractBestLocation(LocationResult result) {
        if (result == null) {
            return null;
        }
        List<Location> locations = result.getLocations();
        if (locations == null || locations.isEmpty()) {
            return null;
        }
        return locations.get(locations.size() - 1);
    }
}
