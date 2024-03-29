function [ allData ] = KAS_Parser_794_DelayNeural( Cutoff, Type, data, theFile )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%%Code to analyize the bias in responses based on SACP, current target, and
%sample mean

%Any .mat files you want to parse should be in the DataToParseFolder

%This one also registers whether or not the mean was shown during the
%decision period

%Gather Data
data_path = '/Users/KAS/Documents/MATLAB/ODR Task Analysis/AdaptODRMonkey/DatatoParse2';%AVData/794'; % DatatoParse2';
% files = dir(fullfile(data_path, '*.mat'));
% nfiles = length(files);
cd(data_path);

% loop through the files and collect the following data matrix, 
%  rows are trials, columns are:
%  1. session
%  2. Trial index within session
%  3. Hazard rate
%  4. Noise
%  5. TACP(Actual)
%  6. T1_Angle
%  7. T2_Angle
%  8. Sample Angle
%  9. LLR for T1>T2
%  10. Offline Score: 0=err, 1=correct, 2=sample, -1=ncerr
%  11. Correct Target Shown? 0=no, 1=yes
%  12. Response_angle
%  13. Active_Angle 
%  14. Choice
%  15. Choice~=Correct(previous trial) aka switch
%  16. LLR for Change point




%%
allData = [];
spikies=[];

% Please use the product of this script in conjunction with original .m data files
% with VisualizeTrial.m in ordr to examine individual trials

% Loop through the files
nfiles=1;
for currentFile = 1:nfiles
   
   % load the data file
%    load(fullfile(data_path, theFile));
%    disp(files(currentFile).name);
%       

   
%      ActiveTarg=data.ecodes.data(:,35);
%    InactiveTarg=nans(size(data.ecodes.data(:,41)));
%    InactiveTarg(data.ecodes.data(:,35)==data.ecodes.data(:,36))=data.ecodes.data(data.ecodes.data(:,35)==data.ecodes.data(:,36),37);
%    InactiveTarg(data.ecodes.data(:,35)~=data.ecodes.data(:,36))=data.ecodes.data(data.ecodes.data(:,35)~=data.ecodes.data(:,36),36);
% 
%    
%    Choice=nans(size(data.ecodes.data(:,41)));
% 
%   RespAng=data.ecodes.data(:, [39]);
% 
% 
% for i=1:size(data.ecodes.data(:,41),1)
%     if ~isnan(ActiveTarg(i))
%     if abs(degAngDiff(ActiveTarg(i),RespAng(i)))<=Cutoff
%         Choice(i)=ActiveTarg(i);
%     elseif abs(degAngDiff(InactiveTarg(i),RespAng(i)))<=Cutoff
%             Choice(i)=InactiveTarg(i);
% 
%     end
%     end
% end
%    
   % select "good" trials (no broken fixation) (Online score is not BF) and
   % is a AdODR task (taskid>=2);
   if Type==1
       task=data.ecodes.data(:,29)==1;
   else
       task=data.ecodes.data(:,29)>=2;
   end
   UnbrokenTrials = data.ecodes.data(:,41)>=-1 & task ;%& ~isnan(Choice);
   UnbrokenTrials_Index=find(UnbrokenTrials~=0);
   
   
      %Which target was picked?
%    Choice=nans(size(data.ecodes.data(:,41)));
%    Choice(data.ecodes.data(:,41)==1)=data.ecodes.data(data.ecodes.data(:,41)==1,35);
   InactiveTarg=nans(size(data.ecodes.data(:,41)));
   InactiveTarg(data.ecodes.data(:,35)==data.ecodes.data(:,36))=data.ecodes.data(data.ecodes.data(:,35)==data.ecodes.data(:,36),37);
   InactiveTarg(data.ecodes.data(:,35)~=data.ecodes.data(:,36))=data.ecodes.data(data.ecodes.data(:,35)~=data.ecodes.data(:,36),36);

%    Choice(data.ecodes.data(:,41)==0)=ChoiceParser(data.ecodes.data(:,41)==0);
%    Choice=Choice(UnbrokenTrials);

Choice2=nans(size(data.ecodes.data(UnbrokenTrials,41)));
  ActiveTarg=data.ecodes.data(UnbrokenTrials,35);
  RespAng=data.ecodes.data(UnbrokenTrials, [39]);
  Sample=data.ecodes.data(UnbrokenTrials, [38]);
  InactiveTarg=InactiveTarg(UnbrokenTrials);

for i=1:sum(UnbrokenTrials)
    if abs(degAngDiff(ActiveTarg(i),RespAng(i)))<=Cutoff
        Choice2(i)=ActiveTarg(i);
    elseif abs(degAngDiff(InactiveTarg(i),RespAng(i)))<=Cutoff
            Choice2(i)=InactiveTarg(i);

    end
