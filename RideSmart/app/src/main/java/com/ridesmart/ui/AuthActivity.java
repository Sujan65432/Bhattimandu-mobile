package com.ridesmart.ui;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;

import com.ridesmart.R;
import com.ridesmart.databinding.ActivityAuthBinding;

import dagger.hilt.android.AndroidEntryPoint;

/**
 * Authentication gateway shown before entering the main navigation shell.
 */
@AndroidEntryPoint
public class AuthActivity extends AppCompatActivity {

    private ActivityAuthBinding binding;
    private AuthViewModel viewModel;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAuthBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        viewModel = new ViewModelProvider(this).get(AuthViewModel.class);

        if (viewModel.isLoggedIn()) {
            launchMain();
            return;
        }

        binding.loginButton.setOnClickListener(v -> viewModel.login(binding.emailInput.getText().toString(), binding.passwordInput.getText().toString()));
        binding.registerButton.setOnClickListener(v -> viewModel.register(binding.emailInput.getText().toString(), binding.passwordInput.getText().toString()));
        binding.saveProfileButton.setOnClickListener(v -> {
            viewModel.saveProfile(binding.nameInput.getText().toString(), binding.contactInput.getText().toString());
            Toast.makeText(this, R.string.profile_saved, Toast.LENGTH_SHORT).show();
            launchMain();
        });

        viewModel.getAuthResult().observe(this, success -> {
            if (Boolean.TRUE.equals(success)) {
                Toast.makeText(this, R.string.login_button, Toast.LENGTH_SHORT).show();
            }
        });

        viewModel.getError().observe(this, message -> {
            if (message != null) {
                Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void launchMain() {
        startActivity(new Intent(this, MainActivity.class));
        finish();
    }
}
