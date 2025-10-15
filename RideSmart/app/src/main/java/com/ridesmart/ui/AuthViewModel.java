package com.ridesmart.ui;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;

/**
 * ViewModel that encapsulates Firebase authentication and onboarding profile storage.
 */
@HiltViewModel
public class AuthViewModel extends ViewModel {

    private final FirebaseAuth auth;
    private final FirebaseFirestore firestore;
    private final MutableLiveData<Boolean> authResult = new MutableLiveData<>();
    private final MutableLiveData<String> error = new MutableLiveData<>();

    @Inject
    public AuthViewModel(FirebaseAuth auth, FirebaseFirestore firestore) {
        this.auth = auth;
        this.firestore = firestore;
    }

    public LiveData<Boolean> getAuthResult() {
        return authResult;
    }

    public LiveData<String> getError() {
        return error;
    }

    public void login(String email, String password) {
        auth.signInWithEmailAndPassword(email, password).addOnSuccessListener(result -> authResult.postValue(true)).addOnFailureListener(e -> error.postValue(e.getMessage()));
    }

    public void register(String email, String password) {
        auth.createUserWithEmailAndPassword(email, password).addOnSuccessListener(result -> authResult.postValue(true)).addOnFailureListener(e -> error.postValue(e.getMessage()));
    }

    public void saveProfile(String name, String phone) {
        FirebaseUser user = auth.getCurrentUser();
        if (user == null) {
            return;
        }
        Map<String, Object> payload = new HashMap<>();
        payload.put("name", name);
        payload.put("phone", phone);
        firestore.collection("users").document(user.getUid()).set(payload);
    }

    public boolean isLoggedIn() {
        return auth.getCurrentUser() != null;
    }
}