end
   
test=find(UnbrokenTrials==1);
test2=~isnan(Choice2);
test3=test(test2);
temp=zeros(size(UnbrokenTrials));
temp(test3)=1;
UnbrokenTrials=(temp==1);
 UnbrokenTrials_Index=find(UnbrokenTrials~=0);
 
   Choice2=nans(size(data.ecodes.data(UnbrokenTrials,41)));
  ActiveTarg=data.ecodes.data(UnbrokenTrials,35);
  RespAng=data.ecodes.data(UnbrokenTrials, [39]);
  Sample=data.ecodes.data(UnbrokenTrials, [38]);
  
     InactiveTarg=nans(size(data.ecodes.data(:,41)));
   InactiveTarg(data.ecodes.data(:,35)==data.ecodes.data(:,36))=data.ecodes.data(data.ecodes.data(:,35)==data.ecodes.data(:,36),37);
   InactiveTarg(data.ecodes.data(:,35)~=data.ecodes.data(:,36))=data.ecodes.data(data.ecodes.data(:,35)~=data.ecodes.data(:,36),36);

  InactiveTarg=InactiveTarg(UnbrokenTrials);

for i=1:sum(UnbrokenTrials)
    if abs(degAngDiff(ActiveTarg(i),RespAng(i)))<=Cutoff
        Choice2(i)=ActiveTarg(i);
    elseif abs(degAngDiff(InactiveTarg(i),RespAng(i)))<=Cutoff
            Choice2(i)=InactiveTarg(i);

    end
