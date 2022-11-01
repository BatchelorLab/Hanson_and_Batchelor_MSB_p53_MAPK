%%Function designed to extract features from time course data.  Features
%include
% --Pulse Number:  Number of pulses observed over duration of time course
% --Time to first peak:  Timing of first pulse of activity
%--Time to second peak:  Timing of second activation
%--Duration of first peak:  FWHM of first peak
%--Duration of second peak:  FWHM of second peak
%--Time of last peak:  Timing of final peak activity
%--Duration of last peak: FWHM of last peak
%--Interpeak distance for first and second: Timing between peaks
%--Interpeak distance for first and last: Timing between first and last
%peak
%--Average interpeak distance:  mean of interpeak distances for all peaks
%--Basal Activity:  Activity at time=0
%--Final Activity:  Activity at time=end
%--Period:  Based on periodogram function
%%Average Velocity:  dYdT overall
%Velocity of first peak: average dYdT over 1st peak
%--Max activation/expression:  Maximum amplitude during duration of time
    %course


function [featuretable]=extractfeatures(data,time,varargin)
p=inputParser;
addParameter(p,'Prominence',[0.25],@isnumeric);
addParameter(p,'Threshold',[0.6],@isnumeric);
addParameter(p,'PeakGap',[1],@isnumeric);

p.KeepUnmatched = true;
    parse(p,varargin{:});
    Prom = p.Results.Prominence;
    Gate = p.Results.Threshold;
    Gap=p.Results.PeakGap;
% if class(data)=='char'
%     data=load(data);
%     Field=fieldnames(data);
%     data=data.(Field{1});
% else class(data)=='double'
%     data=data;
% end

%%Define the feature table based on listed features and size of data input    
featurenames={'PulseNum','TimeTo1stPeak','TimeTo2ndPeak','FWHM1stPeak','FWHM2ndPeak','Amp1stPeak','Amp2ndPeak','TimeToLastPeak','FWHMLastPeak','AmpLastPeak','InterDist12','InterDist1Last','AvgInterDist','Basal','Final','Period','dYdT','FirstPeakdYdT','MaxAmp','ActivityDuration','Status'};
vartypes={'double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','categorical'};
featuretable=table('Size',[length(data(:,1)) length(featurenames)],'VariableTypes',vartypes,'VariableNames',featurenames);
featuretable=standardizeMissing(featuretable,0);
%normalized data for period analysis.  fs is 7.5 measurements per hour.
%Period in hours
datanorm=data-nanmean(data,1);
fs=7.5;
%%minmax for peak calling
dataminmax=(data-min(data,[],2)./(max(data,[],2)-min(data,[],2)));

%%Populate empty matrices




for i=1:length(data(:,1))
    [~,idx,FWHM,~]=findpeaks(data(i,:),'MinPeakProminence',Prom,'MinPeakDistance',Gap);
    %remove NaN for velocity
    modData=~isnan(data(i,:));
    dYdT=diff(data(i,modData))./diff(time(modData));
    [pxx,f]=periodogram(datanorm(i,modData),[],[],fs);
    %remove t=0
    pxx=pxx(2:end);
    f=f(2:end);
    [pxxidx,m]=islocalmax(pxx);
    
        [~,midx]=max(m);
    featuretable.Period(i)=1/f(midx);
    
    if isnan(data(i,181))==1
        featuretable.Status(i)='Dead';
    else
        featuretable.Status(i)='Live';
    end
    %Active Kinase based on threshold
    if sum(data(i,:)>0.6)>=1
    featuretable.ActivityDuration(i)=time(sum(data(i,:)>0.6));
    else
        featuretable.ActivityDuration(i)=0;
    end
    featuretable.dYdT(i)=nanmean(dYdT);
    featuretable.PulseNum(i)=length(idx);
    featuretable.Basal(i)=data(i,1);
    featuretable.Final(i)=data(i,find(~isnan(data(i,:)),1,'last'));
    [peak,m]=max(data(i,:));
    featuretable.MaxAmp(i)=max(data(i,:));
    featuretable.TimeMax(i)=time(m);
    if isempty(idx)==0
    featuretable.TimeTo1stPeak(i)=time(idx(1));
    featuretable.FirstPeakdYdT(i)=nanmean(dYdT(1:idx(1)));
    featuretable.FWHM1stPeak(i)=FWHM(1)*(time(end)/length(time));%%not right
    featuretable.Amp1stPeak(i)=data(i,idx(1));
    featuretable.TimeToLastPeak(i)=time(idx(end));
    featuretable.AmpLastPeak(i)=data(i,idx(end));
    featuretable.FWHMLastPeak(i)=FWHM(end)*(time(end)/length(time));
    featuretable.InterDist1Last(i)=time(idx(end))-time(idx(1));
    if time(idx(end))-time(idx(1))==0
        featuretable.InterDist1Last(i)=NaN;
    end
    if length(idx)>1
        featuretable.TimeTo2ndPeak(i)=time(idx(2));
        featuretable.FWHM2ndPeak(i)=FWHM(2)*(time(end)/length(time));
        featuretable.Amp2ndPeak(i)=data(i,idx(2));
        featuretable.InterDist12(i)=time(idx(2))-time(idx(1));
        AllInterDist=NaN(length(idx)-1);
        for z=1:(length(idx)-1)
            
            AllInterDist(z)=time(idx(z+1))-time(idx(z));
        end
%         featuretable.AvgInterDist(i)=nanmean(AllInterDist);
    
    end
    end
end
end

    
    
    
    
    
    

