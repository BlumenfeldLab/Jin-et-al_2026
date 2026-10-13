%% This script aggregates run-by-run data for quiz confidence (percentile), accuracy (percent correct), awareness, and unawareness

clear all
close all
clc
%% Iterate over all sessions, sorting by individual subjects

location = 'l'


[num text raw] = xlsread([root '/AoA_All_Subjs_Data.xlsx']);


allICAs = [];
allDesignations = {};
allSubjectERPs = [unique(text(1,:)); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:))))];
allSubjectRuns = [unique(text(1,:)); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:)))); cell(1,length(unique(text(1,:))))];
allRunsAllSubjects = [];
allSessionRunsConfidence = [];
allSessionRunsAccuracy = [];
allSessionRunsUnawareness = [];
allSessionRunsAwareness = [];
allSessionRunsDays = [];
allSessionRunsSubject = [];
for session = 1:length(text);
    
    allSessionRunsSubject = [allSessionRunsSubject; text(1,session)];
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/'];
    disp(['Analyzing ' text{1,session} ])
    sessionDate = num2str(num(1,session));
    cd(fileLocation)
    load([fileLocation sessionDate '_sliders_and_percentiles_timing.mat'])
    sliderSuccessesAllPercentilesTiming = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,1) ~= 9999,:);
    session_unawarenesses = zeros(1,length(sliderSuccessesAllPercentilesTiming));
    for item = 1:length(session_unawarenesses)
        if sliderSuccessesAllPercentilesTiming(item,3) < 25 && sliderSuccessesAllPercentilesTiming(item,4) == 0
            session_unawarenesses(item) = 1;
        end
    end
    for item = 1:length(session_awarenesses)
        if sliderSuccessesAllPercentilesTiming(item,3) > 75 && sliderSuccessesAllPercentilesTiming(item,4) == 1
            session_awarenesses(item) = 1;
        end
    end
    allRunsAllSubjects = [allRunsAllSubjects; sliderSuccessesAllPercentilesTiming];
    currentSubjectRun1 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 1,:);
    currentSubjectRun2 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 2,:);
    currentSubjectRun3 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 3,:);
    currentSubjectRun4 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 4,:);
    currentSubjectRun5 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 5,:);
    currentSubjectRun6 = sliderSuccessesAllPercentilesTiming(sliderSuccessesAllPercentilesTiming(:,5) == 6,:);
    currentSubjectUnawarenessesRun1 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 1);
    currentSubjectUnawarenessesRun2 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 2);
    currentSubjectUnawarenessesRun3 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 3);
    currentSubjectUnawarenessesRun4 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 4);
    currentSubjectUnawarenessesRun5 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 5);
    currentSubjectUnawarenessesRun6 = session_unawarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 6);

    currentSubjectAwarenessesRun1 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 1);
    currentSubjectAwarenessesRun2 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 2);
    currentSubjectAwarenessesRun3 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 3);
    currentSubjectAwarenessesRun4 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 4);
    currentSubjectAwarenessesRun5 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 5);
    currentSubjectAwarenessesRun6 = session_awarenesses(sliderSuccessesAllPercentilesTiming(:,5) == 6);
    currentSessionConfidence = [mean(currentSubjectRun1(:,3)) mean(currentSubjectRun2(:,3)) mean(currentSubjectRun3(:,3)) mean(currentSubjectRun4(:,3)) mean(currentSubjectRun5(:,3)) mean(currentSubjectRun6(:,3))];
    allSessionRunsConfidence = [allSessionRunsConfidence; currentSessionConfidence];    
    
    currentSessionAccuracy = [mean(currentSubjectRun1(:,4)) mean(currentSubjectRun2(:,4)) mean(currentSubjectRun3(:,4)) mean(currentSubjectRun4(:,4)) mean(currentSubjectRun5(:,4)) mean(currentSubjectRun6(:,4))];
    currentSessionAccuracy = currentSessionAccuracy * 100;
    allSessionRunsAccuracy = [allSessionRunsAccuracy; currentSessionAccuracy];
    currentSessionUnawareness = [mean(currentSubjectUnawarenessesRun1) mean(currentSubjectUnawarenessesRun2) mean(currentSubjectUnawarenessesRun3) mean(currentSubjectUnawarenessesRun4) mean(currentSubjectUnawarenessesRun5) mean(currentSubjectUnawarenessesRun6)];
    currentSessionUnawareness = currentSessionUnawareness * 100;
    allSessionRunsUnawareness = [allSessionRunsUnawareness; currentSessionUnawareness];
    currentSessionAwareness = [mean(currentSubjectAwarenessesRun1) mean(currentSubjectAwarenessesRun2) mean(currentSubjectAwarenessesRun3) mean(currentSubjectAwarenessesRun4) mean(currentSubjectAwarenessesRun5) mean(currentSubjectAwarenessesRun6)];
    currentSessionAwareness = currentSessionAwareness * 100;
    allSessionRunsAwareness = [allSessionRunsAwareness; currentSessionAwareness];
    allSessionRunsDays = [allSessionRunsDays; text(2,session)];
end

save('allSessionRunAccuracyUnawarenessAwarenessConfidence.mat','allSessionRunsAwareness','allSessionRunsUnawareness','allSessionRunsConfidence','allSessionRunsAccuracy','allSessionRunsDays')


