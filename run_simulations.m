% build_arrival_distribution params

% The different parameters for build_arrival_distribution will be in
% vectors, with each element corresponding to a different distribution. The
% distributions will be as follows: 

% [two moderately spaced peaks, two far apart peaks, two peaks of different
% sizes, one peak, flat distribution];

duration = [1800, 1800, 1800, 1800, 1800];
peak1 = [600, 200, 600, 900, 900];
peak2 = [1200, 1600, 1200, 0, 0];
peak1width = [7.2, 7.2, 10, 7.2, 1];
peak2width = [7.2, 7.2, 7.2, 0, 0];
multi = [1, 1, 1, 0, 0];

% build_customer_matrix params
m = 0.75;
v = 0.33;

scenario_types = ["Base Two Line", "Express Line", ...
                  "Meal Swipe Line", "Verbal Request Line"];

customer_matrix = build_customer_matrix(m, v, arrival_distribution);

for i = 1:length(scenario_types)
    arrival_distribution = build_arrival_distribution(duration(i), ...
        peak1(i), peak2(i), peak1width(i), peak2width(i), multi(i));
    [line_1_wait_times, line_2_wait_times] = build_queues_and_calculate_wait_times(customer_matrix, scenario_type(i), arrival_distribution);
    
    % TODO: Mercera to take these wait times and analyze/visualize
    % I think that we will want to run each simulation a bunch of times
    % (like maybe 100? idk) because there's a lot of variation

    % Would also be helpful to compute descriptive statistics
    % Do we wanna use CLT??? I think yes
end

