function plotNbn(latMsoNbn, freq, latLsoNbn, plotIpd, plotIld)
%% PLOT: Lateralization of narrow band noises with ITD or ILD 
%% Author:     Jaroslav Bouse, bousejar@gmail.com

% plotIld = 1;
% plotIpd = 1;

% plot font settings
legF = 12;
labF = 14;
corF = 12;
arF = 11;
par.fontSize = arF;

% figure settings
plotheight=14;
plotwidth=17.550;
subplotsx=2;
subplotsy=2;
leftedge=1.2;
rightedge=0.45;
topedge=0.1;
bottomedge=1;
spacex=0.15;
spacey=0.15;
fontsize=8;


% color, linewidth and marker size settings
markerSize = 6;
lineWidth = 1.5;
subColor = [0 0 0];
subSymbol = 'o';
subLine = ':';
simColor = [0.6 0.6 0.6];
simSymbol = 'diamond';
simLine = '-';

plotLineColor = [0.5 0.5 0.5];
plotLineWidth =1;

% msoAxis = [-170 185  -12.5 12.5 ];
msoAxis = [0 12.6  -12.5 12.5 ];
lsoAxis = [-.1 15.7 -12.5 12.5 ];
% lsoAxis = [-20.5 20.5  -12.5 12.5 ];


% double arrow settings
% vertical double arrow
parMsoV.center = [0.2 0 ];
parMsoV.circRad = 0.3;
parMsoV.arLength =2;
parMsoV.str1 = 'right';
parMsoV.str2 = 'left';
parMsoV.vertical = 1;
% horizontal double arrow
parMsoH.center = [6 11.5 ];
parMsoH.circRad = 0.3;
parMsoH.arLength =2;
parMsoH.vertical = 0;
parMsoH.str1 = 'left earlier';
parMsoH.str2 = 'right earlier';


parLsoV.center = [0.5 0 ];
parLsoV.circRad = 0.3;
parLsoV.arLength =2;
parLsoV.str1 = 'right';
parLsoV.str2 = 'left';
parLsoV.vertical = 1;
% horizontal double arrow
parLsoH.center = [8 11.5 ];
parLsoH.circRad = 0.3;
parLsoH.arLength =2;
parLsoH.vertical = 0;
parLsoH.str1 = 'left stronger';
parLsoH.str2 = 'right stronger';



panelNames = ['A','B','C','D','E','F'];




% load subjective data
load subResNbnIpd % nbn Ipd
load subResNbnIld % nbn Ild
ipdList = -150:30:180;
ildList = [-20,-18:3:18,20];
freqList = [350,760];


%setting the Matlab figure

%%  calculate axes

