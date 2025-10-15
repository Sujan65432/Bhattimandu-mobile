package com.ridesmart.util;

import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;

import java.util.Locale;

/**
 * Provides utilities to switch between English and Nepali locales at runtime.
 */
public final class LanguageHelper {

    private LanguageHelper() {
    }

    public static void applyLocale(Context context, String languageTag) {
        Locale locale = Locale.forLanguageTag(languageTag);
        Locale.setDefault(locale);
        Resources resources = context.getResources();
        Configuration configuration = resources.getConfiguration();
        configuration.setLocale(locale);
        resources.updateConfiguration(configuration, resources.getDisplayMetrics());
    }
}
