%caraslab_intanPhys_pipeline.m
%
%This pipeline transforms raw -openEphys data into -dat format, 
% highpass filters the data and applies common average referencing before
% sorting with kilosort 2.

% Note that this pipeline was designed to be modular, i.e. you run one bit
% at a time and you can add/remove/replace modules 

% Wrtten by M Macedo-Lima; April 2021

%% Set your paths

% Behaviordir: Where the ePsych behavior files are; -mat files will be
%   combined into a single file. Before running this, group similar sessions
%   into folders named (for example): 
%   shock_training, psychTesting_prePassive, psychTesting_active, psychTesting_postPassive

% Tankdir: Where your Raw ephys files are; This path should be a
%   subject's folder with subfolder representing different recording sessions

% Savedir: Where you wish to save the processed files

% chanMapSavedir: where your channel maps are

% Probetype: what kind of channel map you are using
%   Only the following have been set up for Intan:
%               'NNBuz5x1264':      Neuronexus Buzsaki 5x12 H64LP
%               'NNA4x16Lin64':     Neuronexus A4x16 Poly2 Linear H64LP
%               'NNoptrodeLin4':    Neuronexus Qtrode-Linear

% rootH: path for temp Kilosort file. Should be a fast SSD


Behaviordir = '/mnt/CL_4TB_2/Matt/OFC_PL_recording/matlab_data_files';

% OFC PL
% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-231';
% Savedir =  '/mnt/CL_4TB_2/Matt/OFC_PL_recording/Sorting/SUBJ-ID-231'; 
% Probetype = 'NNA4x16Lin64';
% badchannels = [];
% 
% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-232';
% Savedir =  '/mnt/CL_4TB_2/Matt/OFC_PL_recording/Sorting/SUBJ-ID-232'; 
% Probetype = 'NNA4x16Lin64';
% badchannels = [];

% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-270';
% Savedir =  '/mnt/CL_4TB_2/Matt/OFC_PL_recording/Sorting/SUBJ-ID-270'; 
% Probetype = 'NNA4x16Lin64';
% badchannels = [];
% % % 
% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-389';
% Savedir =  '/mnt/CL_4TB_2/Matt/OFC_PL_recording/Sorting/SUBJ-ID-389'; 
% Probetype = 'NNA4x16Lin64';
% badchannels = [];

% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-390';
% Savedir =  '/mnt/CL_4TB_2/Matt/OFC_PL_recording/Sorting/SUBJ-ID-390'; 
% Probetype = 'NNA4x16Lin64';
% badchannels = [];

% Acute opto
% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-83';
% Savedir =  '/mnt/CL_4TB_2/Matt/Acute_opto_recordings/SUBJ-ID-83'; 
% Probetype = 'NNoptrodeLin4';
% % Probetype = 'NNBuz5x1264';
% % goodchannels = [17:28, 37:46, 948];
% % badchannels = setdiff(1:64, goodchannels);  % only shank 1 and 5 good
% badchannels = [];
% 
% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-84';
% Savedir =  '/mnt/CL_4TB_2/Matt/Acute_opto_recordings/SUBJ-ID-84'; 
% Probetype = 'NNoptrodeLin4';
% % Probetype = 'NNBuz5x1264';
% % goodchannels = [17:28, 37:46, 948];
% % badchannels = setdiff(1:64, goodchannels);  % only shank 1 and 5 good
% badchannels = [];

% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-85';
% Savedir =  '/mnt/CL_4TB_2/Matt/Acute_opto_recordings/SUBJ-ID-85'; 
% Probetype = 'NNoptrodeLin4';
% badchannels = []; 

% 
% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-175';
% Savedir =  '/mnt/CL_4TB_2/Matt/Acute_opto_recordings/SUBJ-ID-175'; 
% Probetype = 'NNoptrodeLin4';
% badchannels = [1]; 

% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-109';
% Savedir =  '/mnt/CL_4TB_2/Matt/Acute_opto_recordings/SUBJ-ID-109'; 
% Probetype = 'NNoptrodeTet4';
% badchannels = []; 
% 
% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-176';
% Savedir =  '/mnt/CL_4TB_2/Matt/Acute_opto_recordings/SUBJ-ID-176'; 
% Probetype = 'NNoptrodeTet4';
% badchannels = []; 
% 
% Tankdir = '/mnt/CL_8TB_3/temp_tank/SUBJ-ID-325';
% Savedir =  '/mnt/CL_4TB_2/Matt/Acute_opto_recordings/SUBJ-ID-325'; 
% Probetype = 'NNoptrodeLin4';
% badchannels = []; 

