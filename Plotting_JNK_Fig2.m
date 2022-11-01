%%plotting JNK data of Figure 2

%load data
load('Figure2_JNK.mat');

%separate groups
NCS=JNK_Figure2_and_supplemental(1,:);
ROS=JNK_Figure2_and_supplemental(2,:);

NCS_Names=Names(1,:);
ROS_Names=Names(2,:);
%%plot 3 random cells for each condition at high dose of treatment
figure(1)
for n=3
    cells_NCS=length(NCS{n}(:,1));
    cells_ROS=length(ROS{n}(:,1));
    selection_NCS=randsample(cells_NCS,3);
    selection_ROS=randsample(cells_ROS,3);

    subplot(1,2,1)
    plot(time,NCS{n}([selection_NCS],:),'b');
    title('NCS')
    xlim([0 24]);
    xlabel('time (hrs)');
    ylabel('C/N ratio');

    subplot(1,2,2)
    plot(time,ROS{n}([selection_ROS],:),'r');
    xlabel('time (hrs)');
    ylabel('C/N ratio');
    title('H2O2')
    xlim([0 24]);
end

%%plot average C/N ratio indvidually for high dose
figure(2)

    %%plot_areaerrorbar2 based upon plot_areaerrorbar available on file
    %%exchange developed by Victor Martinez-Cagigal.  Added input parser
    %%for easier incorporation of X-axis and calculated std using nanstd
    %%for cell death plots where dead cells are replaced by nan.
    subplot(1,2,1)
    plot_areaerrorbar2(NCS{3},'Xaxis',time);
    ylim([0 2.5]);
    xlim([0 24]);
    xlabel('time (hrs)');
    ylabel('C/N ratio');
   legend(['n=' num2str(length(NCS{3}(:,1)))]);


    subplot(1,2,2)
    plot_areaerrorbar2(ROS{3},'Xaxis',time,'LineColor','r','AreaColor','r');
    ylim([0 2.5]);
    xlim([0 24]);
    xlabel('time (hrs)');
    ylabel('C/N ratio');
   legend(ROS_Names{3},'');
   legend(['n=' num2str(length(ROS{3}(:,1)))]);

%%Combined plot for high dose
figure(3)

    %%plotting p53 for comparison
    hold on
    %%plot_areaerrorbar2 based upon plot_areaerrorbar available on file
    %%exchange developed by Victor Martinez-Cagigal.  Added input parser
    %%for easier incorporation of X-axis and calculated std using nanstd
    %%for cell death plots where dead cells are replaced by nan.
    plot_areaerrorbar2(NCS{3},'Xaxis',time);
    plot_areaerrorbar2(ROS{3},'Xaxis',time,'LineColor','r','AreaColor','r');
    ylim([0 2.5]);
    xlim([0 24]);
    xlabel('time (hrs)');
    ylabel('C/N ratio');
   legend(NCS_Names{3},'',ROS_Names{3},'');


%%Boxplot of Data

%%Box plot of JNK activation at H2O2 max
figure(4)
mean_ROS=nanmean(ROS{3})
[~,I]=max(mean_ROS);
data_at_I=[NCS{3}(:,I);ROS{3}(:,I)];
groups=ones(length(data_at_I),1);
groups(1:length(NCS{3}(:,I)))=0.75;

boxplot(data_at_I,groups,'Symbol','.','OutlierSize',10.0);
[p,tbl,stats]=anova1(data_at_I,groups);
[c]=multcompare(stats);