end
   %Hazar Rate and Noise:
   Haz=data.ecodes.data(UnbrokenTrials, 32);
   Noise=data.ecodes.data(UnbrokenTrials, 33);
   
   
   %LLR for T1
   
      T1=max([normpdf(data.ecodes.data(UnbrokenTrials,38),data.ecodes.data(UnbrokenTrials,36),Noise)';normpdf(data.ecodes.data(UnbrokenTrials,38)+360,data.ecodes.data(UnbrokenTrials,36),Noise)';normpdf(data.ecodes.data(UnbrokenTrials,38)-360,data.ecodes.data(UnbrokenTrials,36),Noise)']); 
      T2=max([normpdf(data.ecodes.data(UnbrokenTrials,38),data.ecodes.data(UnbrokenTrials,37),Noise)';normpdf(data.ecodes.data(UnbrokenTrials,38)+360,data.ecodes.data(UnbrokenTrials,37),Noise)';normpdf(data.ecodes.data(UnbrokenTrials,38)-360,data.ecodes.data(UnbrokenTrials,37),Noise)']); 

   
   LLR=log(T1'./T2');
   
   %Were the choices visbible?
   Choice_Vis=~isnan(data.ecodes.data(UnbrokenTrials,8)) & (data.ecodes.data(UnbrokenTrials,8))<(data.ecodes.data(UnbrokenTrials,9));
   



  %Was the choice equal to the correct target of the previous trial?
  ActiveTarg=data.ecodes.data(UnbrokenTrials,35);
 
  Switch=(Choice2(2:end)~= ActiveTarg(1:end-1) & ~isnan(Choice2(2:end)));
  Switch=[nan;Switch];

  %LLR for change point
  InactiveTarg=nans(sum(UnbrokenTrials), 1);
  ActiveTarg=data.ecodes.data(UnbrokenTrials,35);
  Active1=data.ecodes.data(UnbrokenTrials,35)==data.ecodes.data(UnbrokenTrials,36);
  Targ1=data.ecodes.data(UnbrokenTrials,36);
  Targ2=data.ecodes.data(UnbrokenTrials,37);
  InactiveTarg(Active1)=Targ2(Active1);
    InactiveTarg(~Active1)=Targ1(~Active1);
    UnbrokenSamples= data.ecodes.data(UnbrokenTrials,38); 
    
   changeTarg=max([normpdf(UnbrokenSamples(2:end),InactiveTarg(1:end-1),Noise(1:end-1))';normpdf(UnbrokenSamples(2:end)+360,InactiveTarg(1:end-1),Noise(1:end-1))';normpdf(UnbrokenSamples(2:end)-360,InactiveTarg(1:end-1),Noise(1:end-1))']); 
   SameTarg=max([normpdf(UnbrokenSamples(2:end),ActiveTarg(1:end-1),Noise(1:end-1))';normpdf(UnbrokenSamples(2:end)+360,ActiveTarg(1:end-1),Noise(1:end-1))';normpdf(UnbrokenSamples(2:end)-360,ActiveTarg(1:end-1),Noise(1:end-1))']); 

    
  LLRCP=log(changeTarg./SameTarg)';
    LLRCP=[nan;LLRCP];
   
   
   % figure out trials since change points in unbroken trials
            %**** We are pretending broken trials straight up didn't happen
   % first extra-dimensional
   CPS = [0;find(diff(ActiveTarg)~=0);sum(UnbrokenTrials)];
   TACP = nans(sum(UnbrokenTrials),1);
   for ii = 1:length(CPS)-1
      inds = CPS(ii)+1:CPS(ii+1);
      TACP(inds) = 1:length(inds);
        %Allows you to assign a matrix to the slots of a matrix
   end

%    
%    has_target=~isnan(data.ecodes.data(UnbrokenTrials,6));
%    has_mean=~isnan(data.ecodes.data(UnbrokenTrials,22));
%    mean_visible=data.ecodes.data(UnbrokenTrials,32)<90;
%    
% 
%    
%    %Previous Target difference
%    PTargTargDiff=degAngDiff(tce_angles(2:end,2),tce_angles(1:end-1,2));
%    PTargTargDiff=[0;PTargTargDiff];
%    
%    %Delay Time
%    Delay=data.ecodes.data(:,8)-data.ecodes.data(:,7);
%    
%    %RXNTime
%    RXNTime=data.ecodes.data(UnbrokenTrials,42);
% 
%    %Model based estimate of where the mean is
%    PredictedMeans=CPPandRelia(tce_angles(:,2)', .1, 25 )';
   
% imptUnits=(mod(data.spikes.id,10)~=0)
imptUnits=ones(size(data.spikes.id));
numNeurons=sum(imptUnits);
   if sum(UnbrokenTrials)>0
   % now collect it all   
   allData = cat(1, allData, [ ...
      currentFile.*ones(sum(UnbrokenTrials), 1), ...
      UnbrokenTrials_Index,...
      Haz,...
      Noise,...
      TACP, ...
      data.ecodes.data(UnbrokenTrials, [36 37 38]),... 
      LLR,...
      data.ecodes.data(UnbrokenTrials, [40]),...
      Choice_Vis,...
      data.ecodes.data(UnbrokenTrials, [39 35]), ... 
      Choice2,...
      Switch,...
      LLRCP,...
      data.ecodes.data(UnbrokenTrials,[41]),...
      Choice2==data.ecodes.data(UnbrokenTrials, [35]),...
      data.ecodes.data(UnbrokenTrials, [7 9 10 12]),...
      numNeurons.*ones(sum(UnbrokenTrials), 1)
      %*****
%       data.spikies.data(UnbrokenTrials,2)
%       t12_angles, ...
%       has_target,...
%       has_mean,...
%       data.ecodes.data(UnbrokenTrials, [49 42 38 40, 41, 37]), ... 
%       PTargTargDiff,...
%       nans(sum(UnbrokenTrials),2),...
%       RXNTime,...
%       Delay(UnbrokenTrials),...
%       PredictedMeans,...
%       nans(sum(UnbrokenTrials),1),...
%       mean_visible,...
      ]);   
  if ~isempty(data.spikes.data)
  spikies=[spikies;data.spikes.data(UnbrokenTrials,imptUnits)];
  else
      spikies=[spikies;cell(sum(UnbrokenTrials),1)];
  end
end
end


spikelist={};
for i=1:numNeurons
    name=['spiketimes_',num2str(data.spikes.id(imptUnits(i)))];
    spikelist=[spikelist,name];
end
if numNeurons==0
    spikelist={'none'};
end




Interm=num2cell(allData);
Interm=[Interm,spikies];
%
for i=1:nfiles
Interm((allData(:,1)==i),1)={theFile};
end
% Make a Table


%  1. session
%  2. Trial index within session
%  3. Hazard rate
%  4. Noise
%  5. TACP(Actual)
%  6. T1_Angle
%  7. T2_Angle
%  8. Sample Angle
%  9. LLR for T1>T2
%  10. Offline Score: 0=err, 1=correct, 2=sample, -1=ncerr
%  11. Choices on when made response? 0=no, 1=yes
%  12. Response_angle
%  13. Active_Angle 
%  14. Choice
%  15. Choice~=Correct(previous trial) aka switch
%  16. LLR for Change point
%  17. OnlineScore: 

thenames={'Session','Trial_Within_Session','H_Rate',...
                                             'Noise', 'TACP_Actual', 'T1_Angle',...
                                             'T2_Angle', 'Sample_Angle', 'LLR', 'Offline_Score', 'Correct_On',...
                                             'Response_Angle', 'Active_Angle', 'Choice',...
                                             'Switch', 'LLR_for_Change', 'OnlineScore','Correct','SampleOn','SampleOff','FPOff','SacOn','Num_Neuron'};
thenames=[thenames,spikelist];

allData=cell2table(Interm,'VariableNames',thenames);

%%                                         




end

