function [T] = arrival_distribution(duration,peak1,peak2,multi)

% Inputs:
%
%       duration = How long the simulation runs for (sec)
%         peak 1 = The time at which the first rush of students arrives
%         peak 2 = The time at which the second rush of students arrives
%          multi = How many peaks will be used:
%                   0 = just peak 1 (treated as a single binomial
%                   distribution)
%                   1 = both peaks 1 and 2 (treated as bimodal
%                   distribution)
% **Note that the input for peak2 is still required even when it is not
% being used. The value inputted does not impact the output, however.**
%
% Outputs:
%       Matrix T = A matrix whose index is the time (sec) and whose element is
%       whether a student arrives in that given time (there are two
%       options: 1 and 0, which indicate one student arriving and no
%       students arriving respectively) <-- this matrix T is an input
%       needed for queueing.m


% No need to understand this, but this is just ensuring the time frame is
% broken up into seconds

edges = 0:1:duration;

%% Generating peak 1
h1 = normrnd(peak1,duration/7.2,100000,1); 
% Default is a normal distribution of arrivals

indices = find((h1)>duration);
h1(indices) = [];

indices = find((h1)<0);
h1(indices) = [];

[counts1] = histcounts(h1,edges);

%% Generating peak 2
h2 = normrnd(peak2,duration/7.2,100000,1); 
% Default is a normal distribution of arrivals

indices = find((h2)>duration);
h2(indices) = [];

indices = find((h2)<0);
h2(indices) = [];

[counts2] = histcounts(h2,edges);

%% Generating Matrix T
if multi == 1
    counts = counts1 + counts2;
else
    counts = counts1;
end

scaling = max(counts);
probabilities = counts/scaling; % Creates a vector of the probabilities of 
% a student arriving in each second

T = zeros(1,duration);
% Now we generate matrix T used in queueing.m 
for i=1:(duration)
    random = rand(1);
    if random < probabilities(i)
        T(i) = 1;
    else
        T(i) = 0;
    end
end
