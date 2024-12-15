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

scenario_type = ["Base Two Line", "Express Line", "Optional Meal Swipe Line", ...
                  "Meal Swipe Line", "Verbal Request Line"];

% all data will be a table of dimensions ixj
% every entry will house the relevant data for arrival distribution i and
% simulation type j

all_line_1_mean_data = {};
all_line_2_mean_data = {};

all_line_1_median_data = {};
all_line_2_median_data = {};

all_line_1_std_data = {};
all_line_2_std_data = {};

all_line_1_exit_data = {};
all_line_2_exit_data = {};

all_line_1_length_data = {};
all_line_2_length_data = {};

avg_num_customers_each_arrival_distribution = {};

% for every arrival distribution, run each scenario 100 times
num_arrival_distributions = length(duration);
for i = 1:num_arrival_distributions

    sum_arrival_distributions = [];

    disp(join(["sum of arrival distribution is ", sum(arrival_distribution), "for arrival dist ", i]))

    for j = 1:length(scenario_type)

        disp(join(["Scenario Type:", scenario_type(j), newline]))

        mean_line_1_wait_times_all_runs = [];
        mean_line_2_wait_times_all_runs = [];

        median_line_1_wait_times_all_runs = [];
        median_line_2_wait_times_all_runs = [];

        std_line_1_wait_times_all_runs = [];
        std_line_2_wait_times_all_runs = [];

        num_exited_line_1_all_runs = [];
        num_exited_line_2_all_runs = [];

        max_length_line_1_all_runs = [];
        max_length_line_2_all_runs = [];

        for k = 1:100

            arrival_distribution = build_arrival_distribution(duration(i), ...
            peak1(i), peak2(i), peak1width(i), peak2width(i), multi(i));

            sum_arrival_distributions = [sum_arrival_distributions sum(arrival_distribution)];

            customer_matrix = build_customer_matrix(m, v, arrival_distribution);

            [line_1_wait_times, line_2_wait_times, num_people_exited_line_1, num_people_exited_line_2, max_length_line_1, max_length_line_2] = build_queues_and_calculate_wait_times(customer_matrix, scenario_type(j), arrival_distribution);
            
            mean_line_1_wait_times_all_runs = [mean_line_1_wait_times_all_runs mean(line_1_wait_times)];
            mean_line_2_wait_times_all_runs = [mean_line_2_wait_times_all_runs mean(line_2_wait_times)];

            median_line_1_wait_times_all_runs = [median_line_1_wait_times_all_runs median(line_1_wait_times)];
            median_line_2_wait_times_all_runs = [median_line_2_wait_times_all_runs median(line_2_wait_times)];

            std_line_1_wait_times_all_runs = [std_line_1_wait_times_all_runs std(line_1_wait_times)];
            std_line_2_wait_times_all_runs = [std_line_2_wait_times_all_runs std(line_2_wait_times)];

            num_exited_line_1_all_runs = [num_exited_line_1_all_runs num_people_exited_line_1];
            num_exited_line_2_all_runs = [num_exited_line_2_all_runs num_people_exited_line_2];

            max_length_line_1_all_runs = [max_length_line_1_all_runs max_length_line_1];
            max_length_line_2_all_runs = [max_length_line_2_all_runs max_length_line_2];
       
        end

        all_line_1_mean_data{i, j} = mean_line_1_wait_times_all_runs;
        all_line_2_mean_data{i, j} = mean_line_2_wait_times_all_runs;

        all_line_1_median_data{i, j} = median_line_1_wait_times_all_runs;
        all_line_2_median_data{i, j} = median_line_2_wait_times_all_runs;

        all_line_1_std_data{i, j} = std_line_1_wait_times_all_runs;
        all_line_2_std_data{i, j} = std_line_2_wait_times_all_runs;

        all_line_1_exit_data{i, j} = num_exited_line_1_all_runs;
        all_line_2_exit_data{i, j} = num_exited_line_2_all_runs;

        all_line_1_length_data{i, j} = max_length_line_1_all_runs;
        all_line_2_length_data{i, j} = max_length_line_2_all_runs;

        avg_num_customers_each_arrival_distribution{1, i} = mean(sum_arrival_distributions);

    end
end