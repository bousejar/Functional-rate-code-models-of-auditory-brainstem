function createDoubleArrow(par, curFig)
%% Creates doubleArrow with circle in the center
%%  input parameters:      par
                                %par.center
                                %par.circRad
                                %par.arLength
                                %par.length
                                %par.axLength
                                %par.verical
%%  Author:     Jaroslav Bouse, bousejar@gmail.com



color = [0.4 0.4 0.4];
% color = [ 0 0 0]; 


x0 = par.center(1);
y0 = par.center(2);
rad = par.circRad;
xLen = par.axLength(1);
yLen = par.axLength(2);
arLength = par.arLength; 
lenRatio = yLen./xLen;

%% create ellipse first

a=rad/lenRatio; % horizontal radius
b=rad; % vertical radius
t=-pi:0.01:pi;
x=x0+a*cos(t);
y=y0+b*sin(t);

plot(curFig,x,y,'color',color, 'LineWidth',1)



%% create arrows
ha1 = annotation('arrow');  % store the arrow information in ha
ha1.Parent = curFig;           % associate the arrow the the current axes

ha2 = annotation('arrow');  % store the arrow information in ha
ha2.Parent = curFig;           % associate the arrow the the current axes
ha1.Color = color;
ha2.Color = color;
if par.vertical 
    upY = y0+b;
    doY = y0-b;
    ha1.X = [x0 x0];
    ha1.Y = [upY upY + arLength];
    ha2.X = [x0 x0];
    ha2.Y = [doY doY - arLength];     
else
    
    leX = x0-a;
    riX = x0+a;
    
    arLength = arLength/lenRatio;
    
    ha1.X = [leX leX- arLength];
    ha1.Y = [y0 y0];
    ha2.X = [riX riX + arLength];
    ha2.Y = [y0 y0];
    
    
end;
ha1.LineWidth  = 1;          % make the arrow bolder for the picture
ha2.LineWidth =1;


%% add text if par exist
blankSpace = 0.3;

if isfield(par,'str1') && isfield(par,'str2')
    if par.vertical
       y1 = ha1.Y(2) + blankSpace;
       x1 = x0-a;
       text(x1,y1,par.str1,'rotation', 90,'HorizontalAlignment','left', 'color', color)
       y2 = ha2.Y(2) - blankSpace;
       x2 = x0-a;
       text(x2,y2,par.str2,'rotation', 90,'HorizontalAlignment','right','color', color)
       
    else
        x1 = ha1.X(2) - blankSpace/lenRatio;
        y1 = y0+b/lenRatio;
        text(x1,y1,par.str1,'HorizontalAlignment','right','color', color)
        
        x2 = ha2.X(2) + blankSpace/lenRatio;
        y2 = y0+b/lenRatio;
        text(x2,y2,par.str2,'HorizontalAlignment','left','color', color)
        
    end;
    
    
    
    
end;




% ha1.HeadWidth  = 30;
% ha1.HeadLength = 30;






