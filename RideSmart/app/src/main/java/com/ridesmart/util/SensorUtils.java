package com.ridesmart.util;

/**
 * Basic math helpers for sensor vector calculations.
 */
public final class SensorUtils {

    private SensorUtils() {
    }

    public static float magnitude(float x, float y, float z) {
        return (float) Math.sqrt(x * x + y * y + z * z);
    }
}
