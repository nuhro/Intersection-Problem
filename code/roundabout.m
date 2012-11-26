function [tr_next, ...
    trspeed_next, ...
    fr_next, ...
    frspeed_next, ...
    rlocal_next, ...
    rspeedlocal_next, ...
    rexlocal_next] ...
    = roundabout(tr, ...
    fr, ...
    rlocal, ...
    rexlocal, ...
    tr_next, ...
    trspeed_next, ...
    fr_next,... 
    frspeed_next)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ROUNDABOUT Calculation of update for a certain roundabout, density and
%time step
%
%A project by Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%in roundabout cell values indicate if car is about to leave roundabout:
%0.4 means car is not taking next exit (red in figure)
%0.7 means car is taking next exit (yellow in figure)
%1 means no car in this position (white in figure)

%clear local next variables
rlocal_next = ones(1,12);
rspeedlocal_next = zeros(1,12);
rexlocal_next = zeros(1,12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%car in front of roundabout

for k = 1:4
    if ( tr(k,1) == 0.4 )
        %entering roundabout with velocity 1 when possible
        %roundabout position index
        iR = mod(3*k+1,12);
        if ( rexlocal(k*3) <= 1 && rlocal(iR) == 1 )
            %enter roundabout
            %decide which exit car is going to take
            u = randi(12,1);
            %probabilty 6/12 take it takes 2. exit
            if ( u <= 6 )
                rexlocal_next(iR) = 2;
                rlocal_next(iR) = 0.4;
                rspeedlocal_next(iR) = 1;
            end
            %probabilty 3/12 take it takes 1. exit
            if ( u >= 7 && u <= 9 )
                rexlocal_next(iR) = 1;
                %indicate
                rlocal_next(iR) = 0.7;
                rspeedlocal_next(iR) = 1;
            end
            %probabilty 3/12 take it takes 3. exit
            if ( u >= 10 && u <= 12 )
                rexlocal_next(iR) = 3;
                rlocal_next(iR) = 0.4;
                rspeedlocal_next(iR) = 1;
            end
            %probabilty 1/12 take it takes 4. exit (turns around)
            %if ( u == 12 )
            %    rexlocal_next(iR) = 4;
            %    rlocal_next(iR) = 0.4;
            %    rspeedlocal_next(iR) = 1;
            %end
            
        %car waiting in front of roundabout
        else
            tr_next(k,1) = tr(k,1);
            trspeed_next(k,1) = 0;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%car in roundabout

for j = 1:12
    if ( rlocal(j) ~= 1 )
        
        %cars in roundabout not at an exit
        if (mod(j,3) ~= 0 )
            %if space free, move one forward
            if ( rlocal(j+1) == 1 )
                %take new position
                rlocal_next(j+1) = rlocal(j);
                rspeedlocal_next(j+1) = 1;
                rexlocal_next(j+1) = rexlocal(j);
            %if no space free, stay
            else
                rlocal_next(j) = rlocal(j);
                rspeedlocal_next(j) = 0;
                rexlocal_next(j) = rexlocal(j);
            end
            
        %car at an exit
        else
            
            %if car is at its exit
            if ( rexlocal(j) == 1 )
                %if space free, leave roundabout
                if ( fr(j/3,1) == 1 )
                    fr_next(j/3,1) = 0.4;
                    frspeed_next(j/3,1) = 1;
                %if no space free, stay
                else
                    rlocal_next(j) = rlocal(j);
                    rspeedlocal_next(j) = 0;
                    rexlocal_next(j) = rexlocal(j);
                end
                
            %car at an exit but not the one its taking
            else
                %connect r(12) with r(1)
                if (j == 12 )
                    %if space free, move one forward and decrease exit
                    %counter
                    if ( rlocal(1) == 1 )
                        %decrease exit by one
                        rexlocal_next(1) = rexlocal(12) - 1;
                        rspeedlocal_next(1) = 1;
                        if ( rexlocal_next(1) == 1 )
                            %indicate
                            rlocal_next(1) = 0.7;
                        else
                            rlocal_next(1) = 0.4;
                        end
                    %if no space free, stay
                    else
                        rlocal_next(12) = rlocal(12);
                        rspeedlocal_next(12) = 0;
                        rexlocal_next(12) = rexlocal(12);
                    end
                else
                    %if space free, move one forward and decrease exit
                    %counter
                    if ( rlocal(j+1) == 1 )
                        %decrease exit by one
                        rexlocal_next(j+1) = rexlocal(j) - 1;
                        rspeedlocal_next(j+1) = 1;
                        if ( rexlocal_next(j+1) == 1 )
                            %indicate
                            rlocal_next(j+1) = 0.7;
                        else
                            rlocal_next(j+1) = 0.4;
                        end
                    %if no space free, stay
                    else
                        rlocal_next(j) = rlocal(j);
                        rspeedlocal_next(j) = 0;
                        rexlocal_next(j) = rexlocal(j);
                    end
                end
            end
        end
    end
end
    
end
                        
                        
                            
                        
                        
                        
                    
                
            