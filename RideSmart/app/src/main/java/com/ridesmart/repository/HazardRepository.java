package com.ridesmart.repository;

import androidx.annotation.NonNull;
import androidx.lifecycle.LiveData;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.ridesmart.data.HazardDao;
import com.ridesmart.model.Hazard;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.inject.Inject;
import javax.inject.Singleton;

/**
 * Repository bridging hazard operations between Room and Firebase.
 */
@Singleton
public class HazardRepository {

    private final HazardDao hazardDao;
    private final FirebaseDatabase database;
    private final ExecutorService executor = Executors.newSingleThreadExecutor();
    private final DatabaseReference hazardsRef;

    @Inject
    public HazardRepository(HazardDao hazardDao, FirebaseDatabase database) {
        this.hazardDao = hazardDao;
        this.database = database;
        this.hazardsRef = database.getReference("hazards");
        listenForRemoteChanges();
    }

    public LiveData<List<Hazard>> observeHazards() {
        return hazardDao.loadAll();
    }

    private void listenForRemoteChanges() {
        hazardsRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                executor.execute(() -> {
                    for (DataSnapshot child : snapshot.getChildren()) {
                        Hazard hazard = child.getValue(Hazard.class);
                        if (hazard == null) {
                            continue;
                        }
                        hazard.id = child.getKey();
                        hazard.synced = true;
                        hazardDao.insert(hazard);
                    }
                });
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {
            }
        });
    }

    public void cacheHazards(List<Hazard> hazards) {
        executor.execute(() -> {
            for (Hazard hazard : hazards) {
                hazardDao.insert(hazard);
            }
        });
    }

    public void createHazard(String title, String description, double lat, double lng, String userId) {
        executor.execute(() -> {
            Hazard hazard = new Hazard();
            hazard.id = UUID.randomUUID().toString();
            hazard.title = title;
            hazard.description = description;
            hazard.lat = lat;
            hazard.lng = lng;
            hazard.userId = userId;
            hazard.synced = false;
            hazardDao.insert(hazard);
            pushHazard(hazard);
        });
    }

    public void pushHazard(Hazard hazard) {
        DatabaseReference ref = hazardsRef.child(hazard.id);
        Map<String, Object> payload = new HashMap<>();
        payload.put("title", hazard.title);
        payload.put("description", hazard.description);
        payload.put("lat", hazard.lat);
        payload.put("lng", hazard.lng);
        payload.put("userId", hazard.userId);
        ref.setValue(payload).addOnSuccessListener(unused -> executor.execute(() -> {
            hazard.synced = true;
            hazardDao.update(hazard);
        }));
    }

    public List<Hazard> getPendingHazards() {
        return hazardDao.loadPending();
    }
}
