function [ trafficlight ] = settrafficlight( localphase, aheadphase, turnphase, pedestrian_density )
%SETTRAFFICLIGHT Calculates the current signalisation phase mainly
%depending on localphase
%3 different ways to control trafficlight depending on pedestrian_density
%either <0.3 or between 0.3 and 0.6 or >0.6
%
%Output:
%trafficlight: light signalisation for every lane, for heading towards it's for cars, leaving it's for pedestrians
%               =zeros(12,1) if red or some entries=1 if green 
%
%INPUT:
%pahead: probabiltiy for car driving ahead 
%localphase: signalisation phase for this crossroad
%aheadphase, turnphaae: relative time for signalisation staying green for
%car turning or driving ahead
%
%This program requires the following subprogams:
%ROUNDABOUT,CROSSLIGHT,CONNECTION,PDESTINATION,MEASURE_GAP,SCHRECKENBERG,PLOT_MAP
%
%A project by Marcel Arikan, Nuhro Ego and Ralf Kohrt in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Fall 2012
%Matlab code is based on code from Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trafficlight = zeros(12,1);

if (pedestrian_density<0.6)
    if (0.3<=pedestrian_density)
    adjust=1;       %to avoid that pedestrians block cars turning right
    else adjust=0;                                  %ALL FOLLOWING COMMENTS CONCERNS ONLY CARS!
    end
    if (localphase<1)                               %switch
            %leave trafficlight
    elseif (localphase<turnphase+1)                 %south: left and ahead/right
            trafficlight(2:3,1)=1;                 
            trafficlight(4,1)=1-adjust;
            trafficlight(10,1)=1;
    elseif (localphase<turnphase+2)                 %switch
            trafficlight(3,1)=1;
            trafficlight(4,1)=1-adjust;
            trafficlight(10,1)=1-adjust;
    elseif (localphase<turnphase+aheadphase+2)      %south: ahead/right and north: ahead/right
            trafficlight(3,1)=1;
            trafficlight(4,1)=1-adjust;
            trafficlight(9,1)=1;
            trafficlight(10,1)=1-adjust;
    elseif (localphase<turnphase+aheadphase+3)      %switch
            trafficlight(4,1)=1-adjust;
            trafficlight(9,1)=1;
            trafficlight(10,1)=1-adjust;
    elseif (localphase<2*turnphase+aheadphase+3)      %north: left and ahead/right
            trafficlight(4,1)=1;
            trafficlight(8,1)=1;
            trafficlight(9,1)=1;
            trafficlight(10,1)=1-adjust;
    elseif (localphase<2*turnphase+aheadphase+4)      %switch
            %leave trafficlight
    elseif (localphase<3*turnphase+aheadphase+4)      %east: left and ahead/right
            trafficlight(5,1)=1;
            trafficlight(6,1)=1;
            trafficlight(1,1)=1;
            trafficlight(7,1)=1-adjust;
     elseif (localphase<3*turnphase+aheadphase+5)      %switch
            trafficlight(6,1)=1;
            trafficlight(1,1)=1;
            trafficlight(7,1)=1-adjust;
     elseif (localphase<3*turnphase+2*aheadphase+5)      %east: ahead/right and west: ahead/right
            trafficlight(6,1)=1;
            trafficlight(12,1)=1;
            trafficlight(1,1)=1-adjust;
            trafficlight(7,1)=1-adjust;
    elseif (localphase<3*turnphase+2*aheadphase+6)      %switch
            trafficlight(12,1)=1;
            trafficlight(1,1)=1-adjust;
            trafficlight(7,1)=1;
     elseif (localphase<4*turnphase+2*aheadphase+6)      %west: left and ahead/right
            trafficlight(11,1)=1;
            trafficlight(12,1)=1;
            trafficlight(1,1)=1-adjust;
            trafficlight(7,1)=1;   
    end
else
    if (localphase<1)                               %switch
            %leave trafficlight
    elseif (localphase<turnphase+1)                 %south: left
            trafficlight(2,1)=1;
            trafficlight(4,1)=1;
            trafficlight(7,1)=1;
    elseif (localphase<turnphase+2)                 
            %leave trafficlight
    elseif (localphase<turnphase+aheadphase+2)      %south and north: ahead/right
            trafficlight(3,1)=1;
            trafficlight(9,1)=1;
    elseif (localphase<turnphase+aheadphase+3)     
            %leave trafficlight
    elseif (localphase<2*turnphase+aheadphase+3)      %west: left
            trafficlight(1,1)=1;
            trafficlight(4,1)=1;
            trafficlight(11,1)=1;
    elseif (localphase<2*turnphase+aheadphase+4)     
            %leave trafficlight
    elseif (localphase<3*turnphase+aheadphase+4)      %east: left
            trafficlight(5,1)=1;
            trafficlight(7,1)=1;
            trafficlight(10,1)=1;
    elseif (localphase<3*turnphase+aheadphase+5)     
            %leave trafficlight
    elseif (localphase<3*turnphase+2*aheadphase+5)      %east and west: ahead/right
            trafficlight(6,1)=1;
            trafficlight(12,1)=1;  
    elseif (localphase<3*turnphase+2*aheadphase+6)     
            %leave trafficlight
    elseif (localphase<4*turnphase+2*aheadphase+6)      %north: left
            trafficlight(1,1)=1;
            trafficlight(8,1)=1;
            trafficlight(10,1)=1;
    end
end

end