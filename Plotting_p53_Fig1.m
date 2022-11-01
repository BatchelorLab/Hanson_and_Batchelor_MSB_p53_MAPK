%%plotting p53 data of Figure 1

%load data
load('Figure1_p53.mat');

%separate groups
NCS=p53_Figure1(1,:);
ROS=p53_Figure1(2,:);

NCS_Names=Names(1,:);
ROS_Names=Names(2,:);
%%plot average p53 comparison of p53 between NCS and H2O2
figure(1)
for i=1:length(Names)
    subplot(1,length(Names),i)
    %%plotting p53 for comparison
    hold on
    %%plot_areaerrorbar2 based upon plot_areaerrorbar available on file
    %%exchange developed by Victor Martinez-Cagigal.  Added input parser
    %%for easier incorporation of X-axis and calculated std using nanstd
    %%for cell death plots where dead cells are replaced by nan.
    plot_areaerrorbar2(NCS{i},'Xaxis',time);
    plot_areaerrorbar2(ROS{i},'Xaxis',time,'LineColor','r','AreaColor','r');
    ylim([0 30000]);
    xlim([0 24]);
    xlabel('time (hrs)');
    ylabel('p53 (au)');
   legend(NCS_Names{i},'',ROS_Names{i},'');

end

figure(2)
%%Plotting integrated p53 levels over full time span for NCS vs ROS
integrated_p53_NCS=cell(1,3);
for n=1:3
    for i=1:length(NCS{n}(:,1))
        duration=time(~isnan(NCS{n}(i,:)));
        integrated_p53_NCS{n}(i)=trapz(duration,NCS{n}(i,1:length(duration)));     
    end
end
integrated_p53_ROS=cell(1,3);
for n=1:3
    for i=1:length(ROS{n}(:,1))
        duration=time(~isnan(ROS{n}(i,:)));
        integrated_p53_ROS{n}(i)=trapz(duration,ROS{n}(i,1:length(duration)));
    end
end

for n=1:3
    intp53_NCS(n)=mean(integrated_p53_NCS{n});
    sem_NCS(n)=std(integrated_p53_NCS{n})./sqrt(length(integrated_p53_NCS{n}));
    intp53_ROS(n)=mean(integrated_p53_ROS{n});
    sem_ROS(n)=std(integrated_p53_ROS{n})./sqrt(length(integrated_p53_ROS{n}));
    [~,p]=ttest2(integrated_p53_NCS{n},integrated_p53_ROS{n});
    values(n)=p;
end

samples=[intp53_NCS;intp53_ROS]';
error=[sem_NCS;sem_ROS]';

%%plotted from low dose to high dose, blue=NCS, orange=H2O2
%%barwitherr available in file exchange developed by Martina Callaghan
barwitherr(error,samples);
