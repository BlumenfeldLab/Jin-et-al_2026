clear all
clc
%%
location = 'l'
if strcmp(location,'s')
    [num text raw] = xlsread('/mnt/Data27/HNCT_AoA_Study/AoA_Subjects/AoA_ERP_Quizzes_Then_Choose.xlsx');
elseif strcmp(location,'l')
    [num text raw] = xlsread('Y:\HNCT_AoA_Study\AoA_Subjects/AoA_ERP_Quizzes_Then_Choose.xlsx');
end


for session = 1:length(text)
    
    fileLocation = [root '/' text{1,session} '/' text{2,session} '/']
    sessionDate = num2str(num(1,session))
    
    if ~isfile([fileLocation sessionDate '_event_times_and_types.mat'])
        try
            load([fileLocation sessionDate '_Merged_EGI.mat'])
        catch
            load([fileLocation sessionDate '_EGI.mat'])
        end
        
        Event_Types = {EEG.event.type}.';
        Event_Times = {EEG.event.latency}.';
    end
end
