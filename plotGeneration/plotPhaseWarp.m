function plotPhaseWarp( phaseWarpTime,inPar, phaseWarpModThreshold,modFreq,plotTime,plotMod)
%% PLOT: Transient response to phase warp and phase warp modulation discrimination 
%% Author:     Jaroslav Bouse, bousejar@gmail.com
% plot font settings
legF = 10;
labF = 14;
corF = 12;
arF = 11;
par.fontSize = arF;

% figure settings
plotheight=7;
plotwidth=17.550;
subplotsx=2;
subplotsy=1;
leftedge=1.2;
rightedge=1.2;
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

panelNames = ['A','B','C','D','E','F'];


% load subjective data
load('subResPhaseWarp.mat')

%setting the Matlab figure



%%  calculate axes

sub_pos =calculateAxes (plotwidth,plotheight,leftedge, rightedge, subplotsx, subplotsy, topedge, bottomedge,spacex,spacey);





f=figure('visible','on','Name','Fig. 10  (A) Transient responses to a phase-warp stimulus with the beat frequency 8 Hz, (B) Phase-warp modulation threshold','NumberTitle','off');
clf(f);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 plotwidth plotheight]);


%loop to create axes
for x=1:subplotsx
    for y=1:subplotsy
        ax=axes('position',sub_pos{x,y},'XGrid','off','XMinorGrid','off','FontSize',fontsize,'Box','on','Layer','top');
        %% Realtime response of MSO and LSO to phase warp (8 Hz beat frequency) stimuli
        if x==1 && y ==1
            if plotTime
                % calculate time axis
                t = 0: 1/inPar.fs: length(phaseWarpTime)/inPar.fs - 1/inPar.fs;
                plot(t,10*phaseWarpTime(:,1), simLine,  'LineWidth',lineWidth,'color',simColor );
                hold on;
                plot(t,10*phaseWarpTime(:,2), simLine, 'LineWidth',lineWidth,'color',[0 0 0]);
                
                
                
                grid on;
                axis([-0.05 t(end) -12 12 ] )
                
                yAx =[-10 -6 -3 0 3 6 10 ];
                set(gca, 'ytick',yAx);
                set(gca,'ytickLabel', yAx)
                %% vertical double arrow
                
                
                par.center = [-0.02 0 ];
                par.circRad = 0.3;
                par.arLength =2;
                x1 = 0.5*xlim;
                y1 = ylim;
                par.axLength = [abs(x1(1)-x1(2)) abs(y1(1)-y1(2))];
                
                par.vertical = 1;
                par.str1 = 'right';
                par.str2 = 'left';
                createDoubleArrow(par, gca)
                
                %% horizontal line
                lin = zeros(1,17);
                hold on;
                 x=plot(-1:15, lin,'-.' , 'linewidth', 1);
                set(x, 'color', [0.5 0.5 0.5]);
                uistack(x,'bottom')
                
                xlabel('Time (s)', 'fontSize',labF)
                ylabel('Lateral position (-)', 'fontSize',labF)
                %% panel name
                text(0, 9.5, 'A', 'fontSize',20, 'fontWeight', 'bold')
                h =legend('MSO model', 'LSO model','location', 'southEast');
                
                set(h, 'box','off','fontSize',legF)
            else
                set(ax,'visible', 'off')
                
            end
            
            
            
        elseif x==2 && y==1
            if plotMod.run
                
                if plotMod.doMso
                    errorbar(modFreq(1:3),mean(phaseWarpModThreshold(:,1:3)),std(phaseWarpModThreshold(:,1:3)),'LineWidth',1.5, 'Marker', 'diamond','MarkerSize',6, 'color', [0.6 0.6 0.6],'MarkerFaceColor', [0.6 0.6 0.6])  ;
                    
                    hold on;
                end
                
                if plotMod.doLso
                    errorbar(modFreq(4:end),mean(phaseWarpModThreshold(:,4:end)),std(phaseWarpModThreshold(:,4:end)),'LineWidth',1.5, 'Marker', '^','MarkerSize',6, 'color', [0.4 0.4 0.4],'MarkerFaceColor', [0.4 0.4 0.4])  ;
                end
                
                hold on;
                
                errorbar(modFreq(1:3),subPhaseWarp.mean,subPhaseWarp.std,'*--','LineWidth',1.5,'MarkerSize',6, 'color', [0 0 0],'MarkerFaceColor', [0 0 0])  ;
                if plotMod.doMso && plotMod.doLso
                    h =legend('MSO model', 'LSO model','Subjects (Dietz 2008)','location', 'southEast');
                elseif plotMod.doMso
                    h =legend('MSO model','Subjects (Dietz 2008)','location', 'southEast');
                elseif plotMod.doLso
                    h =legend('LSO model','Subjects (Dietz 2008)','location', 'southEast');
                end
                
                set(h, 'box','off','fontSize',legF)
                grid on;
                set(ax,'yAxisLocation', 'right')
                xlabel('Phase warp beat frequency (Hz)', 'fontSize', labF)
                ylabel('Modulation depth (dB)', 'fontSize', labF)
                set(gca, 'ytick', [-16 -14 -12 -10 -8 -6 -4 -2 0 2])
                set(gca, 'xtick', [10 50 75])
                set(gca,'xscale', 'log')
                axis([8 80  -16 2 ] )
                
                
                
                
                
                %% panel name
                text(9.5,0.5, 'B', 'fontSize',20, 'fontWeight', 'bold')
            else
                set(ax,'visible', 'off')
            end
        end
    end
    %   set(findall(gcf,'-property','FontName'),'FontName','HelveticaNeueLT Com 57 Cn' )
    pu = get(gcf,'PaperUnits');
    pp = get(gcf,'PaperPosition');
    set(gcf,'Units',pu,'Position',pp)
    set(gcf,'PaperPositionMode', 'auto')
end