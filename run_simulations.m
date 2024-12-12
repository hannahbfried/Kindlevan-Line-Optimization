% Here we will call build_queue (or whatever we end up calling it) for
% each of our simulations and output results

% We will have one row vector for parameter required for each scenario
% The length of these vectors is the total number of scenarios

% build_arrival_distribution params
duration = [1800];
peak1 = [600];
peak2 = [1200];
peak1width = [7.2];
peak2width = [7.2];
multi = [1];

% build_customer_matrix params
m = [0.75];
v = [0.33];

scenario_type = ["Base Two Line"];

% num_simulations is equal to the length of all above vectors, but
% we'll use duration to set it to make the code more readable
num_simulations = length(duration);

for i = 1:length(num_simulations)
    disp(["TEST, DURATION IS ", duration(i)]);
    arrival_distribution = build_arrival_distribution(duration(i), ...
        peak1(i), peak2(i), peak1width(i), peak2width(i), multi(i));
    customer_matrix = build_customer_matrix(m(i), v(i), arrival_distribution);
    [line_1_wait_times, line_2_wait_times] = build_queues_and_calculate_wait_times(customer_matrix, scenario_type(i), arrival_distribution);
    % TODO: Mercera to take these wait times and analyze/visualize
    % I think that we will want to run each simulation a bunch of times
    % (like maybe 100? idk) because there's a lot of variation

    % Would also be helpful to compute descriptive statistics
    % Do we wanna use CLT??? I think yes
end

