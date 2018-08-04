
function [reconstruct_score coeff] = pca_reconstruction(InputMatrix,PCA_decision,NumComponents)

% InputMatrix is a cell struct.
% InputMatrix{itrial}.data is the Q matrix: N(neurons) by T(time) data

% PCA_decision = 2

Ntrial = size(InputMatrix,2);

if NumComponents == 0 
    NumComponents = size(InputMatrix{1}.data,1);
end
    
if PCA_decision == 1 % do the PCA only based on the first trial.
    
    % do the first trial seperately
    [coeff,reconstruct_score{1},latent,tsquared,explained,mu1] = pca(InputMatrix{1}.data','NumComponents',NumComponents);
    
    for itr = 2:Ntrial
        % rawQ = score1*coeff' + repmat(mu1, size(score1,1),1);
        rawQ = InputMatrix{itr}.data';
        reconstruct_score{itr} = [rawQ - repmat(mean(rawQ), size(rawQ,1),1)]/coeff';
    end
    
else
    
    %concatenate all trials together to get a single big matrix for PCA analysis     
    allQ = [];
    for itr = 1:Ntrial
        allQ = [allQ;InputMatrix{itr}.data'];
    end
        
     % do the pca based on the data from all trials
    [coeff,score,latent,tsquared,explained,mu1] = pca(allQ,'NumComponents',NumComponents);
       
     for itr = 1:Ntrial
        % rawQ = score1*coeff' + repmat(mu1, size(score1,1),1);
        rawQ = InputMatrix{itr}.data';
        reconstruct_score{itr} = [rawQ - repmat(mean(rawQ), size(rawQ,1),1)]/coeff';
    end  
end

end








% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Some notes:
%
% % The concept comes from this following paper Haxby, J. V., Connolly, A.
% % C., & Guntupalli, J. S. (2014). Decoding Neural Representational Spaces
% % Using Multivariate Pattern Analysis. Annual Review of Neuroscience,
% % 37(1), 435?456. http://doi.org/10.1146/annurev-neuro-062012-170325
%
% % This approach makes most sense when we would like to decode the
% % data pattern. However, if we do not want to decode behaivoral pattern,
% % the multiplication of Neural by Time (Q) matrix with a Behavioral (B)
% % matrix is not necessary.
% %
%
% close all
% clear all
% %load example data
% load T_maze_demo.mat pos1 Q1
%
% % Pos1 is a vector describing where the animial is at each time point.
% % Q1 is a vector how each neuron responds at each time point
%
% %% B (Behavioral) matrix --> Time by location maxtrix  T by L
% pos1.data; % location data, can be binned data
% pos1.tvec;  % time data, can be bined data
%
% % pos1.data generate random location
% %pos1.data(5001:end) = randi(100,1,5000);
%
% [N,Xedges,Yedges] = histcounts2(pos1.tvec,pos1.data,1:10001,1:11);
%
% B=[];
% for it = 1:size(pos1.tvec,2)
%     for ic = 1:100
%         if pos1.data(it) ==ic
%             B(it,ic) = 1;
%         else
%             B(it,ic) = 0;
%         end
%     end
% end
% figure(1);subplot(1,4,1);imagesc(B');
% title('Behavioral Matrix: Location by Time')
%
% %% Q matrix --> neuron  by Time  matrix  size(Q1) N by T
% Q = Q1(:,1:10000); % 10 by 10000 by one trial; the Q1 matrix has 5 trials
% figure(1);subplot(1,4,2);imagesc(Q);
% title('Neuron Matrix: Neuronal spike by Time')
%
%
% %% R matrix --> Q*B  Neuron by location matrix N by L
% R = B'*Q';
% figure(1);subplot(1,4,3);imagesc(R);
% title('Representaitonal Matrix: Neuronal By loction')
%
%
% %% reduce the factors (neurons) to 3 major components
% [reducedR scoreR] = pca(R,'NumComponents',10);
%
% steps=size(scoreR,1)/20;
%
% for i=1:size(scoreR,1)/steps
% figure(1);subplot(1,4,4);
% plot3(scoreR([1:steps*i-10],1),scoreR([1:steps*i-10],2),scoreR([1:steps*i-10],3),'r.');
% axis([min(scoreR(:,1)) max(scoreR(:,1)) min(scoreR(:,2)) max(scoreR(:,2)) min(scoreR(:,3)) max(scoreR(:,3))]);
% hold on; WaitSecs(0.01)
% title('Dimension reduction to 3 components: Based on the Q matrix')
% end
%
%
%
% %% What if we reduce the dimensionality only based on the Q matrix
%
% [reducedR scoreR] = pca(Q','NumComponents',10);
%
% steps=size(scoreR,1)/200;
%
% for i=1:size(scoreR,1)/steps
% figure(2);
% plot3(scoreR([1:steps*i-10],1),scoreR([1:steps*i-10],2),scoreR([1:steps*i-10],3),'r.');
% axis([min(scoreR(:,1)) max(scoreR(:,1)) min(scoreR(:,2)) max(scoreR(:,2)) min(scoreR(:,3)) max(scoreR(:,3))]);
% hold on; WaitSecs(0.01)
% title('Dimension reduction to 3 components: Based on the Q matrix')
% end
%
%
%
%
%
% %% 5 trials data
%
% Qtrail{1} = Q1(:,1:10000);
% Qtrail{2} = Q1(:,10001:20000);
% Qtrail{3} = Q1(:,20001:30000);
% Qtrail{4} = Q1(:,30001:40000);
% Qtrail{5} = Q1(:,40001:50000);
%
%
% [coeff,score1,latent,tsquared,explained,mu1] = pca(Qtrail{1}','NumComponents',10);
%
% % rawQ = score1*coeff' + repmat(mu1, size(score1,1),1);
%
% rawQ = Qtrail{2}';
% reconstruct_score = [rawQ - repmat(mean(rawQ), size(score1,1),1)]/coeff';
%
%
%
%
% %%
%
% % [reducedR scoreR] = pca(Q','NumComponents',10);
%
%
% scoreR = reconstruct_score;
% steps=size(scoreR,1)/200;
%
% for i=1:size(scoreR,1)/steps
% figure(2);hold on;
% plot3(scoreR([1:steps*i-10],1),scoreR([1:steps*i-10],2),scoreR([1:steps*i-10],3),'.');
% % axis([min(scoreR(:,1)) max(scoreR(:,1)) min(scoreR(:,2)) max(scoreR(:,2)) min(scoreR(:,3)) max(scoreR(:,3))]);
% hold on; WaitSecs(0.01)
% title('Dimension reduction to 3 components: Based on the Q matrix')
% end
%
% % goodness of fit
