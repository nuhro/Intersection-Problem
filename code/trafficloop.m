function trafficloop(c, d, pahead, pd, show, slow_motion, video, store_results, folder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRAFFIC Simulation of traffic in an city map containing roundabouts and
%crossroads.
%
%This program requires the following subprogams:
%TRAFFICSIM,ROUNDABOUT,CROSSROAD,CONNECTION,PDESTINATION
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


%%%%
% define global variables
BUILDING = 0;    %the colour for buildings
EMPTY_STREET = 1;
CAR = 0.4;
CAR_NEXT_EXIT = 0.6;    %the colour of a car which will take the next exit
PEDESTRIAN = 0.8;

STREET_INTERSECTION = 7;    %STREET_INTERSECTION specifies the number of elements of the road which will be taken care of by the crossroad/roundabout


%%% runtime measurement - start
tic;

%average flow and distributions for every density suppied
avFlow = zeros(max(size(pd)),max(size(d)));
avRo = zeros(max(size(pd)),max(size(d)));
avCr = zeros(max(size(pd)),max(size(d)));

if  ( show == 'y' || show == 'n' )  %if show == 'y' -> simulation with graphic output

    for di=1:max(size(d))
        for pdi=1:max(size(pd))
            if(store_results)
                [config_m,config_n] = size(c);
                filename = sprintf('../results/%g/result_(%g x %g)_%g_%g', folder, config_m, config_n, ...
                    d(di), pd(pdi));
                disp(filename);
                result = trafficsim(d(di),pd(pdi),c,show == 'y', ...
                    BUILDING,EMPTY_STREET,CAR,CAR_NEXT_EXIT,PEDESTRIAN,STREET_INTERSECTION, ...
                    pahead, slow_motion, video);
                save(filename,'result');
            else 
                [avFlow(pdi,di),avRo(pdi,di),avCr(pdi,di)] = trafficsim(d(di),pd(pdi),c,show == 'y', ...
                    BUILDING,EMPTY_STREET,CAR,CAR_NEXT_EXIT,PEDESTRIAN,STREET_INTERSECTION, ...
                    pahead, slow_motion, video);
            end
        end
    end
   
    if(store_results == 0)
        figure(2);
        %is city map is a mix of roundabout and crossroads, plot distribution
        if ( mix )
            %plot relativ number of cars at roundabouts and number of cars at
            %crossroads versus traffic density
            subplot(2,1,2);
            plot(d,avRo*100,'rx',d,avCr*100,'gx');
            set(gca,'FontSize',16);
            title('Traffic Distribution');
            xlabel('traffic density');
            ylabel('relative numeber of cars [%]');
            legend('around roundabouts','around crossroads');
            ylim([0 100]);
            subplot(2,1,1);
        end

        %plot traffic flow versus traffic density
        plot(d,avFlow,'x');
        set(gca,'FontSize',16);
        title('Traffic Dynamics');
        xlabel('traffic density');
        ylabel('average traffic flow');
        %ylim([0 0.5]);
    end
else
    disp('Input must be y or n!');
end

%%% runtime measurement - end
toc;

end