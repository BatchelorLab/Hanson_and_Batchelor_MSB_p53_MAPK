%%plotting Tanz data of Figure 3

%load data
load('Figure3_Tanzisertibdata.mat');

%%group colors low inhibitor to high inhibitor
c={'k','b','r','g','y','m'};

%%plot mean C/N ratio for all condition
figure(1)
for i=1:length(Tanz_Names)
hold on
plot(time,nanmean(Tanzisertib_data{i}),'Color',c{i})
ylim([0.4 1.4]);
xlim([0 4]);
end
%%Boxplot of Data

%%Box plot of peak activation
figure(2)
for i=1:length(Tanz_Names)
    peakCN{i}=max(Tanzisertib_data{i},[],2);
    groups{i}=ones(length(Tanzisertib_data{i}(:,1)),1).*i;
end

peakCN=cell2mat(peakCN(:));
groups=cell2mat(groups(:));
boxplot(peakCN,groups,'Symbol','.','OutlierSize',10.0);
[p,tbl,stats]=anova1(peakCN,groups);
[c]=multcompare(stats);