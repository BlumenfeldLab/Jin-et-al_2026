clear all
clc

%%
%psydatFileDirectory = 'C:\Users\dsj8\OneDrive - Yale University\Desktop\AoA_Data\AoA_EEG\';
[num text raw] = xlsread('Y:\HNCT_AoA_Study\AoA_Subjects\AoA_All_Subjs_Data.xlsx');
root = 'Y:\HNCT_AoA_Study\AoA_Subjects\';
badSession = 0;
allPercentiles = [];
allResults = [];
allSessions = [];
allSessionDays = [];

awarePreviousQuizzes_all = [];
unawarePreviousQuizzes_all = [];
for session = 1:length(text)
      try
         if isfile([psydatSaveDirectory '\' num2str(raw{3,session}) '_sliders_and_percentiles_timing.mat'])
             
             continue
         end
        awarePreviousQuizzes = [];
        unawarePreviousQuizzes = [];
        
        psydatSaveDirectory = [root '\' text{1,session} '\' text{2,session} '\']
        cd(psydatSaveDirectory)
        load([psydatSaveDirectory '\' num2str(raw{3,session}) '_sliders_and_percentiles.mat'])
        load([psydatSaveDirectory '\' num2str(raw{3,session}) '_python_timing_data.mat']);
        lateCount = 0;
        sliderSuccessesAllPercentilesTiming = [];
        sliderSuccessesAllPercentiles = sortrows(sliderSuccessesAllPercentiles,2);
        for item = 1:length(quizConfidences)
            if quizConfidences(item) ~= 9999
                sliderSuccessesAllPercentilesTiming = [sliderSuccessesAllPercentilesTiming; sliderSuccessesAllPercentiles(item - lateCount,:)];
            elseif quizConfidences(item) == 9999
                
                sliderSuccessesAllPercentilesTiming = [sliderSuccessesAllPercentilesTiming; [9999 item-lateCount NaN NaN]];
                lateCount = lateCount + 1;
            end
        end
        sliderSuccessesAllPercentilesTiming = [sliderSuccessesAllPercentilesTiming runNumbers' quizTimes'];
        
        

        
        awarePreviousQuizzes = [];
        unawarePreviousQuizzes = [];
        allPreviousQuizzes = [];
        quizProgression = [];
        for quiz = 1:length(sliderSuccessesAllPercentilesTiming)
            quizProgression = [quizProgression 0];
            if quiz == 1
                allPreviousQuizzes = [allPreviousQuizzes sliderSuccessesAllPercentilesTiming(quiz,6) - runFirstTTLTime(1)];
            end
            if quiz > 1
                if sliderSuccessesAllPercentilesTiming(quiz,5) > sliderSuccessesAllPercentilesTiming(quiz-1,5)
                    allPreviousQuizzes = [allPreviousQuizzes sliderSuccessesAllPercentilesTiming(quiz,6) - runFirstTTLTime(sliderSuccessesAllPercentilesTiming(quiz,5))];
                elseif sliderSuccessesAllPercentilesTiming(quiz,5) == sliderSuccessesAllPercentilesTiming(quiz-1,5)
                    allPreviousQuizzes = [allPreviousQuizzes sliderSuccessesAllPercentilesTiming(quiz,6) - sliderSuccessesAllPercentilesTiming(quiz-1,6)];
                end
            end
                
            if sliderSuccessesAllPercentilesTiming(quiz,3) > 75 && sliderSuccessesAllPercentilesTiming(quiz,4) == 1
                quizProgression(quiz) = 1;
                if quiz == 1
                    awarePreviousQuizzes = [awarePreviousQuizzes sliderSuccessesAllPercentilesTiming(quiz,6) - runFirstTTLTime(1)];
                end
                if quiz > 1
                    if sliderSuccessesAllPercentilesTiming(quiz,5) > sliderSuccessesAllPercentilesTiming(quiz-1,5)
                        awarePreviousQuizzes = [awarePreviousQuizzes sliderSuccessesAllPercentilesTiming(quiz,6) - runFirstTTLTime(sliderSuccessesAllPercentilesTiming(quiz,5))];
                    elseif sliderSuccessesAllPercentilesTiming(quiz,5) == sliderSuccessesAllPercentilesTiming(quiz-1,5)
                        awarePreviousQuizzes = [awarePreviousQuizzes sliderSuccessesAllPercentilesTiming(quiz,6) - sliderSuccessesAllPercentilesTiming(quiz-1,6)];
                    end
                end
            end
             if sliderSuccessesAllPercentilesTiming(quiz,3) < 25 && sliderSuccessesAllPercentilesTiming(quiz,4) == 0
                quizProgression(quiz) = 2;
                 if quiz == 1
                    unawarePreviousQuizzes = [unawarePreviousQuizzes sliderSuccessesAllPercentilesTiming(quiz,6) - runFirstTTLTime(1)];
                end
                if quiz > 1
                    if sliderSuccessesAllPercentilesTiming(quiz,5) > sliderSuccessesAllPercentilesTiming(quiz-1,5)
                        unawarePreviousQuizzes = [unawarePreviousQuizzes sliderSuccessesAllPercentilesTiming(quiz,6) - runFirstTTLTime(sliderSuccessesAllPercentilesTiming(quiz,5))];
                    elseif sliderSuccessesAllPercentilesTiming(quiz,5) == sliderSuccessesAllPercentilesTiming(quiz-1,5)
                        unawarePreviousQuizzes = [unawarePreviousQuizzes sliderSuccessesAllPercentilesTiming(quiz,6) - sliderSuccessesAllPercentilesTiming(quiz-1,6)];
                    end
                end
             end
        end
        awarePreviousQuizzes_all = [awarePreviousQuizzes_all awarePreviousQuizzes];
        unawarePreviousQuizzes_all = [unawarePreviousQuizzes_all unawarePreviousQuizzes];
        eval(['save ' psydatSaveDirectory '\' num2str(raw{3,session}) '_sliders_and_percentiles_timing.mat sliderSuccessesAllPercentilesTiming'])
        eval(['save ' psydatSaveDirectory '\' num2str(raw{3,session}) '_previous_quizzes.mat awarePreviousQuizzes unawarePreviousQuizzes allPreviousQuizzes quizProgression'])
      catch
         continue
     end
end

