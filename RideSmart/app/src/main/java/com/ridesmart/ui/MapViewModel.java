package com.ridesmart.ui;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.ViewModel;

import com.ridesmart.model.Hazard;
import com.ridesmart.repository.HazardRepository;

import java.util.List;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;

/**
 * ViewModel exposing hazard list for the map screen.
 */
@HiltViewModel
public class MapViewModel extends ViewModel {

    private final HazardRepository hazardRepository;

    @Inject
    public MapViewModel(HazardRepository hazardRepository) {
        this.hazardRepository = hazardRepository;
    }

    public LiveData<List<Hazard>> getHazards() {
        return hazardRepository.observeHazards();
    }

    public void createHazard(String title, String description, double lat, double lng, String userId) {
        hazardRepository.createHazard(title, description, lat, lng, userId);
    }
}
