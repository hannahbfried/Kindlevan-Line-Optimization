function [line_1_wait_times, line_2_wait_times, num_people_exited_line_1, num_people_exited_line_2, max_length_line_1, max_length_line_2] = build_queues_and_calculate_wait_times(customer_matrix, scenario_type, arrival_distribution)

% NOTE: I found that people were getting stuck in the line indefinitely :)
% We should chat about how we want to fix this, but I did sanity check that
% shrinking the total_order_time vector fixes things
% For now, I changed build_arrival_distribution s.t. fewer people show up
% (which is probably the more realistic option anyway)

% Inputs:
%       customer_matrix: customer matrix built via build_customer_matrix
%
% Outputs:
%       wait_times: vector holding the wait times for all customers in
%       our simulation

% STEP 1: Build total order time
total_food_order_time = customer_matrix(:, 1);
num_items = customer_matrix(:, 2);
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

% STEP 2: Calculate total wait times for different scenarios
% REMEMBER: there could be no line when a customer arrives

arrival_time = customer_matrix(:, 5);

% to return
line_1_wait_times = [];
line_2_wait_times = [];

% to keep track of in loop
customer_number = 0;

line_1_order_times = [];
line_2_order_times = [];

line_1_customer_numbers = [];
line_2_customer_numbers = [];

line_1_prev_exit_time = 0;
line_2_prev_exit_time = 0;

num_people_exited_line_1 = 0;
num_people_exited_line_2 = 0;

max_length_line_1 = 0;
max_length_line_2 = 0;

for time = 1:length(arrival_distribution)
    did_customer_arrive = arrival_distribution(time);
    if did_customer_arrive
        customer_number = customer_number + 1;
        % *** for testing
        if time < 1000
            disp(join(["customer arrived at time", time, "with order time", total_order_time(customer_number)]))
        end
        % *** for testing

        switch scenario_type
            case "Base Two Line"
                % if a customer has arrived, they will enter the shorter line
                if length(line_1_order_times) < length(line_2_order_times)
                    line_1_order_times = [line_1_order_times total_order_time(customer_number)];
                    line_1_customer_numbers = [line_1_customer_numbers customer_number]; % WOULD THIS NOT JUST BE INTEGERS 1, 2, ... 
                else
                    line_2_order_times = [line_2_order_times total_order_time(customer_number)];
                    line_2_customer_numbers = [line_2_customer_numbers customer_number];
                end
            case "Express Line"
                % Line 1 is the express line for 1 item
                if num_items(customer_number) == 1
                    line_1_order_times = [line_1_order_times total_order_time(customer_number)];
                    line_1_customer_numbers = [line_1_customer_numbers customer_number]; 
                else
                    line_2_order_times = [line_2_order_times total_order_time(customer_number)];
                    line_2_customer_numbers = [line_2_customer_numbers customer_number];
                end 
            case "Meal Swipe Line"    
                % Line 1 is the non meal swipe line
                if meal_swipe(customer_number)
                    line_1_order_times = [line_1_order_times total_order_time(customer_number)];
                    line_1_customer_numbers = [line_1_customer_numbers customer_number]; 
                else
                    line_2_order_times = [line_2_order_times total_order_time(customer_number)];
                    line_2_customer_numbers = [line_2_customer_numbers customer_number];
                end
            case "Verbal Request Line"
                % Line 1 is the non verbal request line
                if verbal_item_request(customer_number)
                    line_1_order_times = [line_1_order_times total_order_time(customer_number)];
                    line_1_customer_numbers = [line_1_customer_numbers customer_number]; 
                else
                    line_2_order_times = [line_2_order_times total_order_time(customer_number)];
                    line_2_customer_numbers = [line_2_customer_numbers customer_number];
                end 
            otherwise
                "Please enter a valid scenario type!";
        end
   end

   if line_1_order_times
        if length(line_1_order_times) > max_length_line_1
            max_length_line_1 = length(line_1_order_times);
        end

        line_1_head_customer_number = line_1_customer_numbers(1); 
        line_1_head_arrival_time = arrival_time(line_1_head_customer_number);
        line_1_head_order_time = line_1_order_times(1);

        if line_1_head_arrival_time < line_1_prev_exit_time
            % wait until person ahead finishes, then place order
            line_1_head_exit_time = line_1_prev_exit_time + line_1_head_order_time;
        else
            % arrived with no line
            line_1_head_exit_time = line_1_head_arrival_time + line_1_head_order_time;
        end

        if time >= line_1_head_exit_time
            % advance line
            line_1_order_times(1) = [];
            line_1_customer_numbers(1) = [];
            line_1_prev_exit_time = line_1_head_exit_time;
            % calculate wait time - round numbers that are nearly 0 to zero
            line_1_head_wait_time = round(line_1_head_exit_time - line_1_head_arrival_time  - line_1_head_order_time, 10);
            line_1_wait_times = [line_1_wait_times line_1_head_wait_time];
            disp(join(["exiting line 1 with wait time", line_1_head_wait_time]))
            num_people_exited_line_1 = num_people_exited_line_1 + 1;
        end
    end

    if line_2_order_times
        if length(line_2_order_times) > max_length_line_2
            max_length_line_2 = length(line_2_order_times);
        end

        line_2_head_customer_number = line_2_customer_numbers(1);
        line_2_head_arrival_time = arrival_time(line_2_head_customer_number);
        line_2_head_order_time = line_2_order_times(1);

        if line_2_head_arrival_time < line_2_prev_exit_time
            % wait until person ahead finishes, then place order
            line_2_head_exit_time = line_2_prev_exit_time + line_2_head_order_time;
        else
            % arrived with no line
            line_2_head_exit_time = line_2_head_arrival_time + line_2_head_order_time;
        end

        if time >= line_2_head_exit_time
            % advance line
            line_2_order_times(1) = [];
            line_2_customer_numbers(1) = [];
            line_2_prev_exit_time = line_2_head_exit_time;
            % calculate wait time - round numbers that are nearly 0 to zero
            line_2_head_wait_time = round(line_2_head_exit_time - line_2_head_arrival_time  - line_2_head_order_time, 10);
            line_2_wait_times = [line_2_wait_times line_2_head_wait_time];
            disp(join(["exiting line 2 with wait time", line_2_head_wait_time]))
            num_people_exited_line_2 = num_people_exited_line_2 + 1;
        end
    end

    % *** for testing
    % NOTE: we are only looking here at integer second values, but order
    % times are non-integer values, so remember that if sanity-checking
    % output (i.e. if the exit time looks off slightly, it's probably
    % because people before them exited at non-integer times)

    if time < 1000
        disp(join(["at time t = ", time, "line 1 is", line_1_order_times]))
        disp(join(["at time t = ", time, "line 2 is", line_2_order_times]))
    end
    % *** for testing
    
end
