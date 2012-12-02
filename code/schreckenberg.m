function [ speed ] = schreckenberg(speed, gap, dawdleProb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SCHRECKENBERG Nagel-Schreckenberg-Model
%
%OUTPUT: new speed of the selected car

%NS 1. step: increase velocity if < 5
if ( speed < 5)
    speed = speed + 1;
end

%NS 2. step: adapt speed to gap
%reduce speed if gap is too small
if ( speed > gap )
    speed = gap;
end

%NS 3. step: dawdle
if ( rand < dawdleProb && speed ~= 0 )
    speed = speed - 1;
end

end

