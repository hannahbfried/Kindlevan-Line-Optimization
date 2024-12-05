function T = arrival_dist(duration,peak1,peak2,multi)
duration = 50; % How long the simulation runs for

% Not that you understand this, but just ensuring the time axis is broken
% up into seconds
edges = zeros(1,duration);
for i=1:duration
    edges(i) = i-1;
end

h = normrnd(duration/2,duration/7.2,100000,1); 
% Default is a normal distribution of arrivals, peaking at t = 1/2 the
% total duration time

[counts,edges] = histcounts(h,edges);
scaling = max(counts);
probabilities = counts/scaling; % Creates a probability distribution based 
% where it is basically guaranteed people arrive in the center of the
% timespan

T = zeros(1,duration-1);
% Now we generate matrix T used in queueing.m (each index is a second in
% time; a 1 indicates that someone arrived in that second and a 0 indicates
% that noone arrived in that second)
for i=1:(duration-1)
    random = rand(1);
    if random < probabilities(i)
        T(i) = 1;
    else
        T(i) = 0;
    end
end
