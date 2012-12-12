function [averageFlow,avCaRo,avCaCr] = trafficsim(car_density,pedestrian_density,config,display,BUILDING,EMPTY_STREET,CAR,CAR_NEXT_EXIT,PEDESTRIAN,STREET_INTERSECTION)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRAFFICSIM Simulation of traffic in an city map containing roundabouts and
%crossroads.
%
%Output:
%AVERAGEFLOW, Average traffic flow for given city map and density
%AVCARO, Average amount of cars around roundabouts
%AVCACR, Average amount of cars around crossroads
%
%INPUT:
%DENSITY, Traffic density 
%CONFIG, City map
%DISPLAY, Turn graphics on 'true' or off 'false'
%
%This program requires the following subprogams:
%ROUNDABOUT,CROSSROAD,CONNECTION,PDESTINATION
%
%A project by Marcel Arikan, Nuhro Ego and Ralf Kohrt in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Fall 2012
%Matlab code is based on code from Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%dawdle probability
dawdleProb = 0.2;
%street length (>5)
street_length = 30;
%number of iterations
nIt=1000;

%dimensions of config, how many intersections in x and y direction are
%there?
[config_m,config_n] = size(config);

%in streets cell values indicate the following:
%CAR means there is a car in this position (red in figure)
%EMPTY_STREET means there is no car in this position (white in figure)

%initialize matrices for streets heading toward intersections
street_inwards = ones(4*config_m,street_length*config_n)*EMPTY_STREET;
inwards_speed = zeros(4*config_m,street_length*config_n);
%number of elements in t
inwards_size = sum(sum(street_inwards));

%initialize matrices for street leading away from intersections
street_outwards = ones(4*config_m,street_length*config_n)*EMPTY_STREET;
outwards_speed = zeros(4*config_m,street_length*config_n);

%initialize matrices for roundabouts
street_roundabout = ones(config_m,12*config_n)*EMPTY_STREET;
roundabout_speed = zeros(config_m,12*config_n);
roundabout_exit = zeros(config_m,12*config_n);

%initialize matrices for crossings
street_crossroad = ones(6*config_m,6*config_n)*EMPTY_STREET;
%for a = 1:config_m
%    for b = 1:config_n
%        street_crossroad((a - 1)*6+1,(b - 1)*6+3) = BUILDING;
%        street_crossroad((a - 1)*6+4,(b - 1)*6+1) = BUILDING;
%        street_crossroad((a - 1)*6+3,(b - 1)*6+6) = BUILDING;
%        street_crossroad((a - 1)*6+6,(b - 1)*6+4) = BUILDING;
%    end
%end
crossroad_speed = zeros(6 *config_m,6*config_n);
crossroad_exit = zeros(6 *config_m,6*config_n);

%this are the computed gaps from the crossections/roundabouts
inwards_gaps = zeros(config_m,config_n*4);

pedestrian_bucket = zeros(2*config_m,4*config_n);

%initialize flow calculation variables
avSpeedIt = zeros(nIt+1,1);
%counter for cars around crossroads
numCaCrIt = zeros(nIt+1,1);
%counter for cars around roundabouts
numCaRoIt = zeros(nIt+1,1);

%distribute cars randomly on streets for starting point
overall_length = sum(sum(street_inwards)) + sum(sum(street_outwards));
numCars = ceil(car_density * overall_length);
q = 1;

while ( q <= numCars )
    w = randi(overall_length,1);
    if ( w <= inwards_size )
        if ( street_inwards(w) == EMPTY_STREET)
            street_inwards(w) = CAR;
            inwards_speed(w) = randi(5,1);
            q = q + 1;
        end
    end
    if ( w > inwards_size )
        if ( street_outwards(w-inwards_size) == EMPTY_STREET)
            street_outwards(w-inwards_size) = CAR;
            outwards_speed(w-inwards_size) = randi(5,1);
            q = q +1 ;
        end
    end
end


