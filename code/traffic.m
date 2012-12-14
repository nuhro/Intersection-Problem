function traffic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRAFFIC Simulation of traffic in an city map containing roundabouts and
%crossroads.
%
%This program requires the following subprogams:
%TRAFFICLOOP,TRAFFICSIM,ROUNDABOUT,CROSSROAD,CONNECTION,PDESTINATION
%
%
%User will be ask to determine city map,traffic density and whether
%simulation is to be displayed or not.
%
%The city map is entered by supplying a matrix with elements '1' for
%crossroads and '0' for roundabouts.
%
%The density can be a scalar or a vector. If the density is a scalar
%TRAFFIC will run the simulation for all densities given. The elements must
%be in the range of [0,1].
%
%If Users chooses to display simulation (by entering 'y') a figure will
%open showing the animation:
%-Black cells simbolize empty space
%-White cells simbolize road
%-Red cells simbolize cars
%-Yellow cells simbolize cars indicating to the right
%-Dark red celss simbolize cars indicating to the left
%
%After all simulations have finished TRAFFIC plots the average traffic flow
%versus the traffic density. If city map is a mix of crossroad and
%roundabouts the traffic distribution (cars around roundabouts or around
%crossroads) versus traffic density is also plotted.
%
%A project by Marcel Arikan, Nuhro Ego and Ralf Kohrt in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Fall 2012
%Matlab code is based on code from Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

%promt city road configutation
c = input(['\nenter city map\n\ngive matrix elements: ', ...
    'Priority to the right (=1) and Roundabout (=0) \n\n', ...
    'i.e. [1 0 0;1 1 0;0 1 1]\n\n']);

%check c
[c_m,c_n] = size(c);
for a = 1:c_m
    for b = 1:c_n   
        if ( c(c_m,c_n) ~= 1 && c(c_m,c_n) ~= 0 )
            disp('Elements must be 0 or 1');
            return
        end
    end
end

%promt traffic density
d = input('\nenter car traffic density: ');
%check d
if ( max(d) > 1 || min(d) < 0)
    disp('density must be in range [0,1]');
    return
end

%prompt probability for car driving ahead
pahead = input('\nenter probability for car driving ahead: ');
%check pahead
if (max(pahead) > 1 || min(pahead) < 0)
    disp('probability must be in range [0,1]');
    return
end

%promt pedestrian density
pd = input('\nenter pedestrian traffic density: ');
%check pd
if ( max(pd) > 1 || min(pd) < 0)
    disp('density must be in range [0,1]');
    return
end
    
%ask if simulation should be displayed
show = input('\ndisplay simulation graphically? yes (=y) or no (=n) ','s');

%ask if simulation should be in slow_motion
slow_motion = input('\ndisplay slow_motion? yes (=y) or no (=n) ','s');
if (slow_motion == 'n')
    slow_motion = 0;
end

video = input('\ncreate video? yes (=y) or no (=n) ', 's');
if (video == 'n')
    video = 0;
end


store_results = input('\nstore results? yes (=y) or no (=n) ', 's');
if (store_results == 'n')
    store_results = 0;
end
if(store_results)
    folder = input('\nin which folder do you want to store your results?');
    filename = sprintf('../results/%g/config', folder);
    save(filename,'c', 'pahead');
    trafficloop(c, d, pahead, pd, show, slow_motion, video, store_results, folder);
else
    trafficloop(c, d, pahead, pd, show, slow_motion, video, store_results, 'n');
end


end
