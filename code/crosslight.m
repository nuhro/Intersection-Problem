function [street_inwards_next, ...
    inwards_speed_next, ...
    street_outwards_next, ...
    outwards_speed_next, ...
    street_crossroad_next, ...
    crossroad_speed_next, ...
    crossroad_exit_next, ...
    pedestrian_bucket, inwards_gaps, ...
    trace_left_next, trace_left_speed_next, trace_right_direction_next] ...
    = crosslight(street_inwards, ...
    inwards_speed, ...
    street_outwards, ...
    outwards_speed, ...
    street_crossroad, ...
    crossroad_speed, ...
    crossroad_exit, pedestrian_bucket, ...
    inwards_gaps, dawdleProb, ...
    pedestrian_density, ...
    street_inwards_next, ...
    inwards_speed_next, ...
    street_outwards_next, ...
    outwards_speed_next,EMPTY_STREET,CAR,CAR_NEXT_EXIT,PEDESTRIAN,STREET_INTERSECTION, ...
    pahead, trace_left, trace_left_speed, trace_right_direction, ...
    localphase, aheadphase, turnphase)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CROSSROAD Calculation of update for a certain crossroad, density and time
%step
%
%This program requires the following subprogams:
%PDESTINATION
%
%A project by Marcel Arikan, Nuhro Ego and Ralf Kohrt in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Fall 2012
%Matlab code is based on code from Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NO_EXIT_YET = 0;
EXIT_LEFT = 5;
EXIT_RIGHT = 6;
EXIT_STRAIGHT_TOP = 3;
EXIT_STRAIGHT_LEFT = 4;
EXIT_STRAIGHT_BOTTOM = 1;
EXIT_STRAIGHT_RIGHT = 2;

%clear local next variables
street_crossroad_next = ones(6,6)*EMPTY_STREET;
crossroad_speed_next = zeros(6,6);
crossroad_exit_next = zeros(6,6);
trace_left_next = ones(4,8)*EMPTY_STREET;
trace_left_speed_next = zeros(4,8);
trace_right_direction_next = ones(4,8)*NO_EXIT_YET;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%set traffic light
%trafficlight = zeros(12,1) for car and pedestrians: red
trafficlight = settrafficlight(localphase, aheadphase, turnphase, pedestrian_density);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pedestrians
for k = 1:4
    if (rand(1) <= pedestrian_density )
        pedestrian_bucket(2,k) = 1;
    end
    if (( street_outwards(k,2) == EMPTY_STREET || street_outwards(k,2) == PEDESTRIAN) && ...
            pedestrian_bucket(2,k) > 0 && trafficlight(1+(k-1)*3,1)==1 )
        street_outwards_next(k,2) = PEDESTRIAN;
        outwards_speed_next(k,2) = 0;
        pedestrian_bucket(2,k) = 0;
    elseif ( street_outwards(k,2) == PEDESTRIAN)
        street_outwards_next(k,2) = EMPTY_STREET;
        outwards_speed_next(k,2) = 0;
    end
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%car in front of crossroad and initializing direction

