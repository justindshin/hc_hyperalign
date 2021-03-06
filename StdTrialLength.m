function [AdjSig] = SignalChop(TrialStart,TrialEnd,t,signal)
% This function truncates the signal based on one of two options; chopping
% the signal based on the start and end point of a traversal through space
% or by modifying the length of the signal in samples (i.e. time)
%   Detailed explanation goes here
%       Inputs
%           trial start
%           trial end
%           sampling rate
%           timestamps
%           signal
%       Outputs
%           1)signal for a given trial between start and end times
%           2)adjusted signal of shortest signal to match longest
%           3)adjusted signal of longest signal to match shortest
%


t = linspace(t(TrialStart(1,1)),t(TrialEnd(1,end)),length(signal));

AdjSig = signal(t(1,1),t(1,end));

end