% 154's shock training was with intan
% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-154';
% Savedir =  '/mnt/CL_4TB_2/Matt/OFC_PL_recording/Sorting/SUBJ-ID-154-210428-131310'; 
% Probetype = 'NNA4x16Lin64';
% badchannels = [];

% OFCMuscimol + ACx recordings
% Behaviordir = '/mnt/CL_8TB_3/Matheus/Ephys recordings/OFC-Cannula_ACx-Electrode/matlab_data_files';

% Tankdir = '/mnt/CL_4TB_2/temp_tanks/SUBJ-ID-423';
% Savedir =  '/mnt/CL_4TB_2/Matt/OFCmuscimol_ACxrecording/Sorting/SUBJ-ID-423'; 
% Probetype = 'NNBuz5x1264';
% badchannels = [];
% 
% Tankdir = '/mnt/CL_8TB_3/temp_tank/SUBJ-ID-448';
% Savedir =  '/mnt/CL_8TB_3/Matheus/Ephys recordings/OFC-Cannula_ACx-Electrode/Sorting/SUBJ-ID-448'; 
% Probetype = 'NNBuz5x1264';
% badchannels = [33:36, 55:57, 59:61, 63, 64];  % sh4 broken during surgery

Tankdir = '/mnt/CL_8TB_3/temp_tank/SUBJ-ID-575';
Savedir =  '/mnt/CL_8TB_3/Matheus/Ephys recordings/OFC-Cannula_ACx-Electrode/Sorting/SUBJ-ID-575'; 
Probetype = 'NNBuz5x1264';
badchannels = [18]; 

chanMapSavedir = '/home/matheus/Documents/caraslab-spikesortingKS2/channelmaps';
chanMap = [chanMapSavedir '/' Probetype '_intan.mat']; 

% path to temporary binary file for Kilosort (same size as data, should be on fast SSD)
rootH = '/home/matheus/Documents';

%% 1. MAKE A CHANNELMAP FILE
% This function creates a channel map for a specific electrode probe array.
%   You only need to run this function if the map for your specific probe
%   doesn't already exist.
caraslab_createChannelMap(chanMapSavedir,Probetype, 'intan');


%% 2. CONVERT RAW OPENEPHYS DATA TO *.DAT FILE
%   Function to reformat and save ephys data from OpenEphys GUI.
%
%   Input variables:
%       Tankdir:    path to source directory
%
%       Savedir:    path to directory where -mat and -csv files will be saved
%
%       sel:        if 0 or omitted, program will cycle through all BLOCKS
%                   in the tank directory. 
%                   
%                   if 1, user will be prompted to select a BLOCK
caraslab_reformat_OpenEphysGUI_data(Tankdir, Savedir, 'oe', 1:64, 65);


%% 3. Output timestamps info
% This pipeline takes ePsych .mat behavioral files, combines and analyzes them and
% outputs files ready for further behavioral analyses and for aligning
% timestamps with neural recordings
% This pipeline also incorporates ephys recordings
% in the processing to extract timestamps related to spout and stimulus
% delivery

% IMPORTANT: if behavior is relevant, run this now so that createconfig can
% extract information about how much of the beginning of the recording to 
% skip due to noise

% IMPORTANT 2: organize your behavior files into subfolders to be analyzed together , e.g.
% shockTraining_pre, shockTraining_active, psychTesting_active, psychTesting_muscimol etc
% select those folders when prompted (you can select multiple folders)

% IMPORTANT 3: Make sure that the ephys for all behavioral sessions has
% already been extracted before you run this. This code will attempt to
% match them by date and session time and unpredictable errors may occur if
% the target ephys folder is not present
caraslab_behav_pipeline(Savedir, Behaviordir, 'intan');


%% 4. CREATE KILOSORT CONFIGURATION FILE
% This function sets configuration parameters for kilosort. It also
%   establishes the binary path for each future binary dataset.

