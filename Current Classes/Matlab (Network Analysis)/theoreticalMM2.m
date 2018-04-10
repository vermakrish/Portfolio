%{
Jonathan Kosir
M/M/2/K With variable prob of server choice
ECE 461

Theoretical Analysis Function
This is a theoretical calculation function which is used in my MM2 simulation
It calculates the theoretical values for the server system which is being
simulated, so a comparison can be made.
%}
function output = theoreticalMM2(lambda, mu, queue, servers)
% lambda = lambda (arrival speed) of system being analyzed
% mu     = mu (departure speed) of the system being analayzed
% queue  = queue size (how many packets can be in line)
% servers= number of servers in the system
% output =  the matrix which hold all the calculated values

% Variables
q = queue;
ro = lambda/mu;
s = servers;

% Prob of no costumers in system (First Summation)
firstSum = 0;
for i = 0:(s)
    firstSum = firstSum + ((ro^i)/factorial(i));
end

% Prob of no costumers in system (Second Summation)
secondSum = 0;
for j = (s+1):q
    secondSum = secondSum + (ro)^(j-s);
end

% Prob of no costumers in system
P0 = (firstSum + (((ro^s)/factorial(s))*secondSum))^(-1);

% Probability of n number of users in system (first 2 values of n)
Pn(1) = (ro/(factorial(s)*(s^(1-s))))*P0;
Pn(2) = ((ro^2)/(factorial(s)*(s^(2-s))))*P0;

% Probability of n number of users in system (rest of n)
for i = 2:(q)
    Pn(i) = (((ro)^i)/(factorial(s)*s^(i-s)))*P0;
end

% Average number in queue
psi = ro/s;
Lq = (P0*(ro)^s*(psi))/(factorial(s)*(1-(psi))^2)*(1-((psi)^(q-s))-((q-s)*(psi^(q-s))*(1-(psi))));

% Average number in entire system
L = (Lq+((lambda*(1-Pn(q)))/mu));

% Average time spent in queue
Wq = Lq/(lambda*(1-Pn(q)));

% Average time spent in system
W = Wq + 1/mu;

% Utilization Rates
U = (L-Lq)/s;

% Blocking Probability 
pb = Pn(q);

% Output matrix
output = [Wq, W, Lq, L, U, P0, ro, pb];
end

