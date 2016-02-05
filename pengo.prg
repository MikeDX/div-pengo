program pengo_sega_1980;

global

    struct grid[13]
        col[15];
    end

    mazedone=0;
    fast=0;
    speed=-1;
    boxes=0;
    bug=0;

private

    first=1;

begin

    set_fps(60,2);
    set_mode(224288);

    load_fpg("pengo/pengo.fpg");

    put_screen(file,1);


    loop

    for(x=0;x<13;x++)
        for(y=0;y<15;y++)
            grid[x].col[y]=1;//(rand(0,2)==0);
            if(first)
                brick(x,y);
            end
        end
    end
    fast=0;


    first=0;
//    minimaze();

    genmaze(0,14);
    frame;
    screen_copy(0,file,19,0,0,224,288);

    for(x=0;x<56;x++);
        for(y=0;y<72;y++);
            map_put_pixel(file,6,x,y,0);
        end
    end

   // map_put(file,6,7,56,72);
    map_xput(file,6,19,28,36,0,25,0);
    //graph=6;
    //x=112;
    //y=144;

    //debug;

    pengo(6,8);

    frame;

    snowbee(0,0);
    snowbee(0,14);
    snowbee(12,0);
    snowbee(12,14);


    repeat
        frame;
    until(scan_code!=0)

    delete_draw(all_drawing);

    signal(type pengo, s_kill);
    signal(type snowbee, s_kill);

    if(key(_1))
        speed=100;
    end

    if(key(_2))
        speed=200;
    end

    if(key(_3))
        speed=300;
    end

    if(key(_wave))
        speed=50;
    end

    if(key(_space))
        speed=200;
    end

    if(key(_enter))
        fast=1;
        speed=0;
    end

    end


end

process minimaze()

begin

    x=104;
    y=144;
    graph=18;
    size=1600;
    flags=4;

    loop
        frame;
    end
end

process brick(gx,gy);

begin

    //graph=2;

    x=(gx+1)*16;
    y=8+(gy+2)*16;

    loop
        //if(mazedone)
        if(graph==0 && grid[gx].col[gy])
            graph=2;
            map_put_pixel(file,18,gx,gy,56);
            boxes++;
        end

        if(graph==2 && grid[gx].col[gy]==0)
            graph=0;
            map_put_pixel(file,18,gx,gy,0);
            boxes--;
        end
        //    graph=2*grid[gx].col[gy];
       // end
        //if(graph==2 && !gx&1 && !gy&1)
        //    graph++;
        //end

        frame;
    end

end


process pengo(gx,gy)

begin

    graph=4;
    x=(gx+1)*16;
    y=8+(gy+2)*16;



    loop
        graph=4+(graph==4);

        frame(1000);

    end

end
process snowbee(gx,gy)

private
    target=0;
    targetx=0;
    targety=0;

    dir=1;
    map_points;
    struct points[100]
        x;
        y;
    end
    index;
    anim=0;
    fangle=0;
    tx=0;
    ty=0;
    lastx=0;

begin

    //write_int(0,80,10,0,&targetx);
    //write_int(0,96,10,0,&targety);
