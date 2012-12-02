function [cNew,dNew] = connection(aOld,bOld,cOld,posNew,m,n,length)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CONNECTION Deside to which street a certain street connects to
%
%INPUT:
%AOLD column index of intersection
%BOLD, row index of intersection
%COLD, column index in t of old position
%posNEW, position in new street
%M, number of columns in city map
%N, number of rows in city map
%LENGTH, Length of a street
%
%OUTPUT:
%CNEW, Column index in t of new position
%DNEW, Row index in t of new position
%
%A project by Marcel Arikan, Nuhro Ego and Ralf Kohrt in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Fall 2012
%Matlab code is based on code from Bastian Buecheler and Tony Wood in the GeSS course "Modelling
%and Simulation of Social Systems with MATLAB" at ETH Zurich.
%Spring 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%street heading up from intersection 
if ( mod(cOld,4) == 1 )
    %if there is a intersections above, connect to it
    if ( aOld > 1)
        cNew = (aOld - 2) * 4 + 3;
        dNew = (bOld - 1) * length + posNew;
    %otherwise connect to other side of map
    else
        cNew = (m - 1) * 4 + 3;
        dNew = (bOld - 1) * length + posNew;
    end
end

%street heading left from intersection
if ( mod(cOld,4) == 2 )
    %if there is a intersection to the left, connect to it
    if ( bOld > 1 )
        cNew = aOld * 4;
        dNew = (bOld - 2) * length + posNew;
    %otherwise connect to other side of map
    else
        cNew = aOld * 4;
        dNew = (n - 1) * length + posNew;
    end
end

%street heading down from intersection                             
if ( mod(cOld,4) == 3 )                                    
    %if there is a intersection below, connect to it                                        
    if ( aOld < m )                                        
        cNew = aOld * 4 + 1;                                        
        dNew = (bOld - 1) * length + posNew;                                    
    %otherwise connect to other side of map                                    
    else        
        cNew = 1;                                        
        dNew = (bOld - 1) * length + posNew;                                    
    end    
end

%street heading right from intersection                                
if ( mod(cOld,4) == 0 )                                    
    %if there is a intersection to the right, connect to it                                    
    if ( bOld < n )                                        
        cNew = (aOld - 1) * 4 + 2;                                                                               
        dNew = bOld * length + posNew;                                    
    %otherwise connect to other side of map                                    
    else        
        cNew = (aOld - 1) * 4 + 2;                                        
        dNew = posNew;                                    
    end    
end