street_roundabout_next = ones(config_m,12*config_n)*EMPTY_STREET;
roundabout_speed_next = zeros(config_m,12*config_n);
street_crossroad_next = ones(6*config_m,6*config_n)*EMPTY_STREET;
crossroad_speed_next = ones(6*config_m,6*config_n);
%iterate over time
for time = 1:nIt+1
    
    %clear values for next step
    street_inwards_next = ones(4*config_m,street_length*config_n)*EMPTY_STREET;
    inwards_speed_next = zeros(4*config_m,street_length*config_n);
    street_outwards_next = ones(4*config_m,street_length*config_n)*EMPTY_STREET;
    outwards_speed_next = zeros(4*config_m,street_length*config_n);
    
    %iterate over all intersection
    for a = 1:config_m
        for b = 1:config_n
            
            %define Index starting points for each intersection
            tI_m = (a - 1) * 4;
            tI_n = (b - 1) * street_length;
            
            %positions outside intersections
            %for every intersection iterate along streets
            for c = tI_m + 1:tI_m +4
                for d = tI_n + 1:tI_n+street_length
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %streets to intersections
                    
                    %deal with the STREET_INTERSECTION positions directly in front of intersection
                    %separately later
                    if ( d-tI_n < street_length-STREET_INTERSECTION)
                        %if there is a car in this position, apply
                        %NS-Model
                        if ( street_inwards(c,d) == CAR )
                            %Nagel-Schreckenberg-Model
                            gap = measure_gap(street_inwards, street_outwards,street_length, a, b, c, d, 1, ...
                                inwards_gaps(a,(b - 1) *4+c-tI_m), config_m, config_n, EMPTY_STREET,STREET_INTERSECTION);
                            v = schreckenberg(inwards_speed(c,d), gap, dawdleProb);
                            
                            %NS 4. step: drive, move cars tspeed(c,d) cells
                            %forward
                            %new position
                            street_inwards_next(c,d+v) = CAR;
                            inwards_speed_next(c,d+v) = v;
                        end
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %street from intersections
                    
                    %deal with the STREET_INTERSECTION positions directly after the intersection
                    %separately later
                    if ( d-tI_n > STREET_INTERSECTION)
                        if ( street_outwards(c,d) == CAR )
                            %Nagel-Schreckenberg-Model
                            gap = measure_gap(street_inwards, street_outwards, street_length, a, b, c, d, 0, 0, ...
                                config_m, config_n, EMPTY_STREET,STREET_INTERSECTION);
                            v = schreckenberg(outwards_speed(c,d), gap, dawdleProb);

                            %NS 4. step: drive, move cars fspeed(c,d) cells
                            %forward
                            %if new position is off this street, connect
                            %streets
                            if ( d + v > b * street_length )
                                %position in new street
                                hhh =  d + v - b * street_length;
                                %connect next street
                                [ec,ed] = connection(a,b,c,hhh, ...
                                    config_m,config_n,street_length);
                                street_inwards_next(ec,ed) = CAR;
                                inwards_speed_next(ec,ed) = v;
                            else
                                street_outwards_next(c,d+v) = CAR;
                                outwards_speed_next(c,d+v) = v;
                            end
                        end
                    end
                end
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %roundabouts
            
            %check if intersection is a roundabout
            if  ( config(a,b) == 0 )
                %define index starting point for this roundabout
                rI_n = (b - 1) * 12;
                
                %do roundabout calculations for this roundabout and time
                %step
                %call ROUNDABOUT
                [street_inwards_next(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    inwards_speed_next(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    street_outwards_next(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6), ...
                    outwards_speed_next(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6), ...
                    street_roundabout_next(a,rI_n+1:rI_n+12), ...
                    roundabout_speed_next(a,rI_n+1:rI_n+12), ...
                    roundabout_exit(a,rI_n+1:rI_n+12), ...
                    pedestrian_bucket((a-1)*2+1:(a-1)*2+2,(b - 1) *4+1:(b - 1) *4+4), ...
                    inwards_gaps(a,(b - 1) *4+1:(b - 1) *4+4) ] = ...
                    roundabout(street_inwards(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    inwards_speed(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    street_outwards(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6), ...
                    outwards_speed(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6), ...
                    street_roundabout(a,rI_n+1:rI_n+12), ...
                    roundabout_exit(a,rI_n+1:rI_n+12), ...
                    pedestrian_bucket((a-1)*2+1:(a-1)*2+2,(b - 1) *4+1:(b - 1) *4+4), ...
                    inwards_gaps(a,(b - 1) *4+1:(b - 1) *4+4), dawdleProb, ...
                    pedestrian_density, ...
                    street_inwards_next(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    inwards_speed_next(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    street_outwards_next(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6), ...
                    outwards_speed_next(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6),EMPTY_STREET,CAR,CAR_NEXT_EXIT,PEDESTRIAN,STREET_INTERSECTION);
                
                
                %add cars around this crossroad in this time step to
                %counter for cars around crossroads
                for v = tI_m+1:tI_m+4
                    for w = tI_n+1:tI_n+street_length
                        if ( street_inwards(v,w) ~= 1 )
                            numCaRoIt(time) = numCaRoIt(time) + 1;
                        end
                        if ( street_outwards(v,w) ~= 1 )
                            numCaRoIt(time) = numCaRoIt(time) + 1;
                        end
                    end
                end
                for y = rI_n+1:rI_n+12
                    if ( street_roundabout(a,y) ~= 1 )
                        numCaRoIt(time) = numCaRoIt(time) + 1;
                    end
                end        
                
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %crossroads            
            
            %check if intersection is a crossing with priority to the right
            if ( config(a,b) == 1 )
                %define index strating points for this crossroad
                pI_m = (a - 1) * 6;
                pI_n = (b - 1) * 6;
                             
                %do crossroad calculations for this crossroad and time step
                %call CROSSROAD
                [street_inwards_next(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    inwards_speed_next(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ... 
                    street_outwards_next(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6), ...
                    outwards_speed_next(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6), ...
                    street_crossroad_next(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ...
                    crossroad_speed_next(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ...
                    crossroad_exit(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ...
                    inwards_gaps(a,(b - 1) *4+1:(b - 1) *4+4)] ...
                    = crosslight(street_inwards(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    inwards_speed(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    street_outwards(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6), ...
                    outwards_speed(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6), ... 
                    street_crossroad(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ...
                    crossroad_speed(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ...
                    crossroad_exit(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ....
                    inwards_gaps(a,(b - 1) *4+1:(b - 1) *4+4), dawdleProb, ...
                    pedestrian_density, ...
                    street_inwards_next(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    inwards_speed_next(tI_m+1:tI_m+4,tI_n+street_length-STREET_INTERSECTION:tI_n+street_length), ...
                    street_outwards_next(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6), ...
                    outwards_speed_next(tI_m+1:tI_m+4,tI_n+1:tI_n+STREET_INTERSECTION+6),EMPTY_STREET,CAR,CAR_NEXT_EXIT,PEDESTRIAN,STREET_INTERSECTION);
                
                
                %add cars around this roundabout in this time step to
                %counter for cars around roundabouts
                for v = tI_m+1:tI_m+4
                    for w = tI_n+1:tI_n+street_length
                        if ( street_inwards(v,w) ~= 1 )
                            numCaCrIt(time) = numCaCrIt(time) + 1;
                        end
                        if ( street_outwards(v,w) ~= 1 )
                            numCaCrIt(time) = numCaCrIt(time) + 1;
                        end
                    end
                end
                for x = pI_m+1:pI_m+6
                    for y = pI_n+1:pI_n+6
                        if ( came(x,y) ~= 0 )
                            numCaCrIt(time) = numCaCrIt(time) + 1;
                        end
                    end
                end   

            end 
            
        end
    end
    
    %calculate average velocity per time step
    avSpeedIt(time) = ( sum(sum(inwards_speed)) + sum(sum(outwards_speed)) + ... 
        sum(sum(roundabout_speed)) + sum(sum(crossroad_speed)) ) / numCars;
        
    %plot this timestep into the map
    if (display)
        plot_map(street_length, config, car_density, display, street_inwards, street_outwards, street_roundabout, street_crossroad, BUILDING,EMPTY_STREET)
    end
    
    % pause(1);
    
    %move on time step on                    
    street_inwards = street_inwards_next;
    inwards_speed = inwards_speed_next;
    street_outwards = street_outwards_next;
    outwards_speed = outwards_speed_next;
    street_roundabout = street_roundabout_next;
    roundabout_speed = roundabout_speed_next;
    street_crossroad = street_crossroad_next;
    crossroad_speed = crossroad_speed_next;
end
           
%overall average velocity
averageSpeed = sum(avSpeedIt) / max(size(avSpeedIt));
%overall average flow
averageFlow = car_density * averageSpeed;

%average relative amount of cars around roundabouts
avCaRo = sum(numCaRoIt) / ( max(size(numCaRoIt)) * numCars );
%average relative amount of cars around crossroads
avCaCr = sum(numCaCrIt) / ( max(size(numCaCrIt)) * numCars );
            
end