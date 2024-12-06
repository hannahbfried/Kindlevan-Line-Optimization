function [wait_times] = build_queue_and_calculate_wait_times(customer_matrix)
% Inputs:
%       customer_matrix: customer matrix built via build_customer_matrix
%
% Outputs:
%       wait_times: vector holding the wait times for all customers in
%       our simulation

% STEP 1: Build total order time
total_food_order_time = customer_matrix(:, 1);
meal_swipe = customer_matrix(:, 3);
verbal_item_request = customer_matrix(:, 4);

num_customers = size(customer_matrix, 1);

total_order_time = zeros(1, num_customers);
for i = 1:num_customers
    food_order_time = total_food_order_time(i);
    % we can change these!!
    if meal_swipe(i)
        pay_time = 2;
    else
        pay_time = 6;
    end
    verbal_request_time = 5*verbal_item_request(i);
    
    total_order_time(i) = food_order_time + pay_time + verbal_request_time;
end

% STEP 2: Calculate total wait times
arrival_time = customer_matrix(:, 5);

% placeholder return value
wait_times = [4, 5, 6];
