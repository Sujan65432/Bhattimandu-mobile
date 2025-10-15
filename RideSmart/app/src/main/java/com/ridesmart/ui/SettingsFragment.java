package com.ridesmart.ui;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.google.android.material.snackbar.Snackbar;
import com.ridesmart.R;
import com.ridesmart.databinding.FragmentSettingsBinding;

import dagger.hilt.android.AndroidEntryPoint;

/**
 * Settings fragment supporting theme switching and logout.
 */
@AndroidEntryPoint
public class SettingsFragment extends Fragment {

    private FragmentSettingsBinding binding;
    private SettingsViewModel viewModel;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = FragmentSettingsBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        viewModel = new ViewModelProvider(this).get(SettingsViewModel.class);

        binding.darkModeSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> {
            viewModel.toggleDarkMode(isChecked);
            AppCompatDelegate.setDefaultNightMode(isChecked ? AppCompatDelegate.MODE_NIGHT_YES : AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
        });

        binding.logoutButton.setOnClickListener(v -> {
            viewModel.logout();
            Snackbar.make(binding.getRoot(), R.string.logout, Snackbar.LENGTH_SHORT).show();
        });

        viewModel.isDarkMode().observe(getViewLifecycleOwner(), enabled -> binding.darkModeSwitch.setChecked(Boolean.TRUE.equals(enabled)));
    }
}
