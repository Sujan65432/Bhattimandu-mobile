package com.ridesmart.ui;

import android.app.AlertDialog;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.ridesmart.R;
import com.ridesmart.model.Hazard;

import java.util.List;

import dagger.hilt.android.AndroidEntryPoint;

/**
 * Google Maps fragment allowing the community to report hazards.
 */
@AndroidEntryPoint
public class MapFragment extends Fragment implements OnMapReadyCallback {

    private MapViewModel viewModel;
    private GoogleMap map;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_map, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        viewModel = new ViewModelProvider(this).get(MapViewModel.class);
        SupportMapFragment mapFragment = (SupportMapFragment) getChildFragmentManager().findFragmentById(R.id.mapView);
        if (mapFragment != null) {
            mapFragment.getMapAsync(this);
        }
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        this.map = googleMap;
        LatLng kathmandu = new LatLng(27.7172, 85.3240);
        map.moveCamera(CameraUpdateFactory.newLatLngZoom(kathmandu, 12f));
        map.setOnMapLongClickListener(this::showHazardDialog);
        observeHazards();
    }

    private void observeHazards() {
        viewModel.getHazards().observe(getViewLifecycleOwner(), this::renderHazards);
    }

    private void renderHazards(List<Hazard> hazards) {
        if (map == null) {
            return;
        }
        map.clear();
        for (Hazard hazard : hazards) {
            LatLng position = new LatLng(hazard.lat, hazard.lng);
            map.addMarker(new MarkerOptions().position(position).title(hazard.title).snippet(hazard.description));
        }
    }

    private void showHazardDialog(LatLng latLng) {
        View dialogView = LayoutInflater.from(requireContext()).inflate(R.layout.dialog_hazard, null);
        EditText titleInput = dialogView.findViewById(R.id.hazardTitleInput);
        EditText descriptionInput = dialogView.findViewById(R.id.hazardDescriptionInput);
        new AlertDialog.Builder(requireContext())
                .setTitle(R.string.hazard_dialog_title)
                .setView(dialogView)
                .setPositiveButton(R.string.submit, (dialog, which) -> {
                    String title = titleInput.getText().toString();
                    String description = descriptionInput.getText().toString();
                    String uid = FirebaseAuth.getInstance().getCurrentUser() != null ? FirebaseAuth.getInstance().getCurrentUser().getUid() : "anonymous";
                    viewModel.createHazard(title, description, latLng.latitude, latLng.longitude, uid);
                })
                .setNegativeButton(android.R.string.cancel, null)
                .show();
    }
}
