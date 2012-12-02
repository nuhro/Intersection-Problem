function [street_inwards_next, ...
    inwards_speed_next, ...
    street_outwards_next, ...
    outwards_speed_next, ...
    street_roundabout_local_next, ...
    roundabout_speedlocal_next, ...
    roundabout_exit_local_next] ...
    = roundabout(street_inwards, ...
    street_outwards, ...
    street_roundabout, ...
    roundabout_exit, ...
    street_inwards_next, ...
    inwards_speed_next, ...
    street_outwards_next,... 
    outwards_speed_next,EMPTY_STREET,CAR,CAR_NEXT_EXIT,PEDESTRIAN)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%car in front of roundabout

for k = 1:4
    if ( street_inwards(k,1) == CAR )
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
            street_inwards_next(k,1) = street_inwards(k,1);
            inwards_speed_next(k,1) = 0;
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
            if ( street_roundabout(j+1) == EMPTY_STREET )
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
                        
                        
                            
                        
                        
                        
                    
                
            