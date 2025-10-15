package com.ridesmart.ui;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import com.ridesmart.repository.SyncRepository;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;

/**
 * ViewModel monitoring WorkManager sync outcomes.
 */
@HiltViewModel
public class MainViewModel extends ViewModel {

    private final SyncRepository syncRepository;
    private final MutableLiveData<Integer> syncResults = new MutableLiveData<>();
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @Inject
    public MainViewModel(SyncRepository syncRepository) {
        this.syncRepository = syncRepository;
    }

    public LiveData<Integer> getSyncResults() {
        return syncResults;
    }

    public void triggerManualSync() {
        executor.execute(() -> {
            int count = syncRepository.syncHazards();
            syncResults.postValue(count);
        });
    }
}
