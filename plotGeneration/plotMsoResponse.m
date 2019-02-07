function plotMsoResponse(msoRespIpdPureTone, ipdList,msoRespItdNoise,itdList, plotIpd, plotItd)
%% PLOT: Mean MSO model response to pure tones with IPD and response to broad-band noises with ITD
%% Author:     Jaroslav Bouse, bousejar@gmail.com

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

panelNames = ['A','B','C','D','E','F'];

%setting the Matlab figure

%%  calculate axes

sub_pos =calculateAxes (plotwidth,plotheight,leftedge, rightedge, subplotsx, subplotsy, topedge, bottomedge,spacex,spacey);





f=figure('visible','on','Name','Fig. 3  (A) The normalized responses of left MSO model to pure tones with varying freqency and IPD, (B) The normalized responses for two CFs of left MSO to interauraly delayed broadband noise','NumberTitle','off');
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
        if x==1
            if plotIpd
                dataIndex = 1;
                plot(ipdList,msoRespIpdPureTone(:,1)./max(msoRespIpdPureTone(:,1)),'--','LineWidth',1.5,'MarkerSize',6, 'color', [0 0 0],'MarkerFaceColor', [0.6 0.6 0.6]);
                hold on;
                plot(ipdList,msoRespIpdPureTone(:,2)./max(msoRespIpdPureTone(:,2)),'--','LineWidth',1.5,'MarkerSize',6, 'color', [0 0 0],'MarkerFaceColor', [0.6 0.6 0.6]);
                hold on;
                plot(ipdList,msoRespIpdPureTone(:,3)./max(msoRespIpdPureTone(:,3)),':','LineWidth',1.5,'MarkerSize',6, 'color', [0 0 0],'MarkerFaceColor', [0.6 0.6 0.6]);
                hold on;
                plot(ipdList,msoRespIpdPureTone(:,4)./max(msoRespIpdPureTone(:,4)),'LineWidth',1.5,'MarkerSize',6, 'color', [0.6 0.6 0.6],'MarkerFaceColor', [0.6 0.6 0.6]);
                %% Panel NAME
                text(-145,0.92, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                %% plot legend
                h =legend('300 Hz','500 Hz', '800 Hz', '1300 Hz' ,'location', 'south');
                set(h, 'box','off','fontSize',legF);
                set(h, 'box','off','fontSize',legF);
                axis([ipdList(1) ipdList(end)+10 0 1 ] );
                grid on;
                xlabel('Interaural phase difference (°)', 'fontSize',labF);
                ylabel('Normalized response (-)', 'fontSize',labF);
                
            else
                set(ax,'visible', 'off')
            end
            
            
        elseif x==2
            if plotItd
                dataIndex = 2;
                load('phyMsoNBNItd.mat');
                
                plot(itdList,msoRespItdNoise(:,1)./max(msoRespItdNoise(:,1)),'LineStyle','--','LineWidth',1.5,'MarkerSize',6, 'color', [0.6 0.6 0.6],'MarkerFaceColor', [0.6 0.6 0.6]);
                hold on;
                plot(phyMsoNBNItd.t250*1e-6,phyMsoNBNItd.resp250./max(phyMsoNBNItd.resp250),'LineStyle','--','LineWidth',1.5,'MarkerSize',6, 'color', [0 0 0],'MarkerFaceColor', [0 0 0]);
                hold on;
                plot(itdList,msoRespItdNoise(:,2)./max(msoRespItdNoise(:,2)),'LineWidth',1.5,'MarkerSize',6, 'color', [0.6 0.6 0.6],'MarkerFaceColor', [0.6 0.6 0.6]);
                hold on;
                plot(phyMsoNBNItd.t700*1e-6,phyMsoNBNItd.resp700./max(phyMsoNBNItd.resp700),'LineWidth',1.5,'MarkerSize',6, 'color', [0 0 0],'MarkerFaceColor', [0.6 0.6 0.6]);
% load('phyMsoPureToneItd3.mat');
% plot(itdList,msoRespItdNoise./max(msoRespItdNoise),'LineStyle','--','LineWidth',1.5,'MarkerSize',6, 'color', [0.6 0.6 0.6],'MarkerFaceColor', [0.6 0.6 0.6]);
% hold on;
% plot(phyMsoPureTone.t250*1e-6,phyMsoPureTone.resp250./max(phyMsoPureTone.resp250),'LineStyle','--','LineWidth',1.5,'MarkerSize',6, 'color', [0 0 0],'MarkerFaceColor', [0 0 0]);
                %% Panel NAME
                text(-500e-6,0.92, panelNames(dataIndex), 'fontSize',20, 'fontWeight', 'bold')
                %% Plot legend
%                 axis([-5e-3 5e-3 0 1 ] )
                axis([-1.5e-3 1.5e-3 0 1 ] )
                h =legend('MSO model, CF=250 Hz', 'IC, CF=250 Hz (McAlpine2001)','MSO model, CF=700 Hz', 'IC, CF=700 Hz (McAlpine2001)' ,'location', 'south');
%                 h =legend('MSO model', 'Pecka MSO' ,'location', 'south');
                set(h, 'box','off','fontSize',legF);
                xlabel('Interaural time difference (\mus)', 'fontSize',labF);
                set(ax,'yticklabel',[]);
%                 set(gca,'xtick',[-600*1e-6 -400*1e-6 -200*1e-6 0 200*1e-6 400*1e-6 600*1e-6  ],'xticklabel',{-600 -400 -200 0 200 400 600 });
                grid on;
            else
                set(ax,'visible', 'off')
            end
            
        end
      
    end
end
%   set(findall(gcf,'-property','FontName'),'FontName','HelveticaNeueLT Com 57 Cn' )
pu = get(gcf,'PaperUnits');
pp = get(gcf,'PaperPosition');
set(gcf,'Units',pu,'Position',pp)
set(gcf,'PaperPositionMode', 'auto')
