function [averageFlow,avCaRo,avCaCr] = trafficsim(density,config,display)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRAFFICSIM Simulation of traffic in an city map containing roundabouts and
%crossroads.
%
%Output:
%AVERAGEFLOW, Average traffic flow for given city map and density
%AVCARO, Average amount of cars around roundabouts
%AVCACR, Average amount of cars around crossroads
%
%INPUT:
%DENSITY, Traffic density 
%CONFIG, City map
%DISPlAY, Turn graphics on 'true' or off 'false'
%
%This program requires the following subprogams:
%ROUNDABOUT,CROSSROAD,CONNECTION,PDESTINATION
%
%A project by Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%dawde probability
dawdleProb = 0.2;
%street length (>5)
l = 30;
%number of iterations
nIt=1000;

%dimensions of config, how many intersections in x and y direction are
%there?
[config_m,config_n] = size(config);

%in streets cell values indicate the following:
%0.4 means there is a car in this position (red in figure)
%1 means there is no car in this position (white in figure)

%initialize matrices for streets heading toward intersections
t = ones(4*config_m,l*config_n);
tspeed = zeros(4*config_m,l*config_n);
%number of elements in t
tsize = sum(sum(t));

%initialize matrices for street leading away from intersections
f = ones(4*config_m,l*config_n);
fspeed = zeros(4*config_m,l*config_n);

%initialize matrices for roundabouts
r = ones(config_m,12*config_n);
rspeed = zeros(config_m,12*config_n);
rex = zeros(config_m,12*config_n);

%initialize matrices for crossings with priority to the right
p = ones(6*config_m,6*config_n);
pspeed = zeros(6 *config_m,6*config_n);
came = zeros(6*config_m,6*config_n);
%deadlock prevention
deadlock = zeros(config_m,config_n);

%initialaize map
map = zeros(config_m*(2*l+6),config_n*(2*l+6));
%initialize gap
gap = 0;

%initialize flow calculation variables
avSpeedIt = zeros(nIt+1,1);
%counter for cars around crossroads
numCaCrIt = zeros(nIt+1,1);
%counter for cars around crossroads
numCaRoIt = zeros(nIt+1,1);

%distribute cars randomly on streets for starting point
overall_length = sum(sum(t)) + sum(sum(f));
numCars = ceil(density * overall_length);
q = 1;

while ( q <= numCars )
    w = randi(overall_length,1);
    if ( w <= tsize )
        if ( t(w) == 1)
            t(w) = 0.4;
            tspeed(w) = randi(5,1);
            q = q + 1;
        end
    end
    if ( w > tsize )
        if ( f(w-tsize) == 1 )
            f(w-tsize) = 0.4;
            fspeed(w-tsize) = randi(5,1);
            q = q +1 ;
        end
    end
end


