%{
Jonathan Kosir
M/M/2/K With variable prob of server choice
ECE 461
------------------------------------------------------------------------
%}
clear all


% Variables
speed = 1000; %Speed up simulation (Can't go above 1000)
lambda = 8 * speed ;
mu = 5 * speed;
ro = lambda/mu;
numPackets = 1000000; %Num packets to be processed cant go above 10,000,000
numServers = 2;
serverProb = 5;
queueSize = 5;
dataStart = 1000;
timerVal = tic;
interval = 1/speed;
ticker = interval;
over = false;
P01 = 0;
P02 = 0;
P0 = 0;

blocked = zeros(1:numServers);
serversState = zeros(1:numServers);
queueCurrentSize = zeros(1 : numServers);
state = [6 0]; % [state serverNumber]
queue = zeros(numServers,queueSize);
packet = zeros(numPackets,4); % [Arrival processTime departure server]
processing = [0 0];
totalInQueue1 = 0;
totalInQueue2 = 0;
processing1 = 0;
processing2 = 0;

aveTimeInQueue1 = 0;
aveTimeInQueue2 = 0;
aveTimeProcessing1 = 0;
aveTimeProcessing2 = 0;
aveTimeInSystem1 = 0;
aveTimeInSystem2 = 0;

arrival = -log(rand)/lambda;
packet(1) = arrival;
for i = 2:numPackets
    arrival = -log(rand)./lambda;
    packet(i,1) = arrival + packet(i-1,1);
end

disp('Start Sim');
simEstimate = num2str(packet(length(packet),1) +  ...
    (exprnd(1/mu)*(queueSize/2)));
disp(['Sim will take about ', simEstimate, ' Seconds']);
test = 0;
test2 = 0;
i = 1;

% Loop until over is triggered to true (Runs through until all packets are
% serviced)
while over ~= true
    
    
    % If there are more packets to arrive
    if  numPackets >= i
        
        % It has arrived
        if((packet(i,1) <= toc(timerVal)))
            
            % Choose server to go to
            % Change state of server to arrival
            choice = randi(10);
            if choice <= serverProb
                state = [1 1];
                packet(i,4) = 1;
            else
                state = [1 2];
                packet(i,4) = 2;
            end
        end
    end
    
    % If the server 1 is not empty check if packet being serviced is done
    if(processing(1) ~= 0)
        if(packet(processing(1),3) <= toc(timerVal))
            state = [2 packet(processing(1),4)];
        end
    end
    
    % If the server 2 is not empty check if packet being serviced is done
    if processing(2) ~= 0
        if(packet(processing(2),3) <= toc(timerVal))
            state = [2 packet(processing(2),4)];
        end
    end
    
    
    
    % Arrivald
    % Queued ----
    % Process
    % Departure
    % Take from queue
    % Zero State
    % Processing
    % Queue
    % Depature state
    
    switch state(1)
        
        case 1 %Arrival
            processTime = exprnd(1/mu);
            
            % If server empty
            if serversState(state(2)) == 0
                packet(i,2) = packet(i,1);
                packet(i,3) = packet(i,2) + processTime;
                processing(state(2)) = i;
                serversState(state(2)) = 1;
                
                % If server busy
            else
                % If queue is full
                if queueCurrentSize(state(2)) >= queueSize
                    
                    if dataStart <= numPackets
                        blocked(state(2)) = blocked(state(2)) + 1;
                    end
                    
                    packet(i) = 0;
                    
                    % If Queue has room
                else
                    
                    if queueCurrentSize(state(2)) == 0
                        packet(i,2) = packet(processing(state(2)),3);
                        packet(i,3) = packet(i,2) + processTime;
                        
                    else
                        packet(i,2) = packet(queue(state(2),...
                            queueCurrentSize(state(2))),3);
                        packet(i,3) = packet(i,2) + processTime;
                    end
                    
                    queueCurrentSize(state(2)) = ...
                        queueCurrentSize(state(2)) + 1;
                    queue(state(2),queueCurrentSize(state(2))) = i;
                end
            end
            i = i + 1;
            state = [0 0];
            
            
        case 2  % Departure
            % If Queue isnt empty
            
            if queueCurrentSize(state(2)) ~= 0
                processing(state(2)) = queue(state(2),1);
                
                
                if queueCurrentSize(state(2)) == 1
                    queue(state(2)) = 0;
                    queueCurrentSize(state(2)) =...
                        queueCurrentSize(state(2)) - 1;
                else
                    queue(state(2),1:queueCurrentSize(state(2))) = ...
                        [queue(state(2),2:queueCurrentSize(state(2))) 0];
                    %queue(state(2),queueCurrentSize(state(2))) = 0;
                    queueCurrentSize(state(2)) = ...
                        queueCurrentSize(state(2)) - 1;
                end
                serversState(state(2)) = 1;
                % If current size is now zero set server state to idle
            else
                % If ouy of packets
                serversState(state(2)) = 0;
                processing(state(2)) = 0;
                if i >= numPackets
                    over = true;
                end
            end
            
            state = [0 0];
            
    end
    
    % Some simple data collection
    if((toc(timerVal) >= ticker) && i >= dataStart)
        ticker = interval + ticker;
        totalInQueue1 = queueCurrentSize(1) + totalInQueue1;
        totalInQueue2 = queueCurrentSize(2) + totalInQueue2;
        if (processing(1) ~= 0)
            processing1 = processing1 + 1;
        else
            test2 = test2 + 1;
        end
        if(processing(1) ~= 0)
            processing2 = processing2 + 1;
        else
            test = test + 1;
        end
        
        
        if (serversState(1) == 0)
            P01 = P01 + 1;
        end
        
        if serversState(2) == 0
            P02 = P02 + 1;
        end
        
        if (serversState(1) == 0) && serversState(2) == 0
            P0 = P0 + 1;
        end
        
    end
    
    
end

disp(['Actual Time: ', num2str(toc(timerVal)), ...
    ' Estimated Time: ', simEstimate])
disp('Starting Data Calculations');
packetsTo1 = sum(packet(dataStart:numPackets,4)==1);
packetsTo2 = sum(packet(dataStart:numPackets,4)==2);




%Fix make quicker
aveTimeInSystem = 0;
aveTimeInQueue = 0;
aveTimeProcessing = 0;

for i = dataStart:numPackets
    if packet(i,1) ~= 0
        if packet(i,4) == 1
            aveTimeInQueue1 = ((packet(i,2)*speed) - ...
                (packet(i,1) * speed)) + aveTimeInQueue1;
            aveTimeProcessing1 = ((packet(i,3)*speed) - ...
                (packet(i,2) * speed)) + aveTimeProcessing1;
            aveTimeInSystem1 = ((packet(i,3)*speed) - ...
                (packet(i,1) * speed)) + aveTimeInSystem1;
        end
        if packet(i,4) == 2
            aveTimeInQueue2 = ((packet(i,2)*speed) - ...
                (packet(i,1) * speed)) + aveTimeInQueue2;
            aveTimeProcessing2 = ((packet(i,3)*speed) - ...
                (packet(i,2) * speed)) + aveTimeProcessing2;
            aveTimeInSystem2 = ((packet(i,3) * speed )- ...
                (packet(i,1) * speed)) + aveTimeInSystem2;
        end
        aveTimeInQueue = ((packet(i,2)*speed) - ...
            (packet(i,1) * speed)) + aveTimeInQueue;
        aveTimeProcessing = ((packet(i,3)*speed) - ...
            (packet(i,2) * speed)) + aveTimeProcessing;
        aveTimeInSystem = ((packet(i,3)*speed) - ...
            (packet(i,1) * speed)) + aveTimeInSystem;
    end
end
samples = (toc(timerVal)-packet(dataStart,1))/interval;
P01 = P01/samples;
P02 = P02/samples;
P0 = P0/samples;
% Wait times for the two different queues (Queue, service and total time)
% This is the simulated data
aveTimeInQueue1 = (aveTimeInQueue1 / packetsTo1);
aveTimeInQueue2 = (aveTimeInQueue2 / packetsTo2);
aveTimeInSystem1 = (aveTimeInSystem1/packetsTo1);
aveTimeInSystem2 = (aveTimeInSystem2/packetsTo2);
aveTimeProcessing1 = (aveTimeProcessing1 / packetsTo1);
aveTimeProcessing2 = (aveTimeProcessing2 / packetsTo2);

% Entire system wait times (Queue, service and total time) simulated data
aveTimeInSystem = aveTimeInSystem/(numPackets-dataStart);
aveTimeInQueue = aveTimeInQueue/(numPackets-dataStart);
aveTimeProcessing = aveTimeProcessing/(numPackets-dataStart);

% Simulated blocking probabilities for server 1, 2, and total
blockingProbabilityTotal = sum(blocked)/(numPackets-dataStart);
blockingProb1 = blocked(1)/sum(packet(dataStart:numPackets,4)==1);
blockingProb2 = blocked(2)/sum(packet(dataStart:numPackets,4)==2);

% Simulated number averages for both servers individually (queue, service,
% and total
aveNumInQueue1 = (totalInQueue1 / samples);
aveNumInQueue2 =  (totalInQueue2 / samples);
aveInSystem1 = processing1/samples;
aveInSystem2 = processing2/samples;
aveNumTotal1 = aveNumInQueue1 + aveInSystem1;
aveNumTotal2 = aveNumInQueue2 + aveInSystem2;

% Entire systems average numbers
aveNumInQueue = (aveNumInQueue1 + aveNumInQueue2);
aveNumInSystem = (aveInSystem1 + aveInSystem2);
aveNumTotal = (aveNumInQueue + aveNumInSystem);

utilization = (aveNumTotal - aveNumInQueue)/numServers;

% Create some arrays to help display our data at the end of the simulation
spaces = ['   '; '   '; '   '; '   '; '   '; '   '; '   '; '   '];
values = ['Queue Wait:         ' ; 'Total System Wait:  '; ...
    'Queue Ave Number:   '; 'System Ave Number:  ';...
    'Utilization:        '; 'P0:                 ';...
    'Ro:                 '; 'Blocking Prob:      '];
simTheo = ['                    ' 'Theoretical ' 'Simulated '];

% Display our first server and queues result this result will be given in
% three columns first being what is being displayed second being our
% theoretical data and the third being our fourth
disp(' ');
disp(' Data ');
disp(' ');
disp('Queue 1');
disp(simTheo);
theoretical1 = theoreticalMM2(((lambda/speed)*(serverProb/10)), ...
    (mu/speed), queueSize, 1);
simulated1 = [aveTimeInQueue1 aveTimeInSystem1 aveNumInQueue1 ...
    aveNumTotal1 utilization P01 (ro*(serverProb/10)) blockingProb1];
disp([values num2str(theoretical1') spaces num2str(simulated1')]);

disp(' ');
disp('Queue 2');
disp(simTheo);
theoretical2 = theoreticalMM2(((lambda/speed)*(1-(serverProb/10))),...
    (mu/speed), queueSize, 1);
simulated2 = [aveTimeInQueue2 aveTimeInSystem2 aveNumInQueue2...
    aveNumTotal2 (utilization) P02 (ro*(1-(serverProb/10))) blockingProb2];
disp([values num2str(theoretical2') spaces num2str(simulated2')]);

disp(' ');
disp('Total');
disp(simTheo);
theoretical = (theoretical1 + theoretical2);
theoretical(1) = theoretical(1)/2;
theoretical(2) = theoretical(2)/2;
theoretical(5) = theoretical1(6) * theoretical2(6);
theoretical(8) = theoretical(8)/2;
simulated = [aveTimeInQueue aveTimeInSystem aveNumInQueue aveNumTotal...
    utilization P0 ro blockingProbabilityTotal];
disp([values num2str(theoretical') spaces num2str(simulated')]);