/*    write_int(0,80,16,0,&x);
    write_int(0,96,16,0,&y);
*/
    graph=10;
    x=(gx+1)*16;
    y=8+(gy+2)*16;

    tx=x;
    ty=y;

    target=get_id(type pengo);

    if(target)
        targetx=target.x;
        targety=target.y;
    end

    loop
        if(tx==x && ty==y)
            x=(gx+1)*16;
            y=8+(gy+2)*16;
        end

        anim++;

        if(y==ty && x==tx)
            //debug;

            map_points = path_find(0,file,6,4,targetx,targety, &points, sizeof(points));

            if(map_points>0)
             //   debug;
                //fangle=fget_angle(x,y,points[0].x,points[0].y);
                //xadvance(fangle,4);

                //if(lastx==0)


                if(lastx==0)
                // &&
                   // if(points[0].x%16-x%16) < points[0].y%16-y%16)

                    if(points[0].x>x && gx<12)
                        if(grid[gx+1].col[gy]==0)
                            tx=x+16;
                        end
                    end

                    if(points[0].x<x && gx>0)
                        if(grid[gx-1].col[gy]==0)
                            tx=x-16;
                        end
                    end
                    lastx=1;

                else

                    if(points[0].y>y && gy<14)
                        if(grid[gx].col[gy+1]==0)
                            ty=y+16;
                        end
                    end

                    if(points[0].y<y && gy>0)
                        if(grid[gx].col[gy-1]==0)
                            ty=y-16;
                        end
                    end
                    lastx=0;
                end
            else

                tx=x;
                ty=y;

            end
        end


        if(tx<x)
            x-=1;
            dir=1;
        end

        if(tx>x)
            x+=1;
            dir=3;
        end

        if(ty>y)
            y+=1;
            dir=0;
        end

        if(ty<y)
            y-=1;
            dir=2;
        end

        if(ty==y && tx==x)
            gx=(x/16)-1;
            gy=(y/16)-2;
            if(rand(0,360)==360 || (x==targetx && y==targety) )
                //debug;
                targetx=(   (rand(0,1)*12)  +1) *16;
                targety=8+( (rand(0,1)*14) +2) *16;

            end

        end

        graph=(10+dir*2)+((anim%20)<10);


        frame;


    end

end



function genmaze(gx,gy)

private

    finished=0;
    loops=0;


begin

    //grid[rand(0,1)*12].col[rand(0,1)*14]=0;
    grid[gx].col[gy]=0;
    ///from loops = 0 to 3;
    //gy=14;
    //gx=0;

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

            gx+=2;

        end

        gx=0;
        gy-=2;

    end
    //end

end


function maze2(gx,gy)

private
    rnd=0;

begin

    repeat
        x=(gx+1)*16;
        y=8+(gy+2)*16;
        graph=3;

        rnd=rand(0,3);

        switch(rnd)

            case 0:

                if(gy>0)

                    if(grid[gx].col[gy-2]==1)
                        grid[gx].col[gy-1]=0;
                        y-=16;
                        if(!fast) frame(speed); end

                        grid[gx].col[gy-2]=0;
                        gy-=2;

                        if(!fast) frame(speed); end

                        mazedone=1;
                    end

                end

            end

            case 1:
                if(gy<14)
                    if(grid[gx].col[gy+2]==1)
                        grid[gx].col[gy+1]=0;
                        y+=16;
                        if(!fast) frame(speed); end

                        grid[gx].col[gy+2]=0;
                        if(!fast) frame(speed); end

                        mazedone=1;
                        gy+=2;
                     end
                end

            end

            case 2:

                if(gx>0)
                    if(grid[gx-2].col[gy]==1)
                        grid[gx-1].col[gy]=0;
                        x-=16;
                        if(!fast) frame(speed); end

                        grid[gx-2].col[gy]=0;
                        if(!fast) frame(speed); end

                        mazedone=1;
                        gx-=2;

                    end
                end

            end

            case 3:

                if(gx<12)
                    if(grid[gx+2].col[gy]==1)
                        grid[gx+1].col[gy]=0;
                        x+=16;
                        if(!fast) frame(speed); end

                        grid[gx+2].col[gy]=0;
                        if(!fast) frame(speed); end

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

        if(mazedone && gy<14)

            if(grid[gx].col[gy+2]==1)
                mazedone=0;
            end

        end

        if(mazedone && gx>0)

            if(grid[gx-2].col[gy]==1)
                mazedone=0;
            end
        end

        // replicate original pengo maze gen bug
        if(!bug)
            if(mazedone && gx<12)
                if(grid[gx+2].col[gy]==1)
                    mazedone=0;
                end
            end
        else
            if(mazedone && gy<14)

                if(grid[gx].col[gy+2]==1)
                    mazedone=0;
                end

            end
        end



    until(mazedone);
end


