package com.ridesmart.repository;

import com.ridesmart.model.Hazard;

import java.util.List;

import javax.inject.Inject;
import javax.inject.Singleton;

/**
 * Repository coordinating pending sync uploads when connectivity returns.
 */
@Singleton
public class SyncRepository {

    private final HazardRepository hazardRepository;

    @Inject
    public SyncRepository(HazardRepository hazardRepository) {
        this.hazardRepository = hazardRepository;
    }

    public int syncHazards() {
        List<Hazard> pending = hazardRepository.getPendingHazards();
        for (Hazard hazard : pending) {
            hazardRepository.pushHazard(hazard);
        }
        return pending.size();
    }
}
