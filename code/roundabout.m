function [street_inwards_next, ...
    inwards_speed_next, ...
    street_outwards_next, ...
    outwards_speed_next, ...
    street_roundabout_local_next, ...
    roundabout_speedlocal_next, ...
    roundabout_exit_local_next, ...
    roundabout_pedestrian_bucket, inwards_gaps] ...
    = roundabout(street_inwards, ...
    inwards_speed, ...
    street_outwards, ...
    outwards_speed, ...
    street_roundabout, ...
    roundabout_exit ,roundabout_pedestrian_bucket, ...
    inwards_gaps, dawdleProb, ...
    pedestrian_density, ...
    street_inwards_next, ...
    inwards_speed_next, ...
    street_outwards_next,... 
    outwards_speed_next,EMPTY_STREET,CAR,CAR_NEXT_EXIT,PEDESTRIAN,STREET_INTERSECTION)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ROUNDABOUT Calculation of update for a certain roundabout, density and
%time step
%
%A project by Marcel Arikan, Nuhro Ego and Ralf Kohrt in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Fall 2012
%Matlab code is based on code from Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%in roundabout cell values indicate if car is about to leave roundabout:
%0.4 means car is not taking next exit (red in figure)
%0.7 means car is taking next exit (yellow in figure)
%1 means no car in this position (white in figure)

%clear local next variables
street_roundabout_local_next = ones(1,12)*EMPTY_STREET;
roundabout_speedlocal_next = zeros(1,12);
roundabout_exit_local_next = zeros(1,12);

temp_roundabout_pedestrian_bucket = roundabout_pedestrian_bucket;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%car in front of roundabout

for k = 1:4
    if ( street_inwards(k,STREET_INTERSECTION+1) == CAR )
        %entering roundabout with velocity 1 when possible
        %roundabout position index
        iR = mod(3*k+1,12);
        % enter roundabout if car at position k*3 is about to exit and
        % there is no car at position 3*k+1
        if ( roundabout_exit(k*3) <= 1 && street_roundabout(iR) == EMPTY_STREET )
            %enter roundabout
            %decide which exit car is going to take
            u = randi(10,1);
            %probabilty 3/10 take it takes 1. exit
            if ( u <= 3 )
                roundabout_exit_local_next(iR) = 1;
                %indicate
                street_roundabout_local_next(iR) = CAR_NEXT_EXIT;
                roundabout_speedlocal_next(iR) = 1;
            %probabilty 3/10 take it takes 2. exit
            elseif ( u <= 6 )
                roundabout_exit_local_next(iR) = 2;
                street_roundabout_local_next(iR) = CAR;
                roundabout_speedlocal_next(iR) = 1;
            %probabilty 3/10 take it takes 3. exit
            elseif ( u <= 9 )
                roundabout_exit_local_next(iR) = 3;
                street_roundabout_local_next(iR) = CAR;
                roundabout_speedlocal_next(iR) = 1;
            %probabilty 1/10 take it takes 4. exit (turns around)
            else
                roundabout_exit_local_next(iR) = 4;
                street_roundabout_local_next(iR) = CAR;
                roundabout_speedlocal_next(iR) = 1;
            end
            
        %car waiting in front of roundabout
        else
            street_inwards_next(k,STREET_INTERSECTION+1) = street_inwards(k,STREET_INTERSECTION+1);
            inwards_speed_next(k,STREET_INTERSECTION+1) = 0;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pedestrians


for k = 1:4
    r = rand(1);
    if (( street_inwards(k,STREET_INTERSECTION) == EMPTY_STREET || street_inwards(k,STREET_INTERSECTION) == PEDESTRIAN) && ...
            (r <= pedestrian_density || roundabout_pedestrian_bucket(1,k) > 0))
        street_inwards_next(k,STREET_INTERSECTION) = PEDESTRIAN;
        inwards_speed_next(k,STREET_INTERSECTION) = 0;
        if(r <= pedestrian_density)
            temp_roundabout_pedestrian_bucket(2,k) = 1;
        end
        if(roundabout_pedestrian_bucket(1,k) > 0)
            temp_roundabout_pedestrian_bucket(1,k) = 0;
        end
    elseif ( street_inwards(k,STREET_INTERSECTION) == PEDESTRIAN)
        street_inwards_next(k,STREET_INTERSECTION) = EMPTY_STREET;
        inwards_speed_next(k,STREET_INTERSECTION) = 0;
    end
    r = rand(1);
    if (( street_outwards(k,2) == EMPTY_STREET || street_outwards(k,2) == PEDESTRIAN) && ...
            (r <= pedestrian_density || roundabout_pedestrian_bucket(2,k) > 0))
        street_outwards_next(k,2) = PEDESTRIAN;
        outwards_speed_next(k,2) = 0;
        if(r <= pedestrian_density)
            temp_roundabout_pedestrian_bucket(1,k) = 1;
        end
        if(roundabout_pedestrian_bucket(2,k) > 0)
            temp_roundabout_pedestrian_bucket(2,k) = 0;
        end
    elseif ( street_outwards(k,2) == PEDESTRIAN)
        street_outwards_next(k,2) = EMPTY_STREET;
        outwards_speed_next(k,2) = 0;
    end
    if(0)
        if (( street_roundabout(k*3-1) == EMPTY_STREET || street_roundabout(k*3-1) == PEDESTRIAN) && roundabout_pedestrian_bucket(k) > 0)
            street_roundabout_local_next(k*3-1) = PEDESTRIAN;
            roundabout_speedlocal_next(k*3-1) = 0;
            roundabout_exit_local_next(k*3-1) = 0;
            if(roundabout_pedestrian_bucket(k) >= 1)
                roundabout_pedestrian_bucket(k) = roundabout_pedestrian_bucket(k)-1;
            end
        elseif ( street_inwards(k,2) == PEDESTRIAN && roundabout_pedestrian_bucket(k) == 0)
            street_roundabout_local_next(k*3-1) = EMPTY_STREET;
            roundabout_speedlocal_next(k*3-1) = 0;
            roundabout_exit_local_next(k*3-1) = 0;
        end
    end
