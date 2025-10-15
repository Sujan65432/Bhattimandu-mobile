package com.ridesmart.ui;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import com.google.firebase.auth.FirebaseAuth;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;

/**
 * ViewModel powering the settings screen toggles and actions.
 */
@HiltViewModel
public class SettingsViewModel extends ViewModel {

    private final MutableLiveData<Boolean> darkMode = new MutableLiveData<>(false);
    private final FirebaseAuth auth;

    @Inject
    public SettingsViewModel(FirebaseAuth auth) {
        this.auth = auth;
    }

    public LiveData<Boolean> isDarkMode() {
        return darkMode;
    }

    public void toggleDarkMode(boolean enabled) {
        darkMode.setValue(enabled);
    }

    public void logout() {
        auth.signOut();
    }
}
