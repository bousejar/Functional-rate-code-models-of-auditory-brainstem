function plotPureTone(latAllMso,freqListMso, latAllLso,freqListLso, plotIpd, plotIld)
%% PLOT: Lateralization of pure tones with ITD or ILD 
%% Author:     Jaroslav Bouse, bousejar@gmail.com
% plotIld = 1;
% plotIpd = 1;
freqListMso = [0.2 0.5 0.75 1 1.5].*1e3;

freqListLso = [0.2 0.5 1 2 5].*1e3;
% plot font settings
legF = 12;
labF = 14;
corF = 12;
arF = 11;
par.fontSize = arF;

% figure settings
plotheight=21;
plotwidth=17.550;
subplotsx=2;
subplotsy=3;
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

msoAxis = [0 12.6  -12.5 12.5 ];
lsoAxis = [0 13.6  -12.5 12.5 ];


% double arrow settings
% vertical double arrow
parMsoV.center = [0.5 0 ];
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
parLsoH.center = [7 11.5 ];
parLsoH.circRad = 0.3;
parLsoH.arLength =2;
parLsoH.vertical = 0;
parLsoH.str1 = 'left stronger';
parLsoH.str2 = 'right stronger';



panelNames = ['A','B','C','D','E','F'];


% load subjective data
load subResPureToneIpd % pure tone Ipd
load subResPureToneIld % pure tone Ild



%setting the Matlab figure

%%  calculate axes

sub_pos =calculateAxes (plotwidth,plotheight,leftedge, rightedge, subplotsx, subplotsy, topedge, bottomedge,spacex,spacey);




