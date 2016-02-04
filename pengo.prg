program pengo;

global
struct grid[13]
    col[15];
end
mazedone=0;

private
    first=1;

begin

    set_fps(30,2);

    set_mode(224288);
    load_fpg("pengo/pengo.fpg");
    put_screen(file,1);

    loop

    for(x=0;x<13;x++)
        for(y=0;y<15;y++)
            grid[x].col[y]=1;
            if(first)
                brick(x,y);
            end
        end
    end
    first=0;
    genmaze(0,14);
    repeat
        frame;
    until(key(_space))
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


function genmaze(gx,gy)

private

    finished=0;


begin

    grid[gx].col[gy]=0;

    while(gy>=0)

        while(gx<13)

            // maze gen loop
            // check if current block is empty
            if(grid[gx].col[gy]==0)

                if(gy>0)

                    if(grid[gx].col[gy-2]==1)
                        maze2(gx,gy);
                    end

                end

                if(gy<14)

                    if(grid[gx].col[gy+2]==1)
                        maze2(gx,gy);
                    end

                end

                if(gx>0)
                    if(grid[gx-2].col[gy]==1)
                        maze2(gx,gy);
                    end
                end

                if(gx<12)
                    if(grid[gx+2].col[gy]==1)
                        maze2(gx,gy);
                    end
                end

            end

            //frame;

            gx+=2;

        end

        gx=0;
        gy-=2;

    end

end


function maze2(gx,gy)

private
    rnd=0;
begin

    repeat

        rnd=rand(0,3);

        switch(rnd)

            case 0:

                if(gy>0)

                    if(grid[gx].col[gy-2]==1)
                        grid[gx].col[gy-1]=0;
                        frame;
                        grid[gx].col[gy-2]=0;
                        frame;

                        mazedone=1;
                        gy-=2;
                    end

                end

            end

            case 1:
                if(gy<14)
                    if(grid[gx].col[gy+2]==1)
                        grid[gx].col[gy+1]=0;
                        frame;
                        grid[gx].col[gy+2]=0;
                        frame;

                        mazedone=1;
                        gy+=2;
                     end
                end

            end

            case 2:

                if(gx>0)
                    if(grid[gx-2].col[gy]==1)
                        grid[gx-1].col[gy]=0;
                        frame;
                        grid[gx-2].col[gy]=0;
                        frame;
                        mazedone=1;
                        gx-=2;

                    end
                end

            end

            case 3:

                if(gx<12)
                    if(grid[gx+2].col[gy]==1)
                        grid[gx+1].col[gy]=0;
                        frame;
                        grid[gx+2].col[gy]=0;
                        frame;
                        mazedone=1;
                        gx+=2;
                    end
                end

            end


        end

        if(mazedone && gy>0)

            if(grid[gx].col[gy-2]==1)
                mazedone=0;
            end

        end

        if(gy<14 && mazedone)

            if(grid[gx].col[gy+2]==1)
                mazedone=0;
            end

        end

        if(mazedone && gx>0)

            if(grid[gx-2].col[gy]==1)
                mazedone=0;
            end
        end

        if(gx<12)
            if(grid[gx+2].col[gy]==1)
                mazedone=0;
            end
        end


    until(mazedone);
end


