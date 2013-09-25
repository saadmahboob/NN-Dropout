clear;

% Load data to run through network
load('mnist_scaled.mat');

tr_idx = randsample(1:size(X,1),30000,false);
te_idx = setdiff(1:size(X,1),tr_idx);
te_idx = randsample(te_idx,10000,false);
Xtr = single(X(tr_idx,:));
Xte = single(X(te_idx,:));
Ytr = single(Y(tr_idx,:));
Yte = single(Y(te_idx,:));
Ytr_c = class_cats(Ytr);
Yte_c = class_cats(Yte);
clear X Y;

% Create the ShepNet instance
layer_dims = [size(Xtr,2) 500 500 250 size(Ytr,2)];
NET = SmoothNet(Xtr, Ytr, layer_dims, ActFunc(5), ActFunc(1));
NET.init_weights(0.1);

% Set whole-network regularization parameters
NET.weight_noise = 0.01;
NET.drop_rate = 0.10;
NET.drop_input = 0.00;

% Set per-layer regularization parameters
for i=1:numel(layer_dims),
    NET.layer_lams(i).lam_l1 = 0;
    NET.layer_lams(i).lam_l2 = 1e-4;
    NET.layer_lams(i).lam_grad = 5e-1;
    NET.layer_lams(i).lam_hess = 5e-1;
end

% Setup param struct for training the net
params = struct();
params.rounds = 30000;
params.start_rate = 0.1;
params.decay_rate = 0.1^(1 / params.rounds);
params.momentum = 0.9;
params.batch_size = 200;
% Regularization parameters
params.lam_l2 = 1e-4;
% Validation stuff
params.do_validate = 1;
params.Xv = Xte;
params.Yv = Yte;