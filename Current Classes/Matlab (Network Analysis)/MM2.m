%{
Jonathan Kosir
M/M/2/K
ECE 461
------------------------------------------------------------------------
%}

% Variables
lambda = 8;
mu = 5;
ro = lambda/mu;
speed = 1;
numPackets = 1000;
serverProb = 5;
arrival = -log(rand)/lambda;       
timerVal = tic;
interval = 1/speed;
ticker = interval;
arrivalMatrix(1) = arrival;
numProcessed = 1;


for i = 2:numPackets
arrival = -log(rand)./lambda;
arrivalMatrix(i) = arrival + arrivalMatrix(i-1);
end
arrivalMatrix

disp('Start Sim');
disp(['Sime will take about ' arrivalMatrix(length(ArrivalMatrix))]);

for i = 1:length(arrivalMatrix)
    packet(1,1) = arrivalMatrix(i);
    switch state
        
        case 0 %Empty state
            
        case 1 % Queue state
            % Arrival
            
            choice = randi(10)
            if choice <= 5
             queue(packet, q, server1Queue);
            else
             queue(packet, q, server2Queue);
            end
           
        case 2  % Process/Depature state
           
            % Put new packet in system 
            
            % If queueu == 1
                % set to zero state
            %choose next packet
                % Reduce queue
                
            % Else set at zero state
        otherwise
            
    end
    
    
   
    
    
end
