function [ gap ] = measure_gap(street_inwards, street_outwards,street_length, a, b, c, d, inwards, inwards_gap, config_m, config_n, EMPTY_STREET,STREET_INTERSECTION)
%MEASURE_GAP this measures the gap to the next car
%   how big is gap (to car ahead or intersection)?


e = 0;
iterate = 1;
while (iterate )    %iterate while iterate is 1
    if(inwards)
        e = e + 1;
        iterate = e <= 5 && d + e <= b * street_length - STREET_INTERSECTION + inwards_gap && ...
        street_inwards(c,d+e) == EMPTY_STREET;              %STREET_INTERSECTION specifies the number of elements of the road inwards which will be taken care of by the crossroad/roundabout
    else
        e = e + 1;
        %if gap is bigger than distance to edge,connect
        %steets
        if ( d + e > b * street_length)
            %testing position in new street
            hh = d + e - b * street_length;
            %connect to next street
            [ec,ed]=connection(a,b,c,hh, ...
                config_m,config_n,street_length);
            while ( street_inwards(ec,ed) == EMPTY_STREET && e <= 5 )
                e = e + 1;
                %testing position in new street
                hh = d + e - b * street_length;
                %connect to next street
                [ec,ed]=connection(a,b,c,hh, ...
                    config_m,config_n,street_length);
            end
            iterate = 0;
        else
            iterate = e <= 5 && street_outwards(c,d+e) == EMPTY_STREET;    %% <= 4 b.c. it'll be 5 after this loop
        end
    end 
end
gap = e - 1;

end

