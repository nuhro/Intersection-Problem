function [ ] = plot_map(street_length, config, car_density, display, street_inwards, street_outwards, street_roundabout, street_crossroad, BUILDING,EMPTY_STREET)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PLOT_MAP This function plots the map
%
%This program requires the following subprogams:
%none
%
%A project by Marcel Arikan, Nuhro Ego and Ralf Kohrt in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Fall 2012
%Matlab code is based on code from Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%dimensions of config, how many intersections in x and y direction are there?
[config_m,config_n] = size(config);

%initialize map
map = zeros(config_m*(2*street_length+6),config_n*(2*street_length+6));

%iterate over all intersection
for a = 1:config_m
    for b = 1:config_n

        %define Index starting points for each intersection
        tI_m = (a - 1) * 4;
        tI_n = (b - 1) * street_length;
        mapI_m = (a - 1) * (2 * street_length + 6);
        mapI_n = (b - 1) * (2 * street_length + 6);

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %write roundabout into map
        
        %check if intersection is a roundabout
        if  ( config(a,b) == 0 )
            %define index starting point for this roundabout
            rI_n = (b - 1) * 12;
            %write roundabout into map
            map(mapI_m+street_length+1:mapI_m+street_length+6,mapI_n+street_length+1:mapI_n+street_length+6) = ...
                [ BUILDING EMPTY_STREET street_roundabout(a,rI_n+4) street_roundabout(a,rI_n+3) EMPTY_STREET BUILDING;
                EMPTY_STREET street_roundabout(a,rI_n+5) EMPTY_STREET EMPTY_STREET street_roundabout(a,rI_n+2) EMPTY_STREET;
                street_roundabout(a,rI_n+6) EMPTY_STREET BUILDING BUILDING EMPTY_STREET street_roundabout(a,rI_n+1);
                street_roundabout(a,rI_n+7) EMPTY_STREET BUILDING BUILDING EMPTY_STREET street_roundabout(a,rI_n+12);
                EMPTY_STREET street_roundabout(a,rI_n+8) EMPTY_STREET EMPTY_STREET street_roundabout(a,rI_n+11) EMPTY_STREET;
                BUILDING EMPTY_STREET street_roundabout(a,rI_n+9) street_roundabout(a,rI_n+10) EMPTY_STREET BUILDING];
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %write crossing into map
        
        %check if intersection is a crossing with priority to the right
        if ( config(a,b) == 1 )
            %define index strating points for this crossroad
            pI_m = (a - 1) * 6;
            pI_n = (b - 1) * 6;
            %write crossroad into map
            map(mapI_m+street_length+1:mapI_m+street_length+6,mapI_n+street_length+1:mapI_n+street_length+6) = street_crossroad(pI_m+1:pI_m+6,pI_n+1:pI_n+6);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %write streets into map
        
        for i = 1:street_length
            map(mapI_m+i,mapI_n+street_length+3) = street_inwards(tI_m+1,tI_n+i);
            map(mapI_m+street_length+4,mapI_n+i) = street_inwards(tI_m+2,tI_n+i);
            map(mapI_m+2*street_length+7-i,mapI_n+street_length+4) = street_inwards(tI_m+3,tI_n+i);
            map(mapI_m+street_length+3,mapI_n+2*street_length+7-i) = street_inwards(tI_m+4,tI_n+i);
            map(mapI_m+street_length+1-i,mapI_n+street_length+4) = street_outwards(tI_m+1,tI_n+i);
            map(mapI_m+street_length+3,mapI_n+street_length+1-i) = street_outwards(tI_m+2,tI_n+i);
            map(mapI_m+street_length+6+i,mapI_n+street_length+3) = street_outwards(tI_m+3,tI_n+i);
            map(mapI_m+street_length+4,mapI_n+street_length+6+i) = street_outwards(tI_m+4,tI_n+i);
        end
        
    end
end

%illustrate trafic situation (now not of next time step)
if (display)
    figure(1);
    imagesc(map);
    colormap(hot);
    titlestring = sprintf('Density = %g',car_density);
    title(titlestring);
    drawnow;
end

end

