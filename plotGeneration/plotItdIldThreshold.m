function plotItdIldThreshold(itdThreshold,freqListMso,ildThreshold, freqListLso,plotItd,plotIld)
%% PLOT: ITD and ILD threshold for pure tones
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
load('subResItdThres.mat')
load('subResIldThres.mat')

%setting the Matlab figure



%%  calculate axes

sub_pos =calculateAxes (plotwidth,plotheight,leftedge, rightedge, subplotsx, subplotsy, topedge, bottomedge,spacex,spacey);





f=figure('visible','on','Name','Fig. 9  (A) MSO model ITD threshold), (B) LSO model ILD threshold','NumberTitle','off');
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
        %% ITD response
        if x==1 && y ==1
            if plotItd
                hErr = errorbar(freqListMso,mean(itdThreshold),std(itdThreshold),'LineWidth',1.5,'Marker', 'diamond','MarkerSize',6, 'color', [0.6 0.6 0.6],'MarkerFaceColor', [0.6 0.6 0.6])   ;
                
                hold on;
                            errorbar(subThresItd.f1, subThresItd.mean1*1e-6, subThresItd.std1*1e-6,'LineWidth',1.5,'LineStyle','--','Marker', '*','MarkerSize',6, 'color', [0 0 0],'MarkerFaceColor', [1 1 1])   ;
                            hold on;
                            errorbar(subThresItd.f2, subThresItd.mean2*1e-6, subThresItd.std2*1e-6,'LineWidth',1.5,'LineStyle','-','Marker', 'o','MarkerSize',6, 'color', [0.2 0.2 0.2],'MarkerFaceColor', [1 1 1])   ;
                            hold on;
                            errorbar(subThresItd.f3, subThresItd.mean3*1e-6, subThresItd.std3*1e-6,'LineWidth',1.5,'LineStyle','--','Marker',  'p','MarkerSize',6, 'color', [0.3 0.3 0.3],'MarkerFaceColor', [1 1 1])   ;
                            hold on;
                            errorbar(subThresItd.f4, subThresItd.mean4*1e-6, subThresItd.std4*1e-6,'LineWidth',1.5,'LineStyle','-','Marker', 's','MarkerSize',6, 'color', [0.4 0.4 0.4],'MarkerFaceColor', [1 1 1])   ;
                
                            h =legend('MSO model', 'S1 (Brughera2011)', 'S2 (Brughera2011)', 'S3 (Brughera2011)', 'S4 (Brughera2011)','location', 'northWest');
                
                %% other way arround how to calculate group mean and group std