sub_pos =calculateAxes (plotwidth,plotheight,leftedge, rightedge, subplotsx, subplotsy, topedge, bottomedge,spacex,spacey);





    f=figure('visible','on','Name','Fig. 8  Lateralization experiment with NBN with IPD or ILD','NumberTitle','off');
    clf(f);
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [plotwidth plotheight]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 plotwidth plotheight]);
    
    phase = -150:30:180;
    phase2 = -180:30:180;
    %loop to create axes
    for x=1:subplotsx
        for y=1:subplotsy
            ax=axes('position',sub_pos{x,y},'XGrid','off','XMinorGrid','off','FontSize',fontsize,'Box','on','Layer','top');
            %% 350Hz NBN ipd
            if x==1 && y ==2
                if plotIpd
                    dataIndex = 1;
                    % plot subjective data
                    errorbar([1:length(subNbnIpd.mean)],subNbnIpd.mean(:,dataIndex),subNbnIpd.std(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                    hold on;
                    % plot simulated data
                    plot([1:length(subNbnIpd.mean)],10*latMsoNbn(:,dataIndex), simLine,'Marker', simSymbol, 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor);
                    %% Print text
                    str1 = ['$f_c=',num2str(freqList(dataIndex)),'$ Hz'];
                    text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                    %% Panel NAME
                    text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                else
                    set(ax,'visible', 'off')
                end
                %% 760 Hz NBN ipd
            elseif x==1 && y==1
                if plotIpd
                    dataIndex = 2;
                    % plot subjective data
                    errorbar([1:length(subNbnIpd.mean)],subNbnIpd.mean(:,dataIndex),subNbnIpd.std(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                    hold on;
                    % plot simulated data
                    plot([1:length(subNbnIpd.mean)],10*latMsoNbn(:,dataIndex), simLine,'Marker', simSymbol, 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor);
                    hold on;
                    %% Print text
                    str1 = ['$f_c=',num2str(freqList(dataIndex)),'$ Hz'];
                    text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                    %% Panel NAME
                    text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                else
                    set(ax,'visible', 'off')
                end
                %% 350Hz NBN ild
            elseif x==2 && y ==2
                if plotIld
                    dataIndex = 1;
                    % plot subjective data
                    errorbar([1:length(subNbnIld.mean)],subNbnIld.mean(:,dataIndex),subNbnIld.std(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                    hold on;
                    % plot simulated data
                    plot([1:length(subNbnIld.mean)],10*latLsoNbn(:,dataIndex), simLine,'Marker', '^', 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor);
                    %% Print text
                    str1 = ['$f_c=',num2str(freqList(dataIndex)),'$ Hz'];
                    text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                    %% Panel NAME
                    text(0.2,10, panelNames(dataIndex+2), 'fontSize',20, 'fontWeight', 'bold')
                else
                    set(ax,'visible', 'off')
                end
                %% 760 Hz NBN ild
            elseif x==2 && y ==1
                if plotIld
                    dataIndex = 2;
                    % plot subjective data
                    errorbar([1:length(subNbnIld.mean)],subNbnIld.mean(:,dataIndex),subNbnIld.std(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                    hold on;
                    % plot simulated data
                    plot([1:length(subNbnIld.mean)],10*latLsoNbn(:,dataIndex), simLine,'Marker', '^', 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor);
                    %% Print text
                    str1 = ['$f_c=',num2str(freqList(dataIndex)),'$ Hz'];
                    text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                    %% Panel NAME
                    text(0.2,10, panelNames(dataIndex+2), 'fontSize',20, 'fontWeight', 'bold')
                else
                    set(ax,'visible', 'off')
                end
            end
            
            
            if x~=2 &&plotIpd
                hold on;
                %% plot horizontal line
                lin = zeros(1,length(-180:185));
                h =  plot(-180:185, lin, 'linewidth', plotLineWidth);
                set(h, 'color', plotLineColor);
                grid on;
                %% plot vertical line
                hold on;
                line([6 6], [-12.5 12.5], [0 0], 'LineWidth',plotLineWidth,'color',plotLineColor);
                axis(msoAxis)
                
                %% vertical double arrow
                x1 = xlim;
                y1 = ylim;
                parMsoV.axLength = [abs(x1(1)-x1(2)) abs(y1(1)-y1(2))];
                createDoubleArrow(parMsoV, gca)
                %% horizontal double arrow
                parMsoH.axLength = [abs(x1(1)-x1(2)) abs(y1(1)-y1(2))];
                createDoubleArrow(parMsoH, gca)
                %% render legend
                str = {'subjective', 'MSO model'};
%                 legend(str,'box', 'off','fontsize',legF,'location', [0.323 0.561 0.163 0.079])
%                 legendflex([t,z],str)
                legendflex(str, 'ref', gca, 'anchor', [5 5], 'buffer', [-3 5], 'box', 'off','fontsize',legF);
                %% calculate and render  pearson correlation coeficient
                [rMso pMso] = corr(subNbnIpd.mean(:,dataIndex),10*latMsoNbn(:,dataIndex), 'type', 'Pearson');
                RMSE = sqrt( mean( (subNbnIpd.mean(:,dataIndex)-10*latMsoNbn(:,dataIndex)).^2));
                rString = ['r = ',num2str(rMso,'%0.4f')];
                pString = ['p = ',num2str(pMso,'%0.2e')];
                rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                comb = cell(2,1);
                comb{1} = rString;
                comb{2} = pString;
                comb{3} = rmseString;
                text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                
                %% Set visible tics on the plot
                
                set(gca,'xtick',[1, 3, 5, 6, 7, 9, 11])
                
                if y>1 &&x==1
                    set(ax,'xticklabel',[])
                elseif y==1 &&x==1
                    set(gca,'xtick',[1, 3, 5, 6, 7, 9, 11],'xticklabel',{-150, -90, -30, 0, 30, 90, 150 });
                    xlabel('Interaural phase difference (°)','fontsize', labF);
                end
                
                if x==1
                    ylabel('Lateral position (-)','fontsize', labF)
                end
                
            end
            
            if x==2 &&plotIld
                hold on;
                %% plot horizontal line
                lin = zeros(1,17);
                h =  plot(-1:15, lin, 'linewidth', plotLineWidth);
                set(h, 'color', plotLineColor);
                grid on;
                %% plot vertical line
                hold on;
                line([8 8], [-12.5 12.5], [0 0], 'LineWidth',plotLineWidth,'color',plotLineColor);
                axis(lsoAxis)
                
                %% vertical double arrow
                x1 = xlim;
                y1 = ylim;
                parLsoV.axLength = [abs(x1(1)-x1(2)) abs(y1(1)-y1(2))];
                createDoubleArrow(parLsoV, gca)
                %% horizontal double arrow
                parLsoH.axLength = [abs(x1(1)-x1(2)) abs(y1(1)-y1(2))];
                createDoubleArrow(parLsoH, gca)
                %% render legend
                str = {'subjective', 'LSO model'};
                legendflex(str, 'ref', gca, 'anchor', [5 5], 'buffer', [-3 5], 'box', 'off','fontsize',legF);
                %% calculate and render  pearson correlation coeficient
                [rLso pLso] = corr(subNbnIld.mean(:,dataIndex),10*latLsoNbn(:,dataIndex), 'type', 'Pearson');
                RMSE = sqrt( mean( (subNbnIld.mean(:,dataIndex)-10*latLsoNbn(:,dataIndex)).^2));
                rString = ['r = ',num2str(rLso,'%0.4f')];
                pString = ['p = ',num2str(pLso,'%0.2e')];
                rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                comb = cell(2,1);
                comb{1} = rString;
                comb{2} = pString;
                comb{3} = rmseString;
                text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                
                %% Set visible tics on the plot
                
                set(gca,'xtick',[1,3,5,7,8,9,11,13,15]);
                
                if y>1 &&x==2
                    set(ax,'xticklabel',[])
                elseif y==1 &&x==2
                    set(gca,'xtick',[1,3,5,7,8,9,11,13,15],'xticklabel',{-20,-15,-9,-3,0,3,9,15,20 });
                    xlabel('Interaural level difference (dB)','fontsize', labF);
                end
                set(ax,'yticklabel',[]);
                
            end
            
            
            
            
        end
    end
    %   set(findall(gcf,'-property','FontName'),'FontName','HelveticaNeueLT Com 57 Cn' )
    pu = get(gcf,'PaperUnits');
    pp = get(gcf,'PaperPosition');
    set(gcf,'Units',pu,'Position',pp)
    set(gcf,'PaperPositionMode', 'auto')




