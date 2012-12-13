function [ ni, nj ] = crosslight_next_ij(i, j, direction,EXIT_LEFT ,EXIT_RIGHT ,EXIT_STRAIGHT_TOP ,EXIT_STRAIGHT_LEFT ,EXIT_STRAIGHT_BOTTOM,EXIT_STRAIGHT_RIGHT)
%crosslight_next_ij this function will return the next value for i and j
%which a car with a given direction and i j coordinates will have

switch(direction)
    case EXIT_LEFT
        if(i == 1 && j == 3)
            ni = 2;
            nj = 3;
        elseif(i == 2 && j == 3)
            ni = 3;
            nj = 4;
        elseif(i == 3 && j == 4)
            ni = 4;
            nj = 5;
        elseif(i == 4 && j == 5)
            ni = 5;
            nj = 6;
        elseif(i == 5 && j == 6)
            ni = -4;
            nj = 1;
        elseif(i == 4 && j == 1)
            ni = 4;
            nj = 2;
        elseif(i == 4 && j == 2)
            ni = 3;
            nj = 3;
        elseif(i == 3 && j == 3)
            ni = 2;
            nj = 4;
        elseif(i == 2 && j == 4)
            ni = 1;
            nj = 5;
        elseif(i == 1 && j == 5)
            ni = -1;
            nj = 1;
        elseif(i == 6 && j == 4)
            ni = 5;
            nj = 4;
        elseif(i == 5 && j == 4)
            ni = 4;
            nj = 3;
        elseif(i == 4 && j == 3)
            ni = 3;
            nj = 2;
        elseif(i == 3 && j == 2)
            ni = 2;
            nj = 1;
        elseif(i == 2 && j == 1)
            ni = -2;
            nj = 1;
        elseif(i == 3 && j == 6)
            ni = 3;
            nj = 5;
        elseif(i == 3 && j == 5)
            ni = 4;
            nj = 4;
        elseif(i == 4 && j == 4)
            ni = 5;
            nj = 3;
        elseif(i == 5 && j == 3)
            ni = 6;
            nj = 2;
        elseif(i == 6 && j == 2)
            ni = -3;
            nj = 1;
        elseif(i < 0)   %here I assume the car is in the last position of the inmwards street
            if(i == -1)
                ni = 1;
                nj = 3;
            elseif(i == -2)
                ni = 4;
                nj = 1;
            elseif(i == -3)
                ni = 6;
                nj = 4;
            elseif(i == -4)
                ni = 3;
                nj = 6;
            end
        end
    case EXIT_RIGHT
        if(i == 1)
            if(j == 1)
                ni = -2;
                nj = 1;
            else
                ni = -1;
                nj = 1;
            end
        elseif(i == 6)
            if(j == 1)
                ni = -3;
                nj = 1;
            else
                ni = -4;
                nj = 1;
            end
        elseif(i == -1)
             ni = 1;
             nj = 1;
        elseif(i == -2)
             ni = 6;
             nj = 1;
        elseif(i == -3)
             ni = 6;
             nj = 6;
        elseif(i == -4)
             ni = 1;
             nj = 6;
        end
    case EXIT_STRAIGHT_TOP
        if(i > 0)
            nj = j;
            ni = i-1;
            if(ni < 1)
                ni = -EXIT_STRAIGHT_BOTTOM;
                nj = 1;
            end
        elseif(i == -EXIT_STRAIGHT_TOP)  %%check if it comes from BOTTOM
            nj = 5;
            ni = 6;
        else
            ni = i;
            nj = j+1;
        end
    case EXIT_STRAIGHT_BOTTOM
        if(i > 0)
            nj = j;
            ni = i+1;
            if(ni > 6)
                ni = -EXIT_STRAIGHT_TOP;
                nj = 1;
            end
        elseif(i == -EXIT_STRAIGHT_BOTTOM)
            nj = 2;
            ni = 1;
        else
            ni = i;
            nj = j+1;
        end
    case EXIT_STRAIGHT_LEFT
        if(i > 0)
            nj = j-1;
            ni = i;
            if(nj < 1)
                ni = -2;
                nj = 1;
            end
        elseif(i == -4)
            nj = 6;
            ni = 2;
        else
            ni = i;
            nj = j+1;
        end
    case EXIT_STRAIGHT_RIGHT
        if(i > 0)
            nj = j+1;
            ni = i;
            if(nj > 6)
                ni = -4;
                nj = 1;
            end
        elseif(i == -2)
            nj = 1;
            ni = 5;
        else
            ni = i;
            nj = j+1;
        end
    otherwise
        display(direction);
        display(i);
        display(j);
        ni = 0;
        nj = 0;
end

end

