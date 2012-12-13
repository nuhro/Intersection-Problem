function [ trafficlight ] = settrafficlight( localphase, aheadphase, turnphase, pedestrian_density )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
trafficlight = zeros(12,1);

if (pedestrian_density<0.6)
    if (0.3<=pedestrian_density)
    adjust=1;
    else adjust=0;
    end
    if (localphase<1)                               %F-A
            %leave trafficlight
    elseif (localphase<turnphase+1)                 %A
            trafficlight(2:3,1)=1;
            trafficlight(4,1)=1-adjust;
            trafficlight(10,1)=1;
    elseif (localphase<turnphase+2)                 %A-B
            trafficlight(3,1)=1;
            trafficlight(4,1)=1-adjust;
            trafficlight(10,1)=1-adjust;
    elseif (localphase<turnphase+aheadphase+2)      %B
            trafficlight(3,1)=1;
            trafficlight(4,1)=1-adjust;
            trafficlight(9,1)=1;
            trafficlight(10,1)=1-adjust;
    elseif (localphase<turnphase+aheadphase+3)      %B-C
            trafficlight(4,1)=1-adjust;
            trafficlight(9,1)=1;
            trafficlight(10,1)=1-adjust;
    elseif (localphase<2*turnphase+aheadphase+3)      %C
            trafficlight(4,1)=1;
            trafficlight(8,1)=1;
            trafficlight(9,1)=1;
            trafficlight(10,1)=1-adjust;
    elseif (localphase<2*turnphase+aheadphase+4)      %C-D
            %leave trafficlight
    elseif (localphase<3*turnphase+aheadphase+4)      %D
            trafficlight(5,1)=1;
            trafficlight(6,1)=1;
            trafficlight(1,1)=1;
            trafficlight(7,1)=1-adjust;
     elseif (localphase<3*turnphase+aheadphase+5)      %D-E
            trafficlight(6,1)=1;
            trafficlight(1,1)=1;
            trafficlight(7,1)=1-adjust;
     elseif (localphase<3*turnphase+2*aheadphase+5)      %E
            trafficlight(6,1)=1;
            trafficlight(12,1)=1;
            trafficlight(1,1)=1-adjust;
            trafficlight(7,1)=1-adjust;
    elseif (localphase<3*turnphase+2*aheadphase+6)      %E-F
            trafficlight(12,1)=1;
            trafficlight(1,1)=1-adjust;
            trafficlight(7,1)=1;
     elseif (localphase<4*turnphase+2*aheadphase+6)      %F
            trafficlight(11,1)=1;
            trafficlight(12,1)=1;
            trafficlight(1,1)=1-adjust;
            trafficlight(7,1)=1;   
    end
else
    if (localphase<1)
            %leave trafficlight
    elseif (localphase<turnphase+1)                 %A
            trafficlight(2,1)=1;
            trafficlight(4,1)=1;
            trafficlight(7,1)=1;
    elseif (localphase<turnphase+2)                 
            %leave trafficlight
    elseif (localphase<turnphase+aheadphase+2)      %B
            trafficlight(3,1)=1;
            trafficlight(9,1)=1;
    elseif (localphase<turnphase+ahaedphase+3)     
            %leave trafficlight
    elseif (localphase<2*turnphase+aheadphase+3)      %C
            trafficlight(1,1)=1;
            trafficlight(4,1)=1;
            trafficlight(11,1)=1;
    elseif (localphase<2*turnphase+ahaedphase+4)     
            %leave trafficlight
    elseif (localphase<3*turnphase+aheadphase+4)      %D
            trafficlight(5,1)=1;
            trafficlight(7,1)=1;
            trafficlight(10,1)=1;
    elseif (localphase<3*turnphase+ahaedphase+5)     
            %leave trafficlight
    elseif (localphase<3*turnphase+2*aheadphase+5)      %E
            trafficlight(6,1)=1;
            trafficlight(12,1)=1;  
    elseif (localphase<3*turnphase+2*ahaedphase+6)     
            %leave trafficlight
    elseif (localphase<4*turnphase+2*aheadphase+6)      %F
            trafficlight(1,1)=1;
            trafficlight(8,1)=1;
            trafficlight(10,1)=1;
    end
end

end