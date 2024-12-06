function [wait_times] = build_queue(duration, )
% Returns an array of wait times for all customers in our simulation

T = build_arrival_distribution(duration,peak1,peak2,peak1width,peak2width,multi);

% placeholder return value
wait_times = [];
