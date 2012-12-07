function [street_inwards_next, ...
    inwards_speed_next, ...
    street_outwards_next, ...
    outwards_speed_next, ...
    street_crossroad_next, ...
    crossroad_speed_next, ...
    crossroad_exit, ...
    inwards_gaps] ...
    = crossroad(street_inwards, ...
    inwards_speed, ...
    street_outwards, ...
    outwards_speed, ...
    street_crossroad, ...
    crossroad_speed, ...
    crossroad_exit, ...
    inwards_gaps, dawdleProb, ...
    pedestrian_density, ...
    street_inwards_next, ...
    inwards_speed_next, ...
    street_outwards_next, ...
    outwards_speed_next,EMPTY_STREET,CAR,CAR_NEXT_EXIT,PEDESTRIAN,STREET_INTERSECTION)
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

%in crossroad cell values indicate where cars is going:
%0.1 means car is turning left (dark red in figure)
%0.4 means car is going straight ahead (red in figure)
%0.7 means car is turning right (yellow in figure)
%1 means no car in this position (white in figure)

%clear local next variables
street_crossroad_next = ones(6,6)*EMPTY_STREET;
crossroad_speed_next = zeros(6,6);

NO_EXIT_YET = 0;
EXIT_LEFT = 5;
EXIT_RIGHT = 6;
EXIT_STRAIGHT_TOP = 1;
EXIT_STRAIGHT_LEFT = 2;
EXIT_STRAIGHT_BOTTOM = 3;
EXIT_STRAIGHT_RIGHT = 4;
                        
                        



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%car outside crossroad

for k = 1:4
    for j = 1:STREET_INTERSECTION
        e = 1;
        while (e <= 5 && street_outwards(k,j+e) == EMPTY_STREET && street_outwards_next(k,j+e) == EMPTY_STREET)
            e = e + 1;
        end
        gap = e - 1;
        v = schreckenberg(outwards_speed(k,j), gap, dawdleProb);
        if(street_outwards(k,j) == CAR)
            if ( street_outwards(k,j+v) == EMPTY_STREET && street_outwards_next(k,j+v) == EMPTY_STREET)
                street_outwards_next(k,j+v) = CAR;
                outwards_speed_next(k,j+v) = v;
            else
                street_outwards_next(k,j) = CAR;
                outwards_speed_next(k,j) = 0;
            end
        end
        e = 1;
        while (e <= 5 && j + e <= STREET_INTERSECTION+1 && street_inwards(k,j+e) == EMPTY_STREET && street_inwards_next(k,j+e) == EMPTY_STREET)
            e = e + 1;
        end
        gap = e - 1;
        v = schreckenberg(inwards_speed(k,j), gap, dawdleProb);
        if(j == 1)
            inwards_gaps(1,k) = gap;
        end
        if(street_inwards(k,j) == CAR)
            if ( street_inwards(k,j+v) == EMPTY_STREET && street_inwards_next(k,j+v) == EMPTY_STREET)
                street_inwards_next(k,j+v) = CAR;
                inwards_speed_next(k,j+v) = v;
            else
                street_inwards_next(k,j) = CAR;
                inwards_speed_next(k,j) = 0;
            end
        end
    end
end
                
end