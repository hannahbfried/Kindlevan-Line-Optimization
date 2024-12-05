% Inputs:
%
%       n = # of customers over a time period
%       m = probability people pay via meal swipe
%       v = probability people verbally request items
%
% Output:  
%
%       Matrix C that represents the customer basis
%
% **One thing to note is that technically the same random p matrix could be 
% used throughout, but each event is independent, so I didn't want there to
% be any relationship between them, however marginal, so I generated a
% different random matrix for the construction of each column.**

n = 50;
C = zeros(n,5);

% C's first column depends on its second column, so I will fix the second
% one first

% The second column of C will indicate the number of items contained in the
% order. 

% There is an expected value of 2 items per order.
    % Probability of 1 item = 0.30
    a = 0.30;
    % Probability of 2 items = 0.50
    b = 0.50;
    % Probability of 3 items = 0.15
    c = 0.15;
    % Probability of 4 items = 0.05
    d = 0.05;
    % Probability of 5+ items = ~0

p = rand(1,n);
for i=1:n
    if p(i) < a
        C(i,2) = 1;
    elseif p(i) < a+b
        C(i,2) = 2;
    elseif p(i) < a+b+c
        C(i,2) = 3;
    else % We assume each person will order at most 4 items
        C(i,2) = 4; 
    end
end

% The first column of C will be the time (s) that it takes to order the given 
% customer’s order combination in isolation (not considering payment methods, 
% whether they have to verbally request the items, etc.)

% The size of the order (# of items) is approximately proportional to the
% time it takes to fulfill the order. There is a small amount of variation
% due to some items having bar codes and others not, which is accounted for
% via the random number generator. 

q = rand(1,n); 
q = 1+q/4; % There will be a time variation of 0% - 25% between orders of the same size

for i=1:n
   C(i,1) = 5*C(i,2)*q(i); % A generic item takes about 5 seconds to order; q accounts for variation
end


% The third column contains a binary indication of how the order will be
% paid for:
    % 0 = meal swipe
    % 1 = anything else
% Assume people pay via meal swipe with probability m
m = 0.75;

r = rand(1,n);
for i=1:n
    if r(i) < m
        C(i,3) = 0;
    else
        C(i,3) = 1;
    end
end

% The fourth column contains a binary indication of whether the order
% contains an item that needs to be verbally requested:
    % 0 = no
    % 1 = yes
% Assume people verbally request items with a probability v
v = 0.33;

s = rand(1,n);
for i=1:n
    if s(i) < 1-v
        C(i,4) = 0;
    else
        C(i,4) = 1;
    end
end

% The fifth column includes the time at which that given customer arrives.

duration = 7; % Indicates the number of seconds the simulation runs for
T = zeros(duration);
T = [0; 1; 3; 7; 3; 1; 0]; % Value of row m is the number of customers who 
                           % arrive at time t = m (**this is a dummy matrix,
                           % in theory it would be a more thought-out
                           % matrix based on real probabilities, but I'll
                           % get back to that in a little bit**)

i = 1;
for t = 1:duration
    if T(t) ~= 0
        C(i:(i+T(t)-1),5) = t;
    end
    i = i + T(t);
end