%   IMPORTANT: this function is a  'living' function, i.e. you should edit it
%   appropriately for every subject if necessary
% e.g. whether to CAR/comb filter; template size and more...
fetch_tstart_from_behav = 0;
caraslab_createconfig(Savedir,chanMap, badchannels, fetch_tstart_from_behav, 'intan')


%% 5. REMOVE ARTIFACTS AND FILTER
% This function takes .dat files and employs in this order:
% 1. Comb filter (if ops.comb==1)
% 2. Median-CAR filter (if ops.CAR==1)
% 3. Kilosort-inspired GPU-based chunkwise filter
% 4. Chunk-wise mean-std-based artifact remova                                                                      l (not optimal but helps)
% 5. Saves a filename_CLEAN.dat file
inspect_artifact_removal_only = 0;  % Beta version
caraslab_preprocessdat(Savedir, inspect_artifact_removal_only)


%% 6. CONCATENATE SAME DAY RECORDINGS
% This function searches the recording folders and concatenates *CLEAN.dat files
% within folders that have the same date in order of session number. A new file and directory will be
% created with Date_concat name (e.g. 201125_concat).
% This function also creates a config.mat within each concat folder with
% some useful parameters about the concatenation; plus it outputs a csv
% file with the continuous breakpoints where one file ends and another
% starts
caraslab_concatenate_sameDay_recordings(Savedir, chanMap, 'intan')


%% 7. CONCATENATE SAME DEPTH RECORDINGS ACROSS DAYS
% % not currently in use
% NchanTOT = 64;
% NT = 32832;  % A reasonable batch size. Reduce if out of memory
% caraslab_concatenate_sameDepth_recordings(Savedir, sel, NchanTOT, NT)


%% 8. RUN KILOSORT
%   This function runs kilosort on the selected data.
% rootH is the path to the kilosort temp file; Better if a fast SSD
caraslab_kilosort(Savedir, rootH)


%% 9. ELIMINATE NOISE
% Not currently in use

% NEED TO TWEAK PARAMETERS INSIDE THIS FUNCTION. DEFAULT (ALLEN INSTITUDE)
% PARAMETERS ARE GETTING RID OF GOOD CLUSTERS WITH THE NOISE

% This function eliminates noise by running an AllenInstitute python script
% I didn't translate it to MatLab, but instead adapted it to run from
% within MatLab by shutling variables back and forth from a python
% evironment; The Python-from-MatLab pipeline is a little clunky...
% py_code_folder = '/home/matheus/Documents/caraslab-spikesortingKS2-master/sortingQuality-master/helpers';
% id_noise_templates_wrapper(Savedir, 1, 1,0 py_code_folder)


%% 10. REMOVE DOUBLE-COUNTED SPIKES
% This function removes potential double-counted spikes detected by
% kilosort within one cluster and among clusters of the same shank (spikes within 0.15 ms are deleted)
% Can be run either right after kilosort or after manual curation.
% Adapted from the Allen Brain Institute github

% WARNING: setting this to 1 resets cluster numbers and messes up previous sorting
%               but restores original KS output
reload_original_npys = 0;

remove_double_counted_spikes(Savedir, reload_original_npys)


%% 11. GO HAVE FUN IN PHY!  
%         _             _   _                _ 
%        | |           | | (_)              | |
%   _ __ | |__  _   _  | |_ _ _ __ ___   ___| |
%  | '_ \| '_ \| | | | | __| | '_ ` _ \ / _ \ |
%  | |_) | | | | |_| | | |_| | | | | | |  __/_|
%  | .__/|_| |_|\__, |  \__|_|_| |_| |_|\___(_)
%  | |           __/ |                         
%  |_|          |___/                          


%% 12. EXTRACT SPIKE TIMES AND WAVEFORM MEASUREMENTS 
% This function retrieves timestamps and waveforms from phy files
% Outputs are .txt files with timestamps, .csv and .pdf files with waveform
% measurements and plots
% Because Kilosort2 likes 150Hz high-pass filtered data, this function will
% also refilter the data with a 300-6000Hz bandpass filter and save a new
% ~~CLEAN300Hz.dat
show_plots = 1;
filter_300hz = 1;
get_timestamps_and_wf_measurements(Savedir, show_plots, filter_300hz)


