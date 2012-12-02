function [tp_next, ...
    tpspeed_next, ...
    fp_next, ...
    fpspeed_next, ...
    plocal_next ... 
    pspeedlocal_next, ...
    camelocal_next, ...
    deadlocklocal_next, ...
    plocal] ...
    = crossroad(tp, ...
    fp, ...
    plocal, ...
    camelocal, ...
    deadlocklocal, ...
    tp_next, ...
    tpspeed_next, ...
    fp_next, ...
    fpspeed_next)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CROSSROAD Calculation of update for a certain crossroad, density and time
%step
%
%This program requires the following subprogams:
%PDESTINATION
%
%A project by Marcel Arikan, Nuhro Ego and Ralf Kohrt in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Fall 2012
%Matlab code is based on code from Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%in crossroad cell values indicate where cars is going:
%0.1 means car is turning left (dark red in figure)
%0.4 means car is going straight ahead (red in figure)
%0.7 means car is turning right (yellow in figure)
%1 means no car in this position (white in figure)

%clear local next variables
plocal_next = ones(6,6);
pspeedlocal_next = zeros(6,6);
camelocal_next = zeros(6,6);
deadlocklocal_next = 0;

%'paint' unused corners of plocal black
plocal(1,1) = 0;
plocal(1,6) = 0;
plocal(6,1) = 0;
plocal(6,6) = 0;
plocal(1,2) = 0;
plocal(1,5) = 0;
plocal(2,1) = 0;
plocal(2,6) = 0;
plocal(5,1) = 0;
plocal(5,6) = 0;
plocal(6,2) = 0;
plocal(6,5) = 0;

