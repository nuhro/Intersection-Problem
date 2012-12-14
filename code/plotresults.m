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
avSpeed = zeros(max(size(pd)),max(size(d)));

for di=1:max(size(d))
    for pdi=1:max(size(pd))
        [config_m,config_n] = size(c);
        filename = sprintf('../results/%g/result_(%g x %g)_%g_%g.mat', folder, ...
            config_m, config_n, d(di), pd(pdi));
        if exist(filename, 'file')
            disp(filename);
            load(filename,'result');
            disp(result);
            avFlow(pdi,di) = result(1);
            avRo(pdi,di) = result(2);
            avCr(pdi,di) = result(3);
            avSpeed(pdi,di) = result(4);
        end
    end
end

fig2 = figure(2);
%is city map is a mix of roundabout and crossroads, plot distribution
if ( mix )
    %plot relative number of cars at roundabouts and number of cars at
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
hold on;
% size(avFlow)
for i=1:length(pd)
    pd(i);
    avFlow_pdi = avFlow(i,:);
    plot(d,avFlow_pdi, '-x');
end
% plot(d,avFlow(:,:), '-o')
set(gca,'FontSize',16);
title('Traffic Dynamics');
xlabel('traffic density');
ylabel('average traffic flow');
%ylim([0 0.5]);

fig3 = figure(3);
hold on;
for i=1:length(d)
    d(i);
    avFlow_di = avFlow(:,i);
    plot(pd,avFlow_di, '-x');
end
% plot(pd,avFlow(:,:), '-o')
set(gca,'FontSize',16);
title('Traffic Dynamics');
xlabel('pedestrian density');
ylabel('average traffic flow');
%ylim([0 0.5]);


fig4 = figure(4);
hold on;
for i=1:length(pd)
    pd(i);
    avSpeed_pdi = avSpeed(i,:);
    plot(d,avSpeed_pdi, '-x');
end
set(gca,'FontSize',16);
title('Traffic Dynamics');
xlabel('traffic density');
ylabel('average speed');
%ylim([0 0.5]);


fig5 = figure(5);
hold on;
for i=1:length(d)
    d(i);
    avSpeed_di = avSpeed(:,i);
    plot(pd,avSpeed_di, '-x');
end
set(gca,'FontSize',16);
title('Traffic Dynamics');
xlabel('pedestrian density');
ylabel('average speed');
%ylim([0 0.5]);

fig6 = figure(6);
% hold on;
% for di=1:length(d)
%     for pdi=1:length(pd)
%         plot3(pd(pdi), d(di) ,avSpeed(pdi,di), 'x');
%     end
% end

% imagesc(map);
% hold on;
% view(0,90);
surf(pd,d,avSpeed);

% plot3(pd, d ,avSpeed, 'x');
% set(gca,'FontSize',16);
title('Traffic Dynamics','FontWeight','bold');
xlabel('pedestrian density');
ylabel('traffic density');
zlabel('average speed');


fig7 = figure(7);
surf(pd,d,avFlow);
title('Traffic Dynamics','FontWeight','bold');
xlabel('pedestrian density');
ylabel('traffic density');
zlabel('average traffic flow');




%%% runtime measurement - end
toc;

end