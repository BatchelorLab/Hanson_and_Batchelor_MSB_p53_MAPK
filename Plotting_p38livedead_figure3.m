%%plotting p38 live dead data Figure 3

%load data
load('Figure3_p38LiveDead.mat');

%separate groups
Live=Figure3_p38_LiveDead{1};
Dead=Figure3_p38_LiveDead{2};




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
    ylim([0.2 0.9]);
    xlim([0 24]);
    xlabel('time (hrs)');
    ylabel('p38 C/N ratio');
   legend([Names{1},',n=97'],'',[Names{2},',n=55'],'');


%%Boxplot of live and cell death features
%compile data into single matrix
data=cell2mat(Figure3_p38_LiveDead(:));
%%extract features.  extractfeatures based upon findpeaks function.
%%minimum prominence based on 50% of the difference between median basal
%%and peak expression of all cells analyzed, minimum distance between peaks
%%of 1 hour default
features=extractfeatures(data,time,'Prominence',0.2);




%%Plotting supplemental plots
figure(2)
subplot(1,2,1)
boxplot(features.MaxAmp,features.Status,'GroupOrder',{'Live','Dead'},'Symbol','.','OutlierSize',10);
title('Max amplitude')
subplot(1,2,2)
boxplot(features.TimeMax,features.Status,'GroupOrder',{'Live','Dead'},'Symbol','.','OutlierSize',10);
title('Time to Max Amplitude');