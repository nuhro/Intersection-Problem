function [ gap ] = crosslight_measure_gap(i, j, direction, street_crossroad, ...
    street_outwards, street_outwards_next, inwards, street_inwards, street_inwards_next, traffic_light, ...
    EXIT_LEFT,EXIT_RIGHT,EXIT_STRAIGHT_TOP,EXIT_STRAIGHT_LEFT,EXIT_STRAIGHT_BOTTOM,EXIT_STRAIGHT_RIGHT, STREET_INTERSECTION, EMPTY_STREET)
%crosslight_measure_gap this function will measure the gap to the next car
%in a crosslight

display('gap');
display(direction);
display(i);
display(j);

e = 1;
iterate = 1;
ni = i;
nj = j;
while (e <= 5 && iterate)
    if((ni < 0 && nj == STREET_INTERSECTION+1 && inwards) || ni > 0)
        [ni, nj] = crosslight_next_ij(ni, nj, direction, ...
            EXIT_LEFT,EXIT_RIGHT,EXIT_STRAIGHT_TOP,EXIT_STRAIGHT_LEFT,EXIT_STRAIGHT_BOTTOM,EXIT_STRAIGHT_RIGHT);
    else
        %ni = ni;
        nj = nj+1;
    end
    if(ni > 0)
        inwards = 0;
        if(street_crossroad(ni,nj) == EMPTY_STREET)
            e = e + 1;
        else
            iterate = 0;
        end
    else
        if(inwards)
            if(nj == STREET_INTERSECTION+1 || nj == STREET_INTERSECTION) %last or second to last field in front of intersection have to wait if traffoic light is red
                if(traffic_light && street_inwards(-ni,nj) == EMPTY_STREET && street_inwards_next(-ni,nj) == EMPTY_STREET)  %% traffic_light green and street empty
                    e = e + 1;
                else
                    iterate = 0;
                end
            else
                if(street_inwards(-ni,nj) == EMPTY_STREET && street_inwards_next(-ni,nj) == EMPTY_STREET)
                    e = e + 1;
                else
                    iterate = 0;
                end
            end       
        else
            if(street_outwards(-ni,nj) == EMPTY_STREET && street_outwards_next(-ni,nj) == EMPTY_STREET)
                e = e + 1;
            else
                iterate = 0;
            end
        end
    end     
end
gap = e - 1;

end