end

roundabout_pedestrian_bucket = temp_roundabout_pedestrian_bucket;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%car outside roundabout



for k = 1:4
    for j = 1:STREET_INTERSECTION
        e = 1;
        while (e <= 5 && street_outwards(k,j+e) == EMPTY_STREET && street_outwards_next(k,j+e) == EMPTY_STREET)
            e = e + 1;
        end
        gap = e - 1;
        v = schreckenberg(outwards_speed(k,j), gap, dawdleProb);
        if(street_outwards(k,j) == CAR)
            if ( street_outwards(k,j+v) == EMPTY_STREET && street_outwards_next(k,j+v) == EMPTY_STREET)
                street_outwards_next(k,j+v) = CAR;
                outwards_speed_next(k,j+v) = v;
            else
                street_outwards_next(k,j) = CAR;
                outwards_speed_next(k,j) = 0;
            end
        end
        e = 1;
        while (e <= 5 && j + e <= STREET_INTERSECTION+1 && street_inwards(k,j+e) == EMPTY_STREET && street_inwards_next(k,j+e) == EMPTY_STREET)
            e = e + 1;
        end
        gap = e - 1;
        v = schreckenberg(inwards_speed(k,j), gap, dawdleProb);
        if(j == 1)
            inwards_gaps(1,k) = gap;
        end
        if(street_inwards(k,j) == CAR)
            if ( street_inwards(k,j+v) == EMPTY_STREET && street_inwards_next(k,j+v) == EMPTY_STREET)
                street_inwards_next(k,j+v) = CAR;
                inwards_speed_next(k,j+v) = v;
            else
                street_inwards_next(k,j) = CAR;
                inwards_speed_next(k,j) = 0;
            end
        end
    end
end
            
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%car in roundabout

for j = 1:12
    if ( street_roundabout(j) == CAR || street_roundabout(j) == CAR_NEXT_EXIT )
        
        %cars in roundabout not at an exit
        if (mod(j,3) ~= 0 )
            %if space free, move one forward
            if ( street_roundabout(j+1) == EMPTY_STREET && street_roundabout_local_next(j+1) == EMPTY_STREET)
                %take new position
                street_roundabout_local_next(j+1) = street_roundabout(j);
                roundabout_speedlocal_next(j+1) = 1;
                roundabout_exit_local_next(j+1) = roundabout_exit(j);
            %if no space free, stay
            else
                street_roundabout_local_next(j) = street_roundabout(j);
                roundabout_speedlocal_next(j) = 0;
                roundabout_exit_local_next(j) = roundabout_exit(j);
            end
            
        %car at an exit
        else
            
            %if car is at its exit
            if ( roundabout_exit(j) == 1 )
                %if space free, leave roundabout
                if ( street_outwards(j/3,1) == EMPTY_STREET )
                    street_outwards_next(j/3,1) = CAR;
                    outwards_speed_next(j/3,1) = 1;
                %if no space free, stay
                else
                    street_roundabout_local_next(j) = street_roundabout(j);
                    roundabout_speedlocal_next(j) = 0;
                    roundabout_exit_local_next(j) = roundabout_exit(j);
                end
                
            %car at an exit but not the one its taking
            else
                %connect r(12) with r(1)
                if (j == 12 )
                    j1 = 1;
                else
                    j1 = j+1;
                end
                %if space free, move one forward and decrease exit
                %counter
                if ( street_roundabout(j1) == EMPTY_STREET )
                    %decrease exit by one
                    roundabout_exit_local_next(j1) = roundabout_exit(j) - 1;
                    roundabout_speedlocal_next(j1) = 1;
                    if ( roundabout_exit_local_next(j1) == 1 )
                        %indicate
                        street_roundabout_local_next(j1) = CAR_NEXT_EXIT;
                    else
                        street_roundabout_local_next(j1) = CAR;
                    end
                %if no space free, stay
                else
                    street_roundabout_local_next(j) = street_roundabout(j);
                    roundabout_speedlocal_next(j) = 0;
                    roundabout_exit_local_next(j) = roundabout_exit(j);
                end
            end
        end
    end
end
    
end
                        
                        
                            
                        
                        
                        
                    
                
            