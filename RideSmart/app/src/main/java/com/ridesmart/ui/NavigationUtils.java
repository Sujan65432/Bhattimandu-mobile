package com.ridesmart.ui;

import android.view.MenuItem;

import androidx.annotation.NonNull;
import androidx.navigation.NavController;

/**
 * Small helper to navigate bottom navigation selections.
 */
public final class NavigationUtils {

    private NavigationUtils() {
    }

    public static boolean navigateTo(@NonNull MenuItem item, @NonNull NavController controller) {
        int destinationId = item.getItemId();
        if (controller.getCurrentDestination() != null && controller.getCurrentDestination().getId() == destinationId) {
            return true;
        }
        controller.navigate(destinationId);
        return true;
    }
}