%iterate over time
for time = 1:nIt+1
    
    %clear values for next step
    t_next = ones(4*config_m,l*config_n);
    tspeed_next = zeros(4*config_m,l*config_n);
    f_next = ones(4*config_m,l*config_n);
    fspeed_next = zeros(4*config_m,l*config_n);
    r_next = ones(config_m,12*config_n);
    rspeed_next = zeros(config_m,12*config_n);
    rex_next = zeros(config_m,12*config_n);
    p_next = ones(6*config_m,6*config_n);
    pspeed_next = ones(6*config_m,6*config_n);
    came_next = zeros(6*config_m,6*config_n);
    deadlock_next = zeros(config_m,config_n);
    
    %iterate over all intersection
    for a = 1:config_m
        for b = 1:config_n
            
            %define Index starting points for each intersection
            tI_m = (a - 1) * 4;
            tI_n = (b - 1) * l;                
            mapI_m = (a - 1) * (2 * l + 6);
            mapI_n = (b - 1) * (2 * l + 6);
            
            %positions outside intersections
            %for every intersection iterate along streets
            for c = tI_m + 1:tI_m +4
                for d = tI_n + 1:tI_n+l
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %streets to intersections
                    
                    %deal with position directly in front of intersection
                    %separately later
                    if ( mod(d,l) ~= 0 )
                        %if there is a car in this position, apply
                        %NS-Model
                        if ( t(c,d) == 0.4 )
                            %Nagel-Schreckenberg-Model
                            %NS 1. step: increase velocity if < 5
                            v = tspeed(c,d);
                            if ( v < 5)
                                v = v + 1;
                            end
                            
                            %NS 2. step: adapt speed to gap
                            %how big is gap (to car ahead or intersection)?
                            e = 1;
                            while (e <= 5 && d + e <= b * l && ...
                                    t(c,d+e) == 1 )
                                e = e + 1;
                            end
                            gap = e - 1;
                            %reduce speed if gap is too small
                            if ( v > gap )
                                v = gap;
                            end
                            
                            %NS 3. step: dawdle
                            if ( rand < dawdleProb && v ~= 0 )
                                v = v - 1;
                            end
                            
                            %NS 4. step: drive, move cars tspeed(c,d) cells
                            %forward
                            %new position
                            t_next(c,d+v) = 0.4;
                            tspeed_next(c,d+v) = v;
                        end
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %street from intersections
                    
                    if ( f(c,d) == 0.4 )
                        %Nagel-Schreckenberg-Model
                        %NS 1. step: increase velocity if < 5
                        v = fspeed(c,d);
                        if ( v < 5)
                            v = v + 1;
                        end
                        
                        %NS 2.step: adpat speed to gap
                        %how big is gap (to car ahead)?
                        e = 1;
                        while ( e <= 5 )
                            %if gap is bigger than distance to edge,connect
                            %steets
                            if ( d + e > b * l )
                                %testing position in new street
                                hh = d + e - b * l;
                                %connect to next street
                                [ec,ed]=connection(a,b,c,hh, ...
                                    config_m,config_n,l);                                
                                while ( t(ec,ed) == 1 && e <= 5 )
                                    e = e + 1;
                                    %testing position in new street
                                    hh = d + e - b * l;
                                    %connect to next street
                                    [ec,ed]=connection(a,b,c,hh, ...
                                        config_m,config_n,l);
                                end
                                gap = e - 1;
                                e = 6;
                            else
                                if ( f(c,d+e) == 1 )
                                    e = e + 1;
                                    if ( e == 6 )
                                        gap = 5;
                                    end
                                else
                                    gap = e - 1;
                                    e = 6;
                                end
                            end
                        end
                        %reduce speed if gap is too small
                        if ( v > gap )
                            v = gap;
                        end
                        
                        %NS 3. step: dawdle
                        if ( rand <= dawdleProb && v ~= 0 )
                            v = v - 1;
                        end
                        
                        %NS 4. step: drive, move cars fspeed(c,d) cells
                        %forward
                        %if new position is off this street, connect
                        %streets
                        if ( d + v > b * l )
                            %position in new street
                            hhh =  d + v - b * l;
                            %connect next street
                            [ec,ed] = connection(a,b,c,hhh, ...
                                config_m,config_n,l);
                            t_next(ec,ed) = 0.4;
                            tspeed_next(ec,ed) = v;
                        else
                            f_next(c,d+v) = 0.4;
                            fspeed_next(c,d+v) = v;
                        end
                    end
                end
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %roundabouts
            
            %check if intersection is a roundabout
            if  ( config(a,b) == 0 )
                %define index strating point for this roundabout
                rI_n = (b - 1) * 12;
                
                %do roundabout calculations for this roundabout and time
                %step
                %call ROUNDABOUT
                [t_next(tI_m+1:tI_m+4,tI_n+l), ...
                    tspeed_next(tI_m+1:tI_m+4,tI_n+l), ...
                    f_next(tI_m+1:tI_m+4,tI_n+1), ...
                    fspeed_next(tI_m+1:tI_m+4,tI_n+1), ...
                    r_next(a,rI_n+1:rI_n+12), ...
                    rspeed_next(a,rI_n+1:rI_n+12), ...
                    rex_next(a,rI_n+1:rI_n+12)] = ...
                    roundabout(t(tI_m+1:tI_m+4,tI_n+l), ...
                    f(tI_m+1:tI_m+4,tI_n+1), ...
                    r(a,rI_n+1:rI_n+12), ...
                    rex(a,rI_n+1:rI_n+12), ...
                    t_next(tI_m+1:tI_m+4,tI_n+l), ...
                    tspeed_next(tI_m+1:tI_m+4,tI_n+l), ...
                    f_next(tI_m+1:tI_m+4,tI_n+1), ...
                    fspeed_next(tI_m+1:tI_m+4,tI_n+1));
                
                %write roundabout into map
                map(mapI_m+l+1:mapI_m+l+6,mapI_n+l+1:mapI_n+l+6) = ...
                    [ 0 1 r(a,rI_n+4) r(a,rI_n+3) 1 0;
                    1 r(a,rI_n+5) 1 1 r(a,rI_n+2) 1;
                    r(a,rI_n+6) 1 0 0 1 r(a,rI_n+1);
                    r(a,rI_n+7) 1 0 0 1 r(a,rI_n+12);
                    1 r(a,rI_n+8) 1 1 r(a,rI_n+11) 1;
                    0 1 r(a,rI_n+9) r(a,rI_n+10) 1 0];
                
                %add cars around this crossroad in this time step to
                %counter for cars around crossroads
                for v = tI_m+1:tI_m+4
                    for w = tI_n+1:tI_n+l
                        if ( t(v,w) ~= 1 )
                            numCaRoIt(time) = numCaRoIt(time) + 1;
                        end
                        if ( f(v,w) ~= 1 )
                            numCaRoIt(time) = numCaRoIt(time) + 1;
                        end
                    end
                end
                for y = rI_n+1:rI_n+12
                    if ( r(a,y) ~= 1 )
                        numCaRoIt(time) = numCaRoIt(time) + 1;
                    end
                end        
                
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %crossroads            
            
            %check if intersection is a crossing with priority to the right
            if ( config(a,b) == 1 )
                %define index strating points for this crossraod
                pI_m = (a - 1) * 6;
                pI_n = (b - 1) * 6;
                             
                %do crossroad calculations for this crossroad and time step
                %call CROSSROAD
                [t_next(tI_m+1:tI_m+4,tI_n+l), ...
                    tspeed_next(tI_m+1:tI_m+4,tI_n+l), ... 
                    f_next(tI_m+1:tI_m+4,tI_n+1), ...
                    fspeed_next(tI_m+1:tI_m+4,tI_n+1), ...
                    p_next(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ...
                    pspeed_next(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ...
                    came_next(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ...
                    deadlock_next(a,b), ...
                    map(mapI_m+l+1:mapI_m+l+6,mapI_n+l+1:mapI_n+l+6)] ...
                    = crossroad(t(tI_m+1:tI_m+4,tI_n+l), ...
                    f(tI_m+1:tI_m+4,tI_n+1), ... 
                    p(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ...
                    came(pI_m+1:pI_m+6,pI_n+1:pI_n+6), ...
                    deadlock(a,b), ...
                    t_next(tI_m+1:tI_m+4,tI_n+l), ...
                    tspeed_next(tI_m+1:tI_m+4,tI_n+l), ...
                    f_next(tI_m+1:tI_m+4,tI_n+1), ...
                    fspeed_next(tI_m+1:tI_m+4,tI_n+1));
                
                %add cars around this roundabout in this time step to
                %counter for cars around roundabouts
                for v = tI_m+1:tI_m+4
                    for w = tI_n+1:tI_n+l
                        if ( t(v,w) ~= 1 )
                            numCaCrIt(time) = numCaCrIt(time) + 1;
                        end
                        if ( f(v,w) ~= 1 )
                            numCaCrIt(time) = numCaCrIt(time) + 1;
                        end
                    end
                end
                for x = pI_m+1:pI_m+6
                    for y = pI_n+1:pI_n+6
                        if ( came(x,y) ~= 0 )
                            numCaCrIt(time) = numCaCrIt(time) + 1;
                        end
                    end
                end   

            end 

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %write streets into map
            for i = 1:l
                map(mapI_m+i,mapI_n+l+3) = t(tI_m+1,tI_n+i);
                map(mapI_m+l+4,mapI_n+i) = t(tI_m+2,tI_n+i);
                map(mapI_m+2*l+7-i,mapI_n+l+4) = t(tI_m+3,tI_n+i);
                map(mapI_m+l+3,mapI_n+2*l+7-i) = t(tI_m+4,tI_n+i);
                map(mapI_m+l+1-i,mapI_n+l+4) = f(tI_m+1,tI_n+i);
                map(mapI_m+l+3,mapI_n+l+1-i) = f(tI_m+2,tI_n+i);
                map(mapI_m+l+6+i,mapI_n+l+3) = f(tI_m+3,tI_n+i);
                map(mapI_m+l+4,mapI_n+l+6+i) = f(tI_m+4,tI_n+i);
            end
            
            %illustrate trafic situation (now not of next time step)
            if ( display)
                figure(1);
                imagesc(map);
                colormap(hot);
                titlestring = sprintf('Density = %g',density);
                title(titlestring);
                drawnow;
            end

            
        end
    end
    
    %calculate average velosity per time step
    avSpeedIt(time) = ( sum(sum(tspeed)) + sum(sum(fspeed)) + ... 
        sum(sum(rspeed)) + sum(sum(pspeed)) ) / numCars;
        
    %pause(1);
    
    %move on time step on                    
    t = t_next;
    tspeed = tspeed_next;
    f = f_next;
    fspeed = fspeed_next;
    r = r_next;
    rspeed = rspeed_next;
    rex = rex_next;
    p = p_next;
    pspeed = pspeed_next;
    came = came_next;
    deadlock = deadlock_next;
end
           
%overall average velocity
averageSpeed = sum(avSpeedIt) / max(size(avSpeedIt));
%overall average flow
averageFlow = density * averageSpeed;

%average relative amount of cars around roundabouts
avCaRo = sum(numCaRoIt) / ( max(size(numCaRoIt)) * numCars );
%average relative amount of cars around crossroads
avCaCr = sum(numCaCrIt) / ( max(size(numCaCrIt)) * numCars );
            
end