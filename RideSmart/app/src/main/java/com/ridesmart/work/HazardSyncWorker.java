package com.ridesmart.work;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.hilt.work.HiltWorker;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import com.ridesmart.repository.SyncRepository;

import dagger.assisted.Assisted;
import dagger.assisted.AssistedFactory;
import dagger.assisted.AssistedInject;

/**
 * WorkManager task that uploads cached hazards once a connection is available.
 */
@HiltWorker
public class HazardSyncWorker extends Worker {

    private final SyncRepository syncRepository;

    @AssistedInject
    public HazardSyncWorker(@Assisted @NonNull Context context,
                             @Assisted @NonNull WorkerParameters workerParams,
                             SyncRepository syncRepository) {
        super(context, workerParams);
        this.syncRepository = syncRepository;
    }

    @NonNull
    @Override
    public Result doWork() {
        syncRepository.syncHazards();
        return Result.success();
    }

    @AssistedFactory
    public interface Factory {
        HazardSyncWorker create(@Assisted @NonNull Context context,
                                @Assisted @NonNull WorkerParameters params);
    }
}