for k = 1:4
    for l=1:STREET_INTERSECTION+1
        %initializing randomly directions
        if (street_inwards(k,l) == CAR && trace_right_direction(k,l)==NO_EXIT_YET)
            u=rand(1);
            %if it goes left
            if ( u < ((1-pahead)/2))
                trace_right_direction(k,l) = EXIT_LEFT;
                %if it goes ahead
            elseif ( u <= ((1+pahead)/2))
                trace_right_direction(k,l) = k;
                
                %if it goes right
            else
                trace_right_direction(k,l) = EXIT_RIGHT;
                
            end
        end
        
        %take cars with EXIT_LEFT waiting into trace_left if space is free
        if (street_inwards(k,l) == CAR && trace_right_direction(k,l)==EXIT_LEFT)
            if(trace_left(k,1) == EMPTY_STREET)
                trace_left_next(k,1) = CAR;
                trace_left_speed_next(k,1) = inwards_speed(k,l);
            else
                street_inwards_next(k,l) = CAR;
                inwards_speed_next(k,l) = 0;
                trace_right_direction_next(k,l)=EXIT_LEFT;
            end
        end
        
        %for inwards
        if (street_inwards(k,l) == CAR && trace_right_direction(k,l)~=EXIT_LEFT)
            gap = crosslight_measure_gap(-k, l, trace_right_direction(k,l) , street_crossroad, ...
                street_outwards, street_outwards_next, 1, street_inwards, street_inwards_next, trafficlight(3*k,1), ...
                EXIT_LEFT,EXIT_RIGHT,EXIT_STRAIGHT_TOP,EXIT_STRAIGHT_LEFT,EXIT_STRAIGHT_BOTTOM,EXIT_STRAIGHT_RIGHT, STREET_INTERSECTION, EMPTY_STREET);
            v = schreckenberg(inwards_speed(k,l),gap,dawdleProb);
            if(l == 1)
                inwards_gaps(1,k) = gap;
            end
            if (l+v<=STREET_INTERSECTION+1)
                street_inwards_next(k,l+v) = CAR;
                inwards_speed_next(k,l+v) = v;
                trace_right_direction_next(k,l+v) = trace_right_direction(k,l);
            else
                ni = -k;
                nj = STREET_INTERSECTION+1;
                q = 1;
                while(q <= l+v-(STREET_INTERSECTION+1))
                    if(ni > 0 || nj == STREET_INTERSECTION+1)
                        [ni, nj] = crosslight_next_ij(ni, nj, trace_right_direction(k,l) , ...
                            EXIT_LEFT,EXIT_RIGHT,EXIT_STRAIGHT_TOP,EXIT_STRAIGHT_LEFT,EXIT_STRAIGHT_BOTTOM,EXIT_STRAIGHT_RIGHT);
                    else    %we are already in street_outwards
                        %ni = ni;
                        nj = nj+1;
                    end
                    q = q+1;
                end
                if (ni > 0)
                    street_crossroad_next(ni,nj) = CAR;
                    crossroad_speed_next(ni,nj) = v;
                    crossroad_exit_next(ni,nj) = trace_right_direction(k,l);
                else
                    street_outwards_next(-ni,nj) = CAR;
                    outwards_speed_next(-ni,nj) = v;
                end
            end
        end
        
        %for trace_left
        if (trace_left(k,l) == CAR) 
            gap = crosslight_measure_gap(-k, l,EXIT_LEFT , street_crossroad, ...
                street_outwards, street_outwards_next, 1, trace_left, trace_left_next, trafficlight(2+3*(k-1),1), ...
                EXIT_LEFT,EXIT_RIGHT,EXIT_STRAIGHT_TOP,EXIT_STRAIGHT_LEFT,EXIT_STRAIGHT_BOTTOM,EXIT_STRAIGHT_RIGHT, STREET_INTERSECTION, EMPTY_STREET);
            v = schreckenberg(trace_left_speed(k,l),gap,dawdleProb);
            if (l+v<=STREET_INTERSECTION+1)
                trace_left_next(k,l+v) = CAR;
                trace_left_speed_next(k,l+v) = v;
            else
                ni = -k;
                nj = STREET_INTERSECTION+1;
                q = 1;
                while(q <= l+v-(STREET_INTERSECTION+1))
                    if(ni > 0 || nj == STREET_INTERSECTION+1)
                        [ni, nj] = crosslight_next_ij(ni, nj, EXIT_LEFT, ...
                            EXIT_LEFT,EXIT_RIGHT,EXIT_STRAIGHT_TOP,EXIT_STRAIGHT_LEFT,EXIT_STRAIGHT_BOTTOM,EXIT_STRAIGHT_RIGHT);
                    else    %we are already in street_outwards
                        %ni = ni;
                        nj = nj+1;
                    end
                    q = q+1;
                end
                if (ni > 0)
                    street_crossroad_next(ni,nj) = CAR;
                    crossroad_speed_next(ni,nj) = v;
                    crossroad_exit_next(ni,nj) = EXIT_LEFT;
                else
                    street_outwards_next(-ni,nj) = CAR;
                    outwards_speed_next(-ni,nj) = v;
                end
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%car in crossroad

for i = 1:6
    for j = 1:6
        if (street_crossroad(i,j) == CAR)
            gap = crosslight_measure_gap(i, j,crossroad_exit(i,j), street_crossroad, ...
                street_outwards, street_outwards_next, 0, street_inwards, street_inwards_next, trafficlight(1+3*(k-1),1), ...
                EXIT_LEFT,EXIT_RIGHT,EXIT_STRAIGHT_TOP,EXIT_STRAIGHT_LEFT,EXIT_STRAIGHT_BOTTOM,EXIT_STRAIGHT_RIGHT, STREET_INTERSECTION, EMPTY_STREET);
            v = schreckenberg(crossroad_speed(i,j),gap,dawdleProb);
            ni = i;
            nj = j;
            q = 1;
            while(q <= v)
                if(ni > 0)
                    [ni, nj] = crosslight_next_ij(ni, nj, crossroad_exit(i,j), ...
                        EXIT_LEFT,EXIT_RIGHT,EXIT_STRAIGHT_TOP,EXIT_STRAIGHT_LEFT,EXIT_STRAIGHT_BOTTOM,EXIT_STRAIGHT_RIGHT);
                else    %we are already in street_outwards
                    %ni = ni;
                    nj = nj+1;
                end
                q = q+1;
            end
            if (ni > 0)
                street_crossroad_next(ni,nj) = CAR;
                crossroad_speed_next(ni,nj) = v;
                crossroad_exit_next(ni,nj) = crossroad_exit(i,j);
            else
                street_outwards_next(-ni,nj) = CAR;
                outwards_speed_next(-ni,nj) = v;
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%car outwards 

for k = 1:4
    for l = 1:STREET_INTERSECTION
        %outwards street
        e = 1;
        while (e <= 5 && street_outwards(k,l+e) == EMPTY_STREET && street_outwards_next(k,l+e) == EMPTY_STREET)
            e = e + 1;
        end
        gap = e - 1;
        v = schreckenberg(outwards_speed(k,l), gap, dawdleProb);
        if(street_outwards(k,l) == CAR)
            street_outwards_next(k,l+v) = CAR;
            outwards_speed_next(k,l+v) = v;
        end
    end
end
                
end