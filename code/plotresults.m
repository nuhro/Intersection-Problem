function plotresults(d, pd, folder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRAFFIC Simulation of traffic in an city map containing roundabouts and
%crossroads.
%
%This function will plot the precalculated results
%
%A project by Marcel Arikan, Nuhro Ego and Ralf Kohrt in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Fall 2012
%Matlab code is based on code from Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

%%% runtime measurement - start
tic;

filename = sprintf('../results/%g/config.mat', folder);
load(filename,'c', 'pahead');


[c_m,c_n] = size(c);
%check if city map is a mix of crossroads and roundaoubts or if it is made up
%purely of one or the other
mix = not( sum(sum(c)) == c_m * c_n || sum(sum(c)) == 0 );

%average flow and distributions for every density suppied
avFlow = zeros(max(size(pd)),max(size(d)));
avRo = zeros(max(size(pd)),max(size(d)));
avCr = zeros(max(size(pd)),max(size(d)));

for di=1:max(size(d))
    for pdi=1:max(size(pd))
        [config_m,config_n] = size(c);
        filename = sprintf('../results/%g/result_(%g x %g)_%g_%g.mat', folder, config_m, config_n, ...
            d(di), pd(pdi));
        if exist(filename, 'file')
            disp(filename);
            load(filename,'result');
            disp(result);
            avFlow(pdi,di) = result(1);
            avRo(pdi,di) = result(2);
            avCr(pdi,di) = result(3);
        end
    end
end

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

%%% runtime measurement - end
toc;

end