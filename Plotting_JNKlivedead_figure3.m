%%plotting JNK live dead data Figure 3

%load data
load('Figure3_JNKLiveDead.mat');

%separate groups
Live=Figure3_JNKLiveDead{1};
Dead=Figure3_JNKLiveDead{2};




%%Comparison of live and dead kinase activity
figure(1)

    %%plotting p53 for comparison
    hold on
    %%plot_areaerrorbar2 based upon plot_areaerrorbar available on file
    %%exchange developed by Victor Martinez-Cagigal.  Added input parser
    %%for easier incorporation of X-axis and calculated std using nanstd
    %%for cell death plots where dead cells are replaced by nan.
    plot_areaerrorbar2(Live,'Xaxis',time,'LineColor','k','AreaColor','k');
    plot_areaerrorbar2(Dead,'Xaxis',time,'LineColor','r','AreaColor','r');
    ylim([0.2 1.1]);
    xlim([0 24]);
    xlabel('time (hrs)');
    ylabel('JNK C/N ratio');
   legend([Names{1},',n=53'],'',[Names{2},',n=50'],'');


%%Boxplot of live and cell death features
%compile data into single matrix
data=cell2mat(Figure3_JNKLiveDead(:));
%%extract features.  extractfeatures based upon findpeaks function.
%%minimum prominence defined as 50% of the difference between median basal
%%and peak expression of all cells analyzed, minimum distance between peaks
%%of 1 hour default
features=extractfeatures(data,time,'Prominence',0.25);

%%Manuscript figure of JNK 2nd pulse timing
figure(2)
%%time of second pulse
boxplot(features.TimeTo2ndPeak,features.Status,'Symbol','.','OutlierSize',10);
% [p,tbl,stats]=anova1(features.TimeTo2ndPeak,features.Status);



%%Plotting supplemental plots
figure(3)
subplot(1,6,1)
boxplot(features.MaxAmp,features.Status,'Symbol','.','OutlierSize',10);
title('Max amplitude')
subplot(1,6,2)
boxplot(features.TimeTo1stPeak,features.Status,'Symbol','.','OutlierSize',10);
title('Time to 1st peak');
subplot(1,6,3)
boxplot(features.TimeTo2ndPeak,features.Status,'Symbol','.','OutlierSize',10);
title('Time to 2nd peak');
subplot(1,6,4)
boxplot(features.FWHM1stPeak,features.Status,'Symbol','.','OutlierSize',10);
title('FWHM 1st peak')
subplot(1,6,5)
boxplot(features.FWHM2ndPeak,features.Status,'Symbol','.','OutlierSize',10);
title('FWHM 2nd peak');
subplot(1,6,6)
boxplot(features.PulseNum,features.Status,'Symbol','.','OutlierSize',10);
title('Number of activity pulses');