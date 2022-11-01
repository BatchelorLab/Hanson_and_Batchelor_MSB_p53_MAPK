%%plotting ERK live dead data Figure 3

%load data
load('Figure3_ERKLiveDead.mat');

%separate groups
Live=Figure3_ERKLiveDead{1};
Dead=Figure3_ERKLiveDead{2};




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
    ylim([0.2 2.0]);
    xlim([0 24]);
    xlabel('time (hrs)');
    ylabel('ERK C/N ratio');
   legend([Names{1},',n=52'],'',[Names{2},',n=49'],'');


%%Boxplot of live and cell death features
%compile data into single matrix
data=cell2mat(Figure3_ERKLiveDead(:));
%%extract features.  extractfeatures based upon findpeaks function.
%%minimum prominence based on 50% of the difference between median basal
%%and peak expression of all cells analyzed, minimum distance between peaks
%%of 1 hour default
features=extractfeatures(data,time,'Prominence',0.3);




%%Plotting supplemental plots
figure(2)
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