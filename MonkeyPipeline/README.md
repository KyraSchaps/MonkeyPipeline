MonkeyPipeline
This is all the code I use to do the pipeline of neural analysis on monkey data. 
It has some path dependencies, but if everything is set and you run 'Pipeline':
 Run through all .mat files in "DataToParse2" and 
    Get a behavioral Psychometric curve with fit H rates
    For each neuron:
        Plot PETH for High H and Low H for each possible evidence and either Targ 1 recently active or Targ 2 recently active3
            Note: For Low H, Active must be active for at least 5 trials, for High H, split by active on last trial
        Plot PETH as above with further breakdown by 
            Correct or Incorrect
            Switch or Stay
            Chose 1 or Chose 2
        Plot for Visual, Memory, and Motion periods the mean FR and a VM fit
    Produce a Folder with the same name as the session with all the figures saved with and with a .mat
        File called "Collection" that contains the fits and number of trials used for each line in the figures
