function [map] = plot_map(street_length, config, car_density, display, ...
    street_inwards, street_outwards, street_roundabout, street_crossroad, ...
    BUILDING,EMPTY_STREET, light, trace_left, STREET_INTERSECTION)
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
map(1,1)=2;

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
            map(mapI_m+street_length+1:mapI_m+street_length+6,...
                mapI_n+street_length+1:mapI_n+street_length+6) = ...
                [ BUILDING EMPTY_STREET street_roundabout(a,rI_n+4) street_roundabout(a,rI_n+3) EMPTY_STREET BUILDING;
                EMPTY_STREET street_roundabout(a,rI_n+5) EMPTY_STREET EMPTY_STREET street_roundabout(a,rI_n+2) EMPTY_STREET;
                street_roundabout(a,rI_n+6) EMPTY_STREET BUILDING BUILDING EMPTY_STREET street_roundabout(a,rI_n+1);
                street_roundabout(a,rI_n+7) EMPTY_STREET BUILDING BUILDING EMPTY_STREET street_roundabout(a,rI_n+12);
                EMPTY_STREET street_roundabout(a,rI_n+8) EMPTY_STREET EMPTY_STREET street_roundabout(a,rI_n+11) EMPTY_STREET;
                BUILDING EMPTY_STREET street_roundabout(a,rI_n+9) street_roundabout(a,rI_n+10) EMPTY_STREET BUILDING];
            
            %write streets into map
            %normal street
            for i = 1:street_length-3
                map(mapI_m+i,mapI_n+street_length+2) = street_inwards(tI_m+1,tI_n+i); % top, inwards
                map(mapI_m+street_length+5,mapI_n+i) = street_inwards(tI_m+2,tI_n+i); % left, inwards
                map(mapI_m+2*street_length+7-i,mapI_n+street_length+5) = street_inwards(tI_m+3,tI_n+i);	% bottom, inwards
                map(mapI_m+street_length+2,mapI_n+2*street_length+7-i) = street_inwards(tI_m+4,tI_n+i);	% right, inwards
            end
            for i = 1+3:street_length
                map(mapI_m+street_length+1-i,mapI_n+street_length+5) = street_outwards(tI_m+1,tI_n+i);	% top, outwards
                map(mapI_m+street_length+2,mapI_n+street_length+1-i) = street_outwards(tI_m+2,tI_n+i);	% left, outwards
                map(mapI_m+street_length+6+i,mapI_n+street_length+2) = street_outwards(tI_m+3,tI_n+i);	% bottom, outwards
                map(mapI_m+street_length+5,mapI_n+street_length+6+i) = street_outwards(tI_m+4,tI_n+i);	% right, outwards
            end
            %'last mile'
            for i = street_length-3+1:street_length
                map(mapI_m+i,mapI_n+street_length+3) = street_inwards(tI_m+1,tI_n+i); % top, inwards
                map(mapI_m+street_length+4,mapI_n+i) = street_inwards(tI_m+2,tI_n+i); % left, inwards
                map(mapI_m+2*street_length+7-i,mapI_n+street_length+4) = street_inwards(tI_m+3,tI_n+i);	% bottom, inwards
                map(mapI_m+street_length+3,mapI_n+2*street_length+7-i) = street_inwards(tI_m+4,tI_n+i);	% right, inwards
            end
            for i = 1:3
                map(mapI_m+street_length+1-i,mapI_n+street_length+4) = street_outwards(tI_m+1,tI_n+i);	% top, outwards
                map(mapI_m+street_length+3,mapI_n+street_length+1-i) = street_outwards(tI_m+2,tI_n+i);	% left, outwards
                map(mapI_m+street_length+6+i,mapI_n+street_length+3) = street_outwards(tI_m+3,tI_n+i);	% bottom, outwards
                map(mapI_m+street_length+4,mapI_n+street_length+6+i) = street_outwards(tI_m+4,tI_n+i);	% right, outwards
            end
            %filling fields for optics
            map(mapI_m+street_length+1-4,mapI_n+street_length+3) = EMPTY_STREET;    % top, left
            map(mapI_m+street_length+1-4,mapI_n+street_length+4) = EMPTY_STREET;    % top, right
            map(mapI_m+street_length+3,mapI_n+street_length+1-4) = EMPTY_STREET;	% left, top
            map(mapI_m+street_length+4,mapI_n+street_length+1-4) = EMPTY_STREET;	% left, bottom
            map(mapI_m+street_length+6+4,mapI_n+street_length+3) = EMPTY_STREET;	% bottom, left
            map(mapI_m+street_length+6+4,mapI_n+street_length+4) = EMPTY_STREET;	% bottom, right
            map(mapI_m+street_length+3,mapI_n+street_length+6+4) = EMPTY_STREET;	% right, top
            map(mapI_m+street_length+4,mapI_n+street_length+6+4) = EMPTY_STREET;	% right, bottom
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %write crossing into map
        
        %check if intersection is a crossing with priority to the right
        if ( config(a,b) == 1 )
            %define index starting points for this crossroad
            pI_m = (a - 1) * 6;
            pI_n = (b - 1) * 6;
            pIl_n = (b - 1) * 12;   % index for light
            pIt_m = (a - 1) * 4;    % m-index for trace left
            pIt_n = (b - 1) * 8;    % n-index for trace left
            %write crossroad into map
            map(mapI_m+street_length+1:mapI_m+street_length+6,...
                mapI_n+street_length+1:mapI_n+street_length+6) = ...
                street_crossroad(pI_m+1:pI_m+6,pI_n+1:pI_n+6);
            
            %traffic lights
            GREEN_LIGHT = 1.3;
            RED_LIGHT = 1.6;
            light(light==1) = GREEN_LIGHT;
            light(light==0) = RED_LIGHT;
            
            map(mapI_m+street_length-2, mapI_n+street_length+1) = light(a, pIl_n+0*3+3); % top, inwards
            map(mapI_m+street_length-2, mapI_n+street_length+4) = light(a, pIl_n+0*3+2); % top, trace_left
            map(mapI_m+street_length-1, mapI_n+street_length+6) = light(a, pIl_n+0*3+1); % top, pedestrians
            
            map(mapI_m+street_length+1, mapI_n+street_length-1) = light(a, pIl_n+1*3+1); % left, pedestrians
            map(mapI_m+street_length+3, mapI_n+street_length-2) = light(a, pIl_n+1*3+2); % left, trace_left
            map(mapI_m+street_length+6, mapI_n+street_length-2) = light(a, pIl_n+1*3+3); % left, inwards
            
            map(mapI_m+street_length+6+2, mapI_n+street_length+1) = light(a, pIl_n+2*3+1); % bottom, pedestrians
            map(mapI_m+street_length+6+3, mapI_n+street_length+3) = light(a, pIl_n+2*3+2); % bottom, trace_left
            map(mapI_m+street_length+6+3, mapI_n+street_length+6) = light(a, pIl_n+2*3+3); % bottom, inwards
            
            map(mapI_m+street_length+1, mapI_n+street_length+6+3) = light(a, pIl_n+3*3+3); % right, inwards
            map(mapI_m+street_length+4, mapI_n+street_length+6+3) = light(a, pIl_n+3*3+2); % right, trace_left
            map(mapI_m+street_length+6, mapI_n+street_length+6+2) = light(a, pIl_n+3*3+1); % right, pedestrians
            
            %trace left
            trace_left_length = STREET_INTERSECTION+1;
            for i = 1:trace_left_length
                map(mapI_m+street_length+7+trace_left_length-i,mapI_n+street_length+4) = trace_left(pIt_m+3,pIt_n+i);	% bottom, trace_left
                map(mapI_m+street_length+3,mapI_n+street_length+7+trace_left_length-i) = trace_left(pIt_m+4,pIt_n+i);	% right, trace_left
                map(mapI_m+street_length-trace_left_length+i,mapI_n+street_length+3) = trace_left(pIt_m+1,pIt_n+i); % top, trace_left
                map(mapI_m+street_length+4,mapI_n+street_length-trace_left_length+i) = trace_left(pIt_m+2,pIt_n+i); % left, trace_left
            end
            
            %write streets into map
            for i = 1:street_length
                map(mapI_m+i,mapI_n+street_length+2) = street_inwards(tI_m+1,tI_n+i); % top, inwards
                map(mapI_m+street_length+5,mapI_n+i) = street_inwards(tI_m+2,tI_n+i); % left, inwards
                map(mapI_m+2*street_length+7-i,mapI_n+street_length+5) = street_inwards(tI_m+3,tI_n+i);	% bottom, inwards
                map(mapI_m+street_length+2,mapI_n+2*street_length+7-i) = street_inwards(tI_m+4,tI_n+i);	% right, inwards
                map(mapI_m+street_length+1-i,mapI_n+street_length+5) = street_outwards(tI_m+1,tI_n+i);	% top, outwards
                map(mapI_m+street_length+2,mapI_n+street_length+1-i) = street_outwards(tI_m+2,tI_n+i);	% left, outwards
                map(mapI_m+street_length+6+i,mapI_n+street_length+2) = street_outwards(tI_m+3,tI_n+i);	% bottom, outwards
                map(mapI_m+street_length+5,mapI_n+street_length+6+i) = street_outwards(tI_m+4,tI_n+i);	% right, outwards
            end
        end
    
    end
end

% %illustrate trafic situation (now, not of next time step)
% fig1 = figure(1);
% imagesc(map);
% load('colormap2', 'mycmap')
% set(fig1, 'Colormap', mycmap)
% titlestring = sprintf('Density = %g',car_density);
% title(titlestring);
% drawnow;

end