%% 13. EXTRACT WAVEFORMS PLOTS WITH PROBE GEOMETRY AND AUTOCORRELOGRAMS
% This function reads the probe geometry in channel map and outputs the
% spike means and SEM organized in space in a pdf. If filter_300hz==0, it will
% search for the 300hz bandpass filtered file. Otherwise, it will filter
% again
show_plots = 1;
filter_300hz = 0;
load_previous_gwfparams = 1;
plot_unit_shanks(Savedir, show_plots, filter_300hz, load_previous_gwfparams, 1, 1, 0)

%%
show_plots = 1;
filter_300hz = 0;
load_previous_gwfparams = 1;
plot_autocorrelograms(Savedir, show_plots, filter_300hz, load_previous_gwfparams)

%% 14. QUALITY METRICS
% This function runs 3 quality control metrics on the curated clusters:
% 1. ISI violation false positive rate: how many false positive spikes in a
%   cluster. Good units < 0.5
% 2. Fraction of spikes missing: based on the probability distribution of 
%   spikes detected for a unit, how many are estimated to be missing? Good
%   units < 0.1
% 3. Presence ratio: for how much of the recording is a unit present? The
%   recording time is divided in 100 bins and the fraction of bins with at
%   least one spike present is calculated. Good units > 0.9
% Adapted from the Allen Brain Institute github
show_plots = 1;
filter_300hz = 0;
load_previous_gwfparams = 1;
cluster_quality_metrics(Savedir, show_plots, filter_300hz, load_previous_gwfparams)


%% 15. UNIT TRACKING ACROSS DAYS
% This function implements an algorithm to detect unit survival across
% recording days from Fraser et al., 2011
% Only phy-good clusters are used
% You will need to compile relativeHist.c first
% The gist of the approach: 
% 1. Compare units within and between consecutive days using 4 metrics: 
%   a) autocorrelograms: computeDailyAutocorrelations.m
%   b) baseline firing: computeDailyBaserates.m
%   c) cross-correlograms: computeDailyCorrelations.m
%   d) waveform similarity: computeWaveScore.m
% 2. Define potential-same and definite-different unit groups by using a
% physical criterion such as different channel (original publication) or
% different shank (here)
% 3. Use the 4 scores to iteratively train a quadratic discriminant classifier using
% partially supervised expectation-maximization to fit a mixture of Gaussian models
% Essentially, we use the definite-different units (hard label) to dictate
% the shape of one of the Gaussian distributions and the classifier
% computes a 4-dimensional decision boundary to segregate the other
%
% Many modifications were done to their code to adapt their algorithm
% originally developed for tetrode recordings.
% Modifications are the following:
%   1. Waveforms on the same probe shank are treated as potential-same.
%   2. Recording duration adapts to noise removal information at the
%   beginning of recordings from the TDT recording system. Important in computeDailyBaserates
%   3. Probe geometry is a key factor in computeWaveScore. Waveforms are
%   compared between and across all channels (e.g. 16x16 comparisons in a 16ch shank)
%   In these, I implemented a weighted Euclidean distance to confer more
%   weight to comparisons between closer channels and maximum weight to
%   same-channel comparisons

% IMPORTANT: This code cannot be trusted 100% yet; After running, make sure to
% inspect every waveform survival plot and make manual changes to the
% unitSurvival.csv file (i.e., change a unit's new survival code) if you find
% spurious grouping

show_plots = 1;
filter_300hz = 0;
load_previous_gwfparams = 1;
fraser_unit_tracker_wrapper(Savedir, show_plots, filter_300hz, load_previous_gwfparams, chanMap)

%% 16. PCA ACROSS DAYS
% This function loops through recording folders and compares waveforms.
% Option to compare firing rates and autocorrelograms between
% consecutive days if they occured on the same shank.
show_plots = 1;
filter_300hz = 0;
load_previous_gwfparams = 1;
wf_pca_across_days(Savedir, show_plots, filter_300hz, load_previous_gwfparams)

%% 17. Extract and compile data for batch analyses into parent directory
% This function loops through recording folders and extracts all relevant
% files into a folder called Data inside the parent directory. The purpose
% is to centralize all subjects' data into common directories
compile_data_for_analyses(Savedir)