%                 totalMean = [];
%                 totalStd = [];
%                 totalMean(1:9) = (subThresItd.mean1(1:9) + subThresItd.mean2(1:9) + subThresItd.mean3(1:9) + subThresItd.mean4(1:9))/4;
%                 d1 = subThresItd.mean1(1:9) - totalMean;
%                 d2 = subThresItd.mean2(1:9) - totalMean;
%                 d3 = subThresItd.mean3(1:9) - totalMean;
%                 d4 = subThresItd.mean4(1:9) - totalMean;
%                 totalStd = sqrt((d1.^2 + subThresItd.std1(1:9).^2 + d2.^2 + subThresItd.std2(1:9).^2 + d3.^2 + subThresItd.std3(1:9).^2 + d4.^2 + subThresItd.std4(1:9).^2)/4);
%                 % combine one frequency over 3 subjects
%                 totalMean(10) = (subThresItd.mean1(10) + subThresItd.mean2(10) + subThresItd.mean3(10))/3;
%                 d1 = subThresItd.mean1(10) - totalMean(10);
%                 d2 = subThresItd.mean2(10) - totalMean(10);
%                 d3 = subThresItd.mean3(10) - totalMean(10);
%                 totalStd(10) = sqrt((d1.^2 + subThresItd.std1(10).^2 + d2.^2 + subThresItd.std2(10).^2 + d3.^2 + subThresItd.std3(10).^2 /3));
%                 % combine one frequency over 2 subjects
%                 totalMean(11) = (subThresItd.mean1(11) + subThresItd.mean2(11))/2;
%                 d1 = subThresItd.mean1(11) - totalMean(11);
%                 d2 = subThresItd.mean2(11) - totalMean(11);
%                 totalStd(11) = sqrt((d1.^2 + subThresItd.std1(11).^2 + d2.^2 + subThresItd.std2(11).^2 + d3.^2 /2));
%                 errorbar(subThresItd.f1, totalMean*1e-6, totalStd*1e-6,'LineWidth',1.5,'LineStyle','--','Marker', '*','MarkerSize',6, 'color', [0 0 0],'MarkerFaceColor', [0 0 0])   ;
%                 totalMedian = [];
%                 totalStd = [];
%                 totalMedian(1:9) = median( [subThresItd.mean1(1:9); subThresItd.mean2(1:9); subThresItd.mean3(1:9) ; subThresItd.mean4(1:9)]);
%                 
%                 boundary = 1./(2*subThresItd.f1)*1e6;  %have to correct the sampling
%                 totalMedian(10) = median( [subThresItd.mean1(10) ; subThresItd.mean2(10) ; subThresItd.mean3(10); boundary(10)]);
%                 totalMedian(11) = median([subThresItd.mean1(11) ; subThresItd.mean2(11); boundary(11);boundary(11)]);
% % boundary 
%                 
%                 
%                 plot(subThresItd.f1, totalMedian*1e-6,'LineWidth',1.5,'LineStyle','--','Marker', '*','MarkerSize',6, 'color', [0 0 0],'MarkerFaceColor', [0 0 0])   ;                
%                 h =legend('MSO model', 'Subjects (Brughera2011)','location', 'northWest');
                
                set(h, 'box','off','fontSize',legF)
                uistack(hErr, 'top')
                grid on;
                axis([freqListMso(1)-50 freqListMso(end)+50 0 250e-6 ] )
%                 axis([freqListMso(1) freqListMso(end) 0 300e-6 ] )
                %    set(gca,'xtick',[1:2:12],'xticklabel',{phase(2:2:12) })
                %    set(gca, 'xtick
                
                yAx =[0 50e-6 100e-6 150e-6 200e-6];
                set(gca, 'ytick',yAx);
                set(gca,'ytickLabel', yAx*1e6)
                
                
                xlabel('Frequency (Hz)', 'fontSize',labF)
                ylabel('ITD threshold (\mus)', 'fontSize',labF)
                %% panel name
                text(290,217e-6, 'A', 'fontSize',20, 'fontWeight', 'bold')
            else
                set(ax,'visible', 'off')
                
            end
            
            
            
        elseif x==2 && y==1
            if plotIld
                errorbar(freqListLso,mean(ildThreshold),std(ildThreshold),'LineWidth',1.5,'Marker', '^','MarkerSize',6, 'color', [0.6 0.6 0.6],'MarkerFaceColor', [0.6 0.6 0.6])  ;
                
                hold on;
                plot(subDataIld.freq,subDataIld.ild, '*--','LineWidth',1.5,'MarkerSize',6, 'color', [0 0 0]);
                
                h =legend('LSO model', 'Subjects (Yost1988)','location', 'northEast');
                
                set(h, 'box','off','fontSize',legF)
                grid on;
                set(ax,'yAxisLocation', 'right')
                xlabel('Frequency (Hz)', 'fontSize', labF)
                ylabel('ILD threshold (dB)', 'fontSize', labF)
                
                set(gca, 'ytick', [0.4 0.6 0.8 1])
                
                axis([0 5500 0 1.2 ] )
                
                %% panel name
                text(120,1.12, 'B', 'fontSize',20, 'fontWeight', 'bold')
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