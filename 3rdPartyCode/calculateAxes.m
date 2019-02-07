function [sub_pos] = calculateAxes (plotwidth,plotheight,leftmargin, rightmargin, nbx, nby, topmargin, bottommargin,spacex,spacey)


subxsize=(plotwidth-leftmargin-rightmargin-spacex*(nbx-1.0))/nbx;
subysize=(plotheight-topmargin-bottommargin-spacey*(nby-1.0))/nby;

subxsize2 = subxsize;
subysize2 =  subysize;
for i=1:nbx
    for j=1:nby
        if i==1
            xfirst=leftmargin+(i-1.0)*(subxsize+spacex);
            yfirst=bottommargin+(j-1.0)*(subysize+spacey);
            positions{i,j}=[xfirst/plotwidth yfirst/plotheight subxsize2/plotwidth subysize2/plotheight];
        else
            xfirst=leftmargin+(i-1.0)*(subxsize+spacex);
            yfirst=bottommargin+(j-1.0)*(subysize+spacey);
            positions{i,j}=[xfirst/plotwidth yfirst/plotheight subxsize/plotwidth subysize/plotheight];
        end;
        %            positions{i,j}=[xfirst/plotwidth yfirst/plotheight subxsize/plotwidth subysize/plotheight];
        
    end
end

sub_pos = positions;