%key to unlock deadlock for this iteration and this
%intersection
unlock = randi(4,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cars in front of crossroad

%car waiting from above
if ( tp(1,1) == 0.4 )
    %if space is free and there is no car coming from the
    %left going straight ahead already in crossing, enter
    if ( plocal(1,3) == 1 && camelocal(2,3) ~= 4 && ...
            camelocal(2,4) ~= 1 && ...
            ~( camelocal(2,5) == 4 && plocal(2,5) == 0.4 ))
        %decide where car is heading 
        plocal_next(1,3) = pdestination;
        pspeedlocal_next(1,3) = 1;
        %mark which entrance car came from
        camelocal_next(1,3) = 1;
    %if not wait
    else
        tp_next(1,1) = tp(1,1);
        tpspeed_next(1,1) = 0;
    end
end

%car waiting from left
if ( tp(2,1) == 0.4 )
    %if space is free and there is no car coming from the
    %left going straight ahead already in crossing, enter
    if ( plocal(4,1) == 1 && camelocal(4,2) ~= 1 && ...
            camelocal(3,2) ~= 1 && ...
            ~( camelocal(2,2) == 1 && plocal(2,2) == 0.4 ) )
        %decide where car is heading 
        plocal_next(4,1) = pdestination;
        pspeedlocal_next(4,1) = 1;
        %mark which entrance car came from
        camelocal_next(4,1) = 2;
    %if not wait
    else
        tp_next(2,1) = tp(2,1);
        tpspeed_next(2,1) = 0;
    end
end

%car waiting from below
if ( tp(3,1) == 0.4 )
    %if space is free and there is no car coming from the
    %left going straight ahead already in crossing, enter
    if ( plocal(6,4) == 1 && camelocal(5,4) ~= 2 && ...
            camelocal(5,3) ~= 2 && ...
            ~( camelocal(5,2) == 2 && plocal(5,2) == 0.4 ) )
        %decide where car is heading 
        plocal_next(6,4) = pdestination;
        pspeedlocal_next(6,4) = 1;
        %mark which entrance car came from
        camelocal_next(6,4) = 3;
    %if not wait
    else
        tp_next(3,1) = tp(3,1);
        tpspeed_next(3,1) = 0;
    end
end

%car waiting from right                
if ( tp(4,1) == 0.4 )
    %if space is free and there is no car coming from the
    %left going straight ahead already in crossing, enter
    if ( plocal(3,6) == 1 && camelocal(3,5) ~= 3 && ...
            camelocal(4,5) ~= 3 && ...
            ~( camelocal(5,5) == 3 && plocal(5,5) == 0.4 ) )
        %decide where car is heading
        plocal_next(3,6) = pdestination;
        pspeedlocal_next(3,6) = 1;
        %mark which entrance car came from
        camelocal_next(3,6) = 4;
    %if not wait
    else
        tp_next(4,1) = tp(4,1);
        tpspeed_next(4,1) = 0;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cars going turning right step 1

%car coming form above, turning right
%1. step
if ( plocal(1,3) == 0.7 )
    %if space free, car has right of way and can drive
    if ( plocal(2,2) == 1 && plocal(2,3) ~= 0.4 )
        plocal_next(2,2) = plocal(1,3);
        pspeedlocal_next(2,2) = 1;
        camelocal_next(2,2) = camelocal(1,3);
    % if space not free, stay
    else
        plocal_next(1,3) = plocal(1,3);
        pspeedlocal_next(1,3) = 0;
        camelocal_next(1,3) = camelocal(1,3);
    end
end

%car coming form left, turning right
%1. step
if ( plocal(4,1) == 0.7 )
    %if space free, car has right of way and can drive
    if ( plocal(5,2) == 1 && plocal(4,2) ~= 0.4 )
        plocal_next(5,2) = plocal(4,1);
        pspeedlocal_next(5,2) = 1;
        camelocal_next(5,2) = camelocal(4,1);
    % if space not free, stay
    else
        plocal_next(4,1) = plocal(4,1);
        pspeedlocal_next(4,1) = 0;
        camelocal_next(4,1) = camelocal(4,1);
    end
end    

%car coming form below, turning right
%1. step
if ( plocal(6,4) == 0.7 )
    %if space free, car has right of way and can drive
    if ( plocal(5,5) == 1 && plocal(5,4) ~= 0.4 )
        plocal_next(5,5) = plocal(6,4);
        pspeedlocal_next(5,5) = 1;
        camelocal_next(5,5) = camelocal(6,4);
    % if space not free, stay
    else
        plocal_next(6,4) = plocal(6,4);
        pspeedlocal_next(6,4) = 0;
        camelocal_next(6,4) = camelocal(6,4);
    end
end  

%car coming form right, turning right
%1. step
if ( plocal(3,6) == 0.7 )
    %if space free, car has right of way and can drive
    if ( plocal(2,5) == 1 && plocal(3,5) ~= 0.4 )
        plocal_next(2,5) = plocal(3,6);
        pspeedlocal_next(2,5) = 1;
        camelocal_next(2,5) = camelocal(3,6);
    % if space not free, stay
    else
        plocal_next(3,6) = plocal(3,6);
        pspeedlocal_next(3,6) = 0;
        camelocal_next(3,6) = camelocal(3,6);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cars going straight ahead step 1

%car coming form above, going stright ahead
%1. step
if ( plocal(1,3) == 0.4 )
    %if space is free and there are no are coming from the
    %right or is there has been a deadlock and driver have
    %agreed by hand signal to let this car go, dive
    %!warning: only works if this step is done after update
    %of cars in front of crossraod!
    if ( plocal(2,2) == 1 && plocal(2,3) ~= 0.4 && ...
            ( ( tp_next(2,1) == 1 && plocal_next(4,1) == 1 && ... 
            plocal(4,1) == 1 ) || ( deadlocklocal == 4 && unlock == 1 ) ) )
        plocal_next(2,2) = plocal(1,3);
        pspeedlocal_next(2,2) = 1;
        camelocal_next(2,2) = camelocal(1,3);
        %no deadlock, clear deadlock counter
        deadlocklocal_next = 0;
    % if not, stay
    else
        plocal_next(1,3) = plocal(1,3);
        pspeedlocal_next(1,3) = 0;
        camelocal_next(1,3) = camelocal(1,3);
        %increase deadlock counter, if it reaches 4 a
        %deadlock occurs and will have to be solve in next
        %time step by a hand signals between drivers
        deadlocklocal_next = deadlocklocal_next + 1;                      
    end
end

%car coming form left, going stright ahead
%1. step
if ( plocal(4,1) == 0.4 )
    %if space is free and there are no are coming from the
    %right or is there has been a deadlock and driver have
    %agreed by hand signal to let this car go, dive
    %!warning: only works if this step is done after update
    %of cars in front of crossraod!
    if ( plocal(5,2) == 1 && plocal(4,2) ~= 0.4 && ...
            ( ( tp_next(3,1) == 1 && plocal_next(6,4) == 1 && ...
            plocal(6,4) == 1 ) || ( deadlocklocal == 4 && unlock == 2 ) ) )
        plocal_next(5,2) = plocal(4,1);
        pspeedlocal_next(5,2) = 1;
        camelocal_next(5,2) = camelocal(4,1);
        %no deadlock, clear deadlock counter
        deadlocklocal_next = 0;
    % if not, stay
    else
        plocal_next(4,1) = plocal(4,1);
        pspeedlocal_next(4,1) = 0;
        camelocal_next(4,1) = camelocal(4,1);
        %increase deadlock counter, if it reaches 4 a
        %deadlock occurs and will have to be solve in next
        %time step by a hand signals between drivers
        deadlocklocal_next = deadlocklocal_next + 1;
    end
end

%car coming form below, going stright ahead 
%1. step
if ( plocal(6,4) == 0.4 )
    %if space is free and there are no are coming from the
    %right or is there has been a deadlock and driver have
    %agreed by hand signal to let this car go, dive
    %!warning: only works if this step is done after update
    %of cars in front of crossraod!
    if ( plocal(5,5) == 1 && plocal(5,4) ~= 0.4 && ...
            ( ( tp_next(4,1) == 1 && plocal_next(3,6) == 1 && ...
            plocal(3,6) == 1 ) || ( deadlocklocal == 4 && unlock == 3 ) ) )
        plocal_next(5,5) = plocal(6,4);
        pspeedlocal_next(5,5) = 1;
        camelocal_next(5,5) = camelocal(6,4);
        %no deadlock, clear deadlock counter
        deadlocklocal_next = 0;
    % if not, stay
    else
        plocal_next(6,4) = plocal(6,4);
        pspeedlocal_next(6,4) = 0;
        camelocal_next(6,4) = camelocal(6,4);
        %increase deadlock counter, if it reaches 4 a
        %deadlock occurs and will have to be solve in next
        %time step by a hand signals between drivers
        deadlocklocal_next = deadlocklocal_next + 1;
    end
end 

%car coming form right, going stright ahead
%1. step
if ( plocal(3,6) == 0.4 )
    %if space is free and there are no are coming from the
    %right or is there has been a deadlock and driver have
    %agreed by hand signal to let this car go, dive
    %!warning: only works if this step is done after update
    %of cars in front of crossraod!
    if ( plocal(2,5) == 1 && plocal(3,5) ~= 0.4 && ...
            ( ( tp_next(1,1) == 1 && plocal_next(1,3) == 1 && ...
            plocal(1,3) == 1 ) || ( deadlocklocal == 4 && unlock == 4 ) ) )
        plocal_next(2,5) = plocal(3,6);
        pspeedlocal_next(2,5) = 1;
        camelocal_next(2,5) = camelocal(3,6);
        %no deadlock, clear deadlock counter
        deadlocklocal_next = 0;
    % if not, stay
    else
        plocal_next(3,6) = plocal(3,6);
        pspeedlocal_next(3,6) = 0;
        camelocal_next(3,6) = camelocal(3,6);
        %increase deadlock counter, if it reaches 4 a
        %deadlock occurs and will have to be solve in next
        %time step by a hand signals between drivers
        deadlocklocal_next = deadlocklocal_next + 1; 
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cars turning right step 2
%cars going straight ahead step 5

%2. step for car coming from above, turning right
%5. step for car coming from right, going straight ahead 
if ( plocal(2,2) == 0.7 || ( plocal(2,2) == 0.4 && camelocal(2,2) == 4 ) )
    %if space free, car has right of way and can drive
    if ( plocal(3,1) == 1 )
        plocal_next(3,1) = plocal(2,2);
        pspeedlocal_next(3,1) = 1;
        camelocal_next(3,1) = camelocal(2,2);
        % if space not free, stay
    else
        plocal_next(2,2) = plocal(2,2);
        pspeedlocal_next(2,2) = 0;
        camelocal_next(2,2) = camelocal(2,2);
    end
end

%2. step for car coming from left, turning right
%5. step for car coming from above, going straight ahead
if ( plocal(5,2) == 0.7 || ( plocal(5,2) == 0.4 && camelocal(5,2) == 1 ) )
    %if space free, car has right of way and can drive
    if ( plocal(6,3) == 1 )
        plocal_next(6,3) = plocal(5,2);
        pspeedlocal_next(6,3) = 1;
        camelocal_next(6,3) = camelocal(5,2);
    % if space not free, stay
    else
        plocal_next(5,2) = plocal(5,2);
        pspeedlocal_next(5,2) = 0;
        camelocal_next(5,2) = camelocal(5,2);
    end
end

%2. step for car coming from below, turning right
%5. step for car coming from left, going straight ahead
if ( plocal(5,5) == 0.7 || ( plocal(5,5) == 0.4 && camelocal(5,5) == 2 ) )
    %if space free, car has right of way and can drive
    if ( plocal(4,6) == 1 )
        plocal_next(4,6) = plocal(5,5);
        pspeedlocal_next(4,6) = 1;
        camelocal_next(4,6) = camelocal(5,5);
    % if space not free, stay
    else
        plocal_next(5,5) = plocal(5,5);
        pspeedlocal_next(5,5) = 0;
        camelocal_next(5,5) = camelocal(5,5);
    end
end 

%2. step for car coming from right, turning right
%5. step for car coming from below, going straight ahead
if ( plocal(2,5) == 0.7 || ( plocal(2,5) == 0.4 && camelocal(2,5) == 3) )
    %if space free, car has right of way and can drive
    if ( plocal(1,4) == 1 )
        plocal_next(1,4) = plocal(2,5);
        pspeedlocal_next(1,4) = 1;
        camelocal_next(1,4) = camelocal(2,5);
    % if space not free, stay
    else
        plocal_next(2,5) = plocal(2,5);
        pspeedlocal_next(2,5) = 0;
        camelocal_next(2,5) = camelocal(2,5);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cars going staight ahead step 2 to 4

%car coming form above, going staight ahead
%2. step
if ( plocal(2,2) == 0.4 && camelocal(2,2) == 1 )
    %if space is free, drive
    if ( plocal(3,2) == 1 )
        plocal_next(3,2) = plocal(2,2);
        pspeedlocal_next(3,2) = 1;
        camelocal_next(3,2) = camelocal(2,2);
    % if not, wait
    else
        plocal_next(2,2) = plocal(2,2);
        pspeedlocal_next(2,2) = 0;
        camelocal_next(2,2) = camelocal(2,2); 
    end
end
%3. step
if ( plocal(3,2) == 0.4 )
    %if space is free, drive
    if ( plocal(4,2) == 1 && plocal(4,1) ~= 0.1 )
        plocal_next(4,2) = plocal(3,2);
        pspeedlocal_next(4,2) = 1;
        camelocal_next(4,2) = camelocal(3,2);
    % if not, wait
    else
        plocal_next(3,2) = plocal(3,2);
        pspeedlocal_next(3,2) = 0;
        camelocal_next(3,2) =camelocal(3,2);
    end
end
%4. step
if ( plocal(4,2) == 0.4 )
    %if space is free, drive
    if ( plocal(5,2) == 1 )
        plocal_next(5,2) = plocal(4,2);
        pspeedlocal_next(5,2) = 1;
        camelocal_next(5,2) = camelocal(4,2);
    % if not, wait
    else
        plocal_next(4,2) = plocal(4,2);
        pspeedlocal_next(4,2) = 0;
        camelocal_next(4,2) = camelocal(4,2);
    end
end

%car coming form left, going staight ahead
%2. step
if ( plocal(5,2) == 0.4 && camelocal(5,2) == 2 )
    %if space is free, drive
    if ( plocal(5,3) == 1 )
        plocal_next(5,3) = plocal(5,2);
        pspeedlocal_next(5,3) = 1;
        camelocal_next(5,3) = camelocal(5,2);
    % if not, wait
    else
        plocal_next(5,2) = plocal(5,2);
        pspeedlocal_next(5,2) = 0;
        camelocal_next(5,2) = camelocal(5,2); 
    end
end
%3. step
if ( plocal(5,3) == 0.4 )
    %if space is free, drive
    if ( plocal(5,4) == 1 && plocal(6,4) ~= 0.1 )
        plocal_next(5,4) = plocal(5,3);
        pspeedlocal_next(5,4) = 1;
        camelocal_next(5,4) = camelocal(5,3);
    % if not, wait
    else
        plocal_next(5,3) = plocal(5,3);
        pspeedlocal_next(5,3) = 0;
        camelocal_next(5,3) =camelocal(5,3);
    end
end
%4. step
if ( plocal(5,4) == 0.4 )
    %if space is free, drive
    if ( plocal(5,5) == 1 )
        plocal_next(5,5) = plocal(5,4);
        pspeedlocal_next(5,5) = 1;
        camelocal_next(5,5) = camelocal(5,4);
    % if not, wait
    else
        plocal_next(5,4) = plocal(5,4);
        pspeedlocal_next(5,4) = 0;
        camelocal_next(5,4) = camelocal(5,4);
    end
end

%car coming form below, going staight ahead
%2. step
if ( plocal(5,5) == 0.4 && camelocal(5,5) == 3 )
    %if space is free, drive
    if ( plocal(4,5) == 1 )
        plocal_next(4,5) = plocal(5,5);
        pspeedlocal_next(4,5) = 1;
        camelocal_next(4,5) = camelocal(5,5);
    % if not, wait
    else
        plocal_next(5,5) = plocal(5,5);
        pspeedlocal_next(5,5) = 0;
        camelocal_next(5,5) = camelocal(5,5); 
    end
end
%3. step
if ( plocal(4,5) == 0.4 )
    %if space is free, drive
    if ( plocal(3,5) == 1 && plocal(3,6) ~= 0.1 )
        plocal_next(3,5) = plocal(4,5);
        pspeedlocal_next(3,5) = 1;
        camelocal_next(3,5) = camelocal(4,5);
    % if not, wait
    else
        plocal_next(4,5) = plocal(4,5);
        pspeedlocal_next(4,5) = 0;
        camelocal_next(4,5) =camelocal(4,5);
    end
end
%4. step
if ( plocal(3,5) == 0.4 )
    %if space is free, drive
    if ( plocal(2,5) == 1 )
        plocal_next(2,5) = plocal(3,5);
        pspeedlocal_next(2,5) = 1;
        camelocal_next(2,5) = camelocal(3,5);
    % if not, wait
    else
        plocal_next(3,5) = plocal(3,5);
        pspeedlocal_next(3,5) = 0;
        camelocal_next(3,5) = camelocal(3,5);
    end
end

%car coming form right, going staight ahead               
%2. step
if ( plocal(2,5) == 0.4 && camelocal(2,5) == 4 )
    %if space is free, drive
    if ( plocal(2,4) == 1 )
        plocal_next(2,4) = plocal(2,5);
        pspeedlocal_next(2,4) = 1;
        camelocal_next(2,4) = camelocal(2,5);
    % if not, wait
    else
        plocal_next(2,5) = plocal(2,5);
        pspeedlocal_next(2,5) = 0;
        camelocal_next(2,5) = camelocal(2,5); 
    end
end
%3. step
if ( plocal(2,4) == 0.4 )
    %if space is free, drive
    if ( plocal(2,3) == 1 && plocal(1,3) ~= 0.1 )
        plocal_next(2,3) = plocal(2,4);
        pspeedlocal_next(2,3) = 1;
        camelocal_next(2,3) = camelocal(2,4);
    % if not, wait
    else
        plocal_next(2,4) = plocal(2,4);
        pspeedlocal_next(2,4) = 0;
        camelocal_next(2,4) =camelocal(2,4);
    end
end
%4. step
if ( plocal(2,3) == 0.4 )
    %if space is free, drive
    if ( plocal(2,2) == 1 )
        plocal_next(2,2) = plocal(2,3);
        pspeedlocal_next(2,2) = 1;
        camelocal_next(2,2) = camelocal(2,3);
    % if not, wait
    else
        plocal_next(2,3) = plocal(2,3);
        pspeedlocal_next(2,3) = 0;
        camelocal_next(2,3) = camelocal(2,3);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cars turning left

%car coming from above turning left
%1. step
if ( plocal(1,3) == 0.1 )
    %if next two spaces are free and there is no car coming
    %form right turning in front of this car, drive
    if ( plocal(2,3) == 1 && plocal(3,4) == 1 && ...
            plocal(4,2) ~= 0.1 && plocal(3,3) == 1 )
        plocal_next(2,3) = plocal(1,3);
        pspeedlocal_next(2,3) = 1;
        camelocal_next(2,3) = camelocal(1,3);
    %if not, stay
    else
        plocal_next(1,3) = plocal(1,3);
        pspeedlocal_next(1,3) = 0;
        camelocal_next(1,3) = camelocal(1,3);
    end
end
%2. step
if ( plocal(2,3) == 0.1 )
    %is space is free, drive
    if ( plocal(3,4) == 1 )
        plocal_next(3,4) = plocal(2,3);
        pspeedlocal_next(3,4) = 1;
        camelocal_next(3,4) = camelocal(2,3);
    %if not, stay
    else
        plocal_next(2,3) = plocal(2,3);
        pspeedlocal_next(2,3) = 0;
        camelocal_next(2,3) = camelocal(2,3);
    end
end
%3 .step
if ( plocal(3,4) == 0.1 )
    %if space is free and there is no car coming from the 
    %opposite side going straight ahead and no car coming
    %from the right , drive
    if ( plocal(4,5) == 1 && plocal(4,6) == 1 && ...
            plocal(5,5) == 1 && plocal(5,4) ~= 0.4 )
        plocal_next(4,5) = plocal(3,4);
        pspeedlocal_next(4,5) = 1;
        camelocal_next(4,5) = camelocal(3,4);
    %if not, stay
    else
        plocal_next(3,4) = plocal(3,4);
        pspeedlocal_next(3,4) = 0;
        camelocal_next(3,4) = camelocal(3,4);
    end
end
%4. step
if ( plocal(4,5) == 0.1 )
    %if space is free, drive
    if ( plocal(4,6) == 1 && plocal(5,5) ~= 0.7 && ...
            ~( plocal(5,5) == 0.4 && camelocal(5,5) == 2 ) )
        plocal_next(4,6) = plocal(4,5);
        pspeedlocal_next(4,6) = 1;
        camelocal_next(4,6) = camelocal(4,5);
    %if not, stay
    else
        plocal_next(4,5) = plocal(4,5);
        pspeedlocal_next(4,5) = 0;
        camelocal_next(4,5) = camelocal(4,5);
    end
end

%car coming from the left turning left
%1. step
if ( plocal(4,1) == 0.1 )
    %if next two spaces are free and there is no car coming
    %form right turning in front of this car, drive
    if ( plocal(4,2) == 1 && plocal(3,3) == 1 && ...
            plocal(5,4) ~= 0.1 && plocal(4,3) == 1 ) 
        plocal_next(4,2) = plocal(4,1);
        pspeedlocal_next(4,2) = 1;
        camelocal_next(4,2) = camelocal(4,1);
    %if not, stay
    else
        plocal_next(4,1) = plocal(4,1);
        pspeedlocal_next(4,1) = 0;
        camelocal_next(4,1) = camelocal(4,1);
    end
end
%2. step
if ( plocal(4,2) == 0.1 )
    %is space is free, drive
    if ( plocal(3,3) == 1 )
        plocal_next(3,3) = plocal(4,2);
        pspeedlocal_next(3,3) = 1;
        camelocal_next(3,3) = camelocal(4,2);
    %if not, stay
    else
        plocal_next(4,2) = plocal(4,2);
        pspeedlocal_next(4,2) = 0;
        camelocal_next(4,2) = camelocal(4,2);
    end
end
%3 .step
if ( plocal(3,3) == 0.1 )
    %if space is free and there is no car coming from the 
    %opposite side going straight ahead and no car coming
    %from the right , drive
    if ( plocal(2,4) == 1 && plocal(1,4) == 1 && ...
            plocal(2,5) == 1 && plocal(3,5) ~= 0.4 )
        plocal_next(2,4) = plocal(3,3);
        pspeedlocal_next(2,4) = 1;
        camelocal_next(2,4) = camelocal(3,3);
    %if not, stay
    else
        plocal_next(3,3) = plocal(3,3);
        pspeedlocal_next(3,3) = 0;
        camelocal_next(3,3) = camelocal(3,3);
    end
end
%4. step
if ( plocal(2,4) == 0.1 )
    %if space is free, drive
    if ( plocal(1,4) == 1 && plocal(2,5) ~= 0.7 && ...
            ~( plocal(2,5) == 0.4 && camelocal(2,5) == 3 ) )
        plocal_next(1,4) = plocal(2,4);
        pspeedlocal_next(1,4) = 1;
        camelocal_next(1,4) = camelocal(2,4);
    %if not, stay
    else
        plocal_next(2,4) = plocal(2,4);
        pspeedlocal_next(2,4) = 0;
        camelocal_next(2,4) = camelocal(2,4);
    end
end

%car coming from below turning left
%1. step
if ( plocal(6,4) == 0.1 )
    %if next two spaces are free and there is no car coming
    %form right turning in front of this car, drive
    if ( plocal(5,4) == 1 && plocal(4,3) == 1 && ...
            plocal(3,5) ~= 0.1 && plocal(4,4) == 1 )
        plocal_next(5,4) = plocal(6,4);
        pspeedlocal_next(5,4) = 1;
        camelocal_next(5,4) = camelocal(6,4);
    %if not, stay
    else
        plocal_next(6,4) = plocal(6,4);
        pspeedlocal_next(6,4) = 1;
        camelocal_next(6,4) = camelocal(6,4);
    end
end
%2. step
if ( plocal(5,4) == 0.1 )
    %is space is free, drive
    if ( plocal(4,3) == 1 )
        plocal_next(4,3) = plocal(5,4);
        pspeedlocal_next(4,3) = 1;
        camelocal_next(4,3) = camelocal(5,4);
    %if not, stay
    else
        plocal_next(5,4) = plocal(5,4);
        pspeedlocal_next(5,4) = 0;
        camelocal_next(5,4) = camelocal(5,4);
    end
end
%3 .step
if ( plocal(4,3) == 0.1 )
    %if space is free and there is no car coming from the 
    %opposite side going straight ahead and no car coming
    %from the right , drive
    if ( plocal(3,2) == 1 && plocal(3,1) == 1 && ...
            plocal(2,2) == 1 && plocal(2,3) ~= 0.4 )
        plocal_next(3,2) = plocal(4,3);
        pspeedlocal_next(3,2) = 1;
        camelocal_next(3,2) = camelocal(4,3);
    %if not, stay
    else
        plocal_next(4,3) = plocal(4,3);
        pspeedlocal_next(4,3) = 0;
        camelocal_next(4,3) = camelocal(4,3);
    end
end
%4. step
if ( plocal(3,2) == 0.1 )
    %if space is free, drive
    if ( plocal(3,1) == 1 && plocal(2,2) ~= 0.7 && ...
            ~( plocal(2,2) == 0.4 && camelocal(2,2) == 4 ) )
        plocal_next(3,1) = plocal(3,2);
        pspeedlocal_next(3,1) = 1;
        camelocal_next(3,1) = camelocal(3,2);
    %if not, stay
    else
        plocal_next(3,2) = plocal(3,2);
        pspeedlocal_next(3,2) = 0;
        camelocal_next(3,2) = camelocal(3,2);
    end
end

%car coming from right turning left
%1. step
if ( plocal(3,6) == 0.1 )
    %if next two spaces are free and there is no car coming
    %form right turning in front of this car, drive
    if ( plocal(3,5) == 1 && plocal(4,4) == 1 && ...
            plocal(2,3) ~= 0.1 && plocal(3,4) == 1 )
        plocal_next(3,5) = plocal(3,6);
        pspeedlocal_next(3,5) = 1;
        camelocal_next(3,5) = camelocal(3,6);
    %if not, stay
    else
        plocal_next(3,6) = plocal(3,6);
        pspeedlocal_next(3,6) = 0;
        camelocal_next(3,6) = camelocal(3,6);
    end
end
%2. step
if ( plocal(3,5) == 0.1 )
    %is space is free, drive
    if ( plocal(4,4) == 1 )
        plocal_next(4,4) = plocal(3,5);
        pspeedlocal_next(4,4) = 1;
        camelocal_next(4,4) = camelocal(3,5);
    %if not, stay
    else
        plocal_next(3,5) = plocal(3,5);
        pspeedlocal_next(3,5) = 0;
        camelocal_next(3,5) = camelocal(3,5);
    end
end
%3 .step
if ( plocal(4,4) == 0.1 )
    %if space is free and there is no car coming from the 
    %opposite side going straight ahead and no car coming
    %from the right , drive
    if ( plocal(5,3) == 1 && plocal(6,3) == 1 && ...
            plocal(5,2) == 1 && plocal(4,2) ~= 0.4 )
        plocal_next(5,3) = plocal(4,4);
        pspeedlocal_next(5,3) = 1;
        camelocal_next(5,3) = camelocal(4,4);
    %if not, stay
    else
        plocal_next(4,4) = plocal(4,4);
        pspeedlocal_next(4,4) = 0;
        camelocal_next(4,4) = camelocal(4,4);
    end
end
%4. step
if ( plocal(5,3) == 0.1 )
    %if space is free, drive
    if ( plocal(6,3) == 1 && plocal(5,2) ~= 0.7 && ...
            ~( plocal(5,2) == 0.4 && camelocal(5,2) == 1 ) )
        plocal_next(6,3) = plocal(5,3);
        pspeedlocal_next(6,3) = 1;
        camelocal_next(6,3) = camelocal(5,3);
    %if not, stay
    else
        plocal_next(5,3) = plocal(5,3);
        pspeedlocal_next(5,3) = 1;
        camelocal_next(5,3) = camelocal(5,3);
    end
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cars leaving crossing

%car leaving to the top
if ( plocal(1,4) ~= 1 )
    %if space free, leave crossing with speed 1
    if ( fp(1,1) == 1 )
        fp_next(1,1) = 0.4;
        fpspeed_next(1,1) = 1;
    %if space not free, stay
    else
        plocal_next(1,4) = plocal(1,4);
        pspeedlocal_next(1,4) = 0;
        camelocal_next(1,4) = camelocal(1,4);
    end
end

%car leaving to the left
if ( plocal(3,1) ~= 1 )
    %if space free, leave crossing with speed 1
    if ( fp(2,1) == 1 )
        fp_next(2,1) = 0.4;
        fpspeed_next(2,1) = 1;
    %if space not free, stay
    else
        plocal_next(3,1) = plocal(3,1);
        pspeedlocal_next(3,1) = 0;
        camelocal_next(3,1) = camelocal(3,1);
    end
end

%car leaving to the bottom
if ( plocal(6,3) ~= 1 )
    %if space free, leave crossing with speed 1
    if ( fp(3,1) == 1 )
        fp_next(3,1) = 0.4;
        fpspeed_next(3,1) = 1;
    %if space not free, stay
    else
        plocal_next(6,3) = plocal(6,3);
        pspeedlocal_next(6,3) = 0;
        camelocal_next(6,3) = camelocal(6,3);
    end
end

%car leaving to the bottom
if ( plocal(4,6) ~= 1 )
    %if space free, leave crossing with speed 1
    if ( fp(4,1) == 1 )
        fp_next(4,1) = 0.4;
        fpspeed_next(4,1) = 1;
    %if space not free, stay
    else
        plocal_next(4,6) = plocal(4,6);
        pspeedlocal_next(4,6) = 0;
        camelocal_next(4,6) = camelocal(4,6);
    end
end
                
end