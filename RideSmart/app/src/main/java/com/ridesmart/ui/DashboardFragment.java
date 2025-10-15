package com.ridesmart.ui;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.ridesmart.R;
import com.ridesmart.databinding.FragmentDashboardBinding;
import com.ridesmart.databinding.ItemRideBinding;
import com.ridesmart.model.Ride;

import java.util.ArrayList;
import java.util.List;

import dagger.hilt.android.AndroidEntryPoint;

/**
 * Dashboard showing recent rides stored locally.
 */
@AndroidEntryPoint
public class DashboardFragment extends Fragment {

    private FragmentDashboardBinding binding;
    private DashboardViewModel viewModel;
    private final RideAdapter adapter = new RideAdapter();

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = FragmentDashboardBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        viewModel = new ViewModelProvider(this).get(DashboardViewModel.class);
        binding.recentRidesList.setLayoutManager(new LinearLayoutManager(requireContext()));
        binding.recentRidesList.setAdapter(adapter);

        viewModel.getRides().observe(getViewLifecycleOwner(), rides -> {
            if (rides == null) {
                return;
            }
            adapter.submit(rides, viewModel);
            binding.ecoScoreSummary.setText(getString(R.string.eco_score_progress, viewModel.calculateAverageScore(rides)));
        });
    }

    private static class RideAdapter extends androidx.recyclerview.widget.RecyclerView.Adapter<RideViewHolder> {

        private final List<Ride> items = new ArrayList<>();
        private DashboardViewModel viewModel;

        void submit(List<Ride> rides, DashboardViewModel viewModel) {
            this.items.clear();
            this.items.addAll(rides);
            this.viewModel = viewModel;
            notifyDataSetChanged();
        }

        @NonNull
        @Override
        public RideViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            LayoutInflater inflater = LayoutInflater.from(parent.getContext());
            ItemRideBinding binding = ItemRideBinding.inflate(inflater, parent, false);
            return new RideViewHolder(binding);
        }

        @Override
        public void onBindViewHolder(@NonNull RideViewHolder holder, int position) {
            Ride ride = items.get(position);
            holder.binding.rideDuration.setText(viewModel.formatRide(ride));
            holder.binding.rideStats.setText(String.format("%.2f km", ride.distance));
        }

        @Override
        public int getItemCount() {
            return items.size();
        }
    }

    private static class RideViewHolder extends androidx.recyclerview.widget.RecyclerView.ViewHolder {

        final ItemRideBinding binding;

        RideViewHolder(ItemRideBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }
    }
}