if plotIpd
    f=figure('visible','on','Name','Fig. 6 Lateralization experiment with pure tones with IPDs','NumberTitle','off');
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
            %% 200Hz
            if x==1 && y ==3
                dataIndex = 1;
                % plot subjective data
                plot(subPureToneIpd.resp(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                hold on;
                % plot simulated data
                plot(10*latAllMso(:,dataIndex), simLine,'Marker', simSymbol, 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor)
                %% Print text
                str1 = ['$f=',num2str(freqListMso(dataIndex)),'$ Hz'];
                text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                %             %% calculate and render  pearson correlation coeficient
                %             [rMso pMso] = corr(L',10*out, 'type', 'Pearson');
                %             RMSE = sqrt( mean( (L-10*out').^2));
                %             rString = ['r = ',num2str(rMso,'%0.4f')];
                %             pString = ['p = ',num2str(pMso,'%0.2e')];
                %             rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                %             comb = cell(2,1);
                %             comb{1} = rString;
                %             comb{2} = pString;
                %             comb{3} = rmseString;
                
                %             text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                %% Panel NAME
                text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                %% 500 Hz
            elseif x==1 && y==2
                dataIndex = 2;
                % plot subjective data
                plot(subPureToneIpd.resp(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                hold on;
                % plot simulated data
                plot(10*latAllMso(:,dataIndex), simLine,'Marker', simSymbol, 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor)
                hold on;
                %% Print text
                str1 = ['$f=',num2str(freqListMso(dataIndex)),'$ Hz'];
                text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                %             %% calculate and render  pearson correlation coeficient
                %             [rMso pMso] = corr(L',10*out, 'type', 'Pearson');
                %             RMSE = sqrt( mean( (L-10*out').^2));
                %             rString = ['r = ',num2str(rMso,'%0.4f')];
                %             pString = ['p = ',num2str(pMso,'%0.2e')];
                %             rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                %             comb = cell(2,1);
                %             comb{1} = rString;
                %             comb{2} = pString;
                %             comb{3} = rmseString;
                
                %             text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                %% Panel NAME
                text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                %% 750 Hz
            elseif x==1 && y==1
                dataIndex = 3;
                % plot subjective data
                plot(subPureToneIpd.resp(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                hold on;
                % plot simulated data
                plot(10*latAllMso(:,dataIndex), simLine,'Marker', simSymbol, 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor)
                %% Print text
                str1 = ['$f=',num2str(freqListMso(dataIndex)),'$ Hz'];
                text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                %             %% calculate and render  pearson correlation coeficient
                %             [rMso pMso] = corr(L',10*out, 'type', 'Pearson');
                %             RMSE = sqrt( mean( (L-10*out').^2));
                %             rString = ['r = ',num2str(rMso,'%0.4f')];
                %             pString = ['p = ',num2str(pMso,'%0.2e')];
                %             rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                %             comb = cell(2,1);
                %             comb{1} = rString;
                %             comb{2} = pString;
                %             comb{3} = rmseString;
                
                %             text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                %% Panel NAME
                text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                %% 1000 Hz
            elseif x==2 && y==3
                dataIndex = 4;
                % plot subjective data
                plot(subPureToneIpd.resp(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                hold on;
                % plot simulated data
                plot(10*latAllMso(:,dataIndex), simLine,'Marker', simSymbol, 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor)
                %% Print text
                str1 = ['$f=',num2str(freqListMso(dataIndex)),'$ Hz'];
                text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                %             %% calculate and render  pearson correlation coeficient
                %             [rMso pMso] = corr(L',10*out, 'type', 'Pearson');
                %             RMSE = sqrt( mean( (L-10*out').^2));
                %             rString = ['r = ',num2str(rMso,'%0.4f')];
                %             pString = ['p = ',num2str(pMso,'%0.2e')];
                %             rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                %             comb = cell(2,1);
                %             comb{1} = rString;
                %             comb{2} = pString;
                %             comb{3} = rmseString;
                
                %             text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                %% Panel NAME
                text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                %% 1500 hz
            elseif x==2 && y==2
                dataIndex = 5;
                % plot subjective data
                plot(subPureToneIpd.resp(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                hold on;
                % plot simulated data
                plot(10*latAllMso(:,dataIndex), simLine,'Marker', simSymbol, 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor)
                %% Print text
                str1 = ['$f=',num2str(freqListMso(dataIndex)),'$ Hz'];
                text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                %             %% calculate and render  pearson correlation coeficient
                %             [rMso pMso] = corr(L',10*out, 'type', 'Pearson');
                %             RMSE = sqrt( mean( (L-10*out').^2));
                %             rString = ['r = ',num2str(rMso,'%0.4f')];
                %             pString = ['p = ',num2str(pMso,'%0.2e')];
                %             rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                %             comb = cell(2,1);
                %             comb{1} = rString;
                %             comb{2} = pString;
                %             comb{3} = rmseString;
                
                %             text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                %% Panel NAME
                text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
            elseif    x==2 &&y==1
                set(ax,'visible', 'off')
                
            end
            if x~=2||y~=1
                hold on;
                %% plot horizontal line
                lin = zeros(1,17);
                h =  plot(-1:15, lin, 'linewidth', plotLineWidth);
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
                str = {'subj. (Yost81)', 'MSO model'};
                legendflex(str, 'ref', gca, 'anchor', [5 5], 'buffer', [-3 5], 'box', 'off','fontsize',legF);
                %% calculate and render  pearson correlation coeficient
                [rMso pMso] = corr(subPureToneIpd.resp(:,dataIndex),10*latAllMso(:,dataIndex), 'type', 'Pearson');
                RMSE = sqrt( mean( (subPureToneIpd.resp(:,dataIndex)-10*latAllMso(:,dataIndex)).^2));
                rString = ['r = ',num2str(rMso,'%0.4f')];
                pString = ['p = ',num2str(pMso,'%0.2e')];
                rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                comb = cell(2,1);
                comb{1} = rString;
                comb{2} = pString;
                comb{3} = rmseString;
                
                text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');                
            end
            %% Set visible tics on the plot
            
            set(gca,'xtick',[0,2,4,6, 8, 10, 12])
            
            if y>1 &&x==1 || y>2&&x==2
                set(ax,'xticklabel',[])
            elseif y==1 || (y==2&&x==2)
                set(gca,'xtick',[2,4,6, 8, 10, 12],'xticklabel',{-120 -60  0 60 120 180 });
                xlabel('Interaural phase difference (°)','fontsize', labF);
            end
            
            if x>1
                set(ax,'yticklabel',[]);
            else
                ylabel('Lateral position (-)','fontsize', labF)
            end
            
            
            
            
            
            
            
            
        end
    end
    %   set(findall(gcf,'-property','FontName'),'FontName','HelveticaNeueLT Com 57 Cn' )
    pu = get(gcf,'PaperUnits');
    pp = get(gcf,'PaperPosition');
    set(gcf,'Units',pu,'Position',pp)
    set(gcf,'PaperPositionMode', 'auto')
end

if plotIld
    f=figure('visible','on','Name','Fig. 7  Lateralization experiment with pure tones with ILDs','NumberTitle','off');
    clf(f);
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [plotwidth plotheight]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 plotwidth plotheight]);
    
    
    for x=1:subplotsx
        for y=1:subplotsy
            ax=axes('position',sub_pos{x,y},'XGrid','off','XMinorGrid','off','FontSize',fontsize,'Box','on','Layer','top');
            %% 200Hz
            if x==1 && y ==3
                dataIndex = 1;
                % plot subjective data
                plot(subPureToneIld.resp(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                hold on;
                % plot simulated data
                plot(10*latAllLso(:,dataIndex), simLine,'Marker', '^', 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor)
                %% Print text
                str1 = ['$f=',num2str(freqListLso(dataIndex)),'$ Hz'];
                text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                %             %% calculate and render  pearson correlation coeficient
                %             [rMso pMso] = corr(L',10*out, 'type', 'Pearson');
                %             RMSE = sqrt( mean( (L-10*out').^2));
                %             rString = ['r = ',num2str(rMso,'%0.4f')];
                %             pString = ['p = ',num2str(pMso,'%0.2e')];
                %             rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                %             comb = cell(2,1);
                %             comb{1} = rString;
                %             comb{2} = pString;
                %             comb{3} = rmseString;
                
                %             text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                %% Panel NAME
                text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                %% 500 Hz
            elseif x==1 && y==2
                dataIndex = 2;
                % plot subjective data
                plot(subPureToneIld.resp(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                hold on;
                % plot simulated data
                plot(10*latAllLso(:,dataIndex), simLine,'Marker', '^', 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor)
                hold on;
                %% Print text
                str1 = ['$f=',num2str(freqListLso(dataIndex)),'$ Hz'];
                text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                %             %% calculate and render  pearson correlation coeficient
                %             [rMso pMso] = corr(L',10*out, 'type', 'Pearson');
                %             RMSE = sqrt( mean( (L-10*out').^2));
                %             rString = ['r = ',num2str(rMso,'%0.4f')];
                %             pString = ['p = ',num2str(pMso,'%0.2e')];
                %             rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                %             comb = cell(2,1);
                %             comb{1} = rString;
                %             comb{2} = pString;
                %             comb{3} = rmseString;
                
                %             text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                %% Panel NAME
                text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                %% 1000 Hz
            elseif x==1 && y==1
                dataIndex = 3;
                % plot subjective data
                plot(subPureToneIld.resp(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                hold on;
                % plot simulated data
                plot(10*latAllLso(:,dataIndex), simLine,'Marker', '^', 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor)
                %% Print text
                str1 = ['$f=',num2str(freqListLso(dataIndex)),'$ Hz'];
                text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                %             %% calculate and render  pearson correlation coeficient
                %             [rMso pMso] = corr(L',10*out, 'type', 'Pearson');
                %             RMSE = sqrt( mean( (L-10*out').^2));
                %             rString = ['r = ',num2str(rMso,'%0.4f')];
                %             pString = ['p = ',num2str(pMso,'%0.2e')];
                %             rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                %             comb = cell(2,1);
                %             comb{1} = rString;
                %             comb{2} = pString;
                %             comb{3} = rmseString;
                
                %             text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                %% Panel NAME
                text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                %% 2000 Hz
            elseif x==2 && y==3
                dataIndex = 4;
                % plot subjective data
                plot(subPureToneIld.resp(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                hold on;
                % plot simulated data
                plot(10*latAllLso(:,dataIndex), simLine,'Marker', '^', 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor)
                %% Print text
                str1 = ['$f=',num2str(freqListLso(dataIndex)),'$ Hz'];
                text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                %             %% calculate and render  pearson correlation coeficient
                %             [rMso pMso] = corr(L',10*out, 'type', 'Pearson');
                %             RMSE = sqrt( mean( (L-10*out').^2));
                %             rString = ['r = ',num2str(rMso,'%0.4f')];
                %             pString = ['p = ',num2str(pMso,'%0.2e')];
                %             rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                %             comb = cell(2,1);
                %             comb{1} = rString;
                %             comb{2} = pString;
                %             comb{3} = rmseString;
                
                %             text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                %% Panel NAME
                text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                %% 5000 hz
            elseif x==2 && y==2
                dataIndex = 5;
                % plot subjective data
                plot(subPureToneIld.resp(:,dataIndex), ':go','color',[0 0 0], 'MarkerSize',6, 'LineWidth',1.5);
                hold on;
                % plot simulated data
                plot(10*latAllLso(:,dataIndex), simLine,'Marker', '^', 'MarkerSize',markerSize, 'LineWidth',lineWidth,'color',simColor, 'MarkerFaceColor', simColor)
                %% Print text
                str1 = ['$f=',num2str(freqListLso(dataIndex)),'$ Hz'];
                text(1.5,8,str1, 'interpreter', 'latex', 'fontSize', corF,'HorizontalAlignment','left');
                %             %% calculate and render  pearson correlation coeficient
                %             [rMso pMso] = corr(L',10*out, 'type', 'Pearson');
                %             RMSE = sqrt( mean( (L-10*out').^2));
                %             rString = ['r = ',num2str(rMso,'%0.4f')];
                %             pString = ['p = ',num2str(pMso,'%0.2e')];
                %             rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                %             comb = cell(2,1);
                %             comb{1} = rString;
                %             comb{2} = pString;
                %             comb{3} = rmseString;
                
                %             text(8,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                %% Panel NAME
                text(0.2,10, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
            elseif    x==2 &&y==1
                set(ax,'visible', 'off')
                
            end
            if x~=2||y~=1
                hold on;
                %% plot horizontal line
                lin = zeros(1,17);
                h =  plot(-1:15, lin, 'linewidth', plotLineWidth);
                set(h, 'color', plotLineColor);
                grid on;
                %% plot vertical line
                hold on;
                line([7 7], [-12.5 12.5], [0 0], 'LineWidth',plotLineWidth,'color',plotLineColor);
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
                str = {'subj. (Yost81)', 'LSO model'};
                legendflex(str, 'ref', gca, 'anchor', [5 5], 'buffer', [-3 5], 'box', 'off','fontsize',legF);
                %% calculate and render  pearson correlation coeficient
                [rLso pLso] = corr(subPureToneIld.resp(:,dataIndex),10*latAllLso(:,dataIndex), 'type', 'Pearson');
                RMSE = sqrt( mean( (subPureToneIld.resp(:,dataIndex)-10*latAllLso(:,dataIndex)).^2));
                rString = ['r = ',num2str(rLso,'%0.4f')];
                pString = ['p = ',num2str(pLso,'%0.2e')];
                rmseString = ['RMSE = ',num2str(RMSE,'%0.2f')];
                
                comb = cell(2,1);
                comb{1} = rString;
                comb{2} = pString;
                comb{3} = rmseString;
                
                text(8.7,-4,comb,'interpreter', 'latex','fontSize', corF,'HorizontalAlignment','left');
                
                
            end
            %% Set visible tics on the plot
            
            set(gca,'xtick',[0,2,4,6, 8, 10, 12])
            
            if y>1 &&x==1 || y>2&&x==2
                set(ax,'xticklabel',[])
            elseif y==1 || (y==2&&x==2)
                set(gca,'xtick',[1,3,5, 7, 9, 11,13],'xticklabel',{-18 -12 -6  0 6 12 18 });
                xlabel('Interaural level difference (dB)','fontsize', labF);
            end
            
            if x>1
                set(ax,'yticklabel',[]);
            else
                ylabel('Lateral position (-)','fontsize', labF)
            end
            
            
            
            
            
            
            
            
        end
    end
    pu = get(gcf,'PaperUnits');
    pp = get(gcf,'PaperPosition');
    set(gcf,'Units',pu,'Position',pp)
    set(gcf,'PaperPositionMode', 'auto')
end


