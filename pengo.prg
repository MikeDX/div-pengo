program pengo;

global
struct grid[13]
    col[15];
end


begin

    set_fps(60,2);

    set_mode(224288);
    load_fpg("pengo/pengo.fpg");
    put_screen(file,1);

    for(x=0;x<13;x++)
        for(y=0;y<15;y++)
            grid[x].col[y]=1;
            brick(x,y);
        end
    end

    genmaze(0,14);
    loop
/*
        from x = 0 to 12;
            from y = 0 to 14;
                grid[x].col[y]=rand(0,1);
            end
        end
*/
        frame;
    end

end

process brick(gx,gy);

begin

    graph=2;

    x=(gx+1)*16;
    y=8+(gy+2)*16;

    loop
        graph=2*grid[gx].col[gy];

        frame;
    end

end


function genmaze(x,y)

begin

    grid[x].col[y]=0;

end
