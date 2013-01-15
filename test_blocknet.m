% Generate some simple data with which to test the SimpleNet class
obs_dim = 5;
obs_count = 2500;
train_count = 500;
obs_noise = 0.0;
label_noise = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate observations and labels by some random process %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% b = randn(obs_dim, 1);
% X = randn(obs_count, obs_dim);
% Y = sign(X*b);
% % Add noise to observations and labels
% X = X + (randn(size(X)) .* obs_noise);
% for i=1:numel(Y),
%     if (rand() < label_noise)
%         Y(i) = -Y(i);
%     end
% end

[ Xi Yi ] = data_grid( obs_count, 0.35, 0.45, 4, 4 );
for i=1:numel(Yi),
    if (rand() < label_noise)
        Yi(i) = -Yi(i);
    end
end
X = ZMUV([Xi randn(obs_count,obs_dim-2)]);
Y = zeros(obs_count, 2);
for i=1:obs_count,
    if (Yi(i) == 1)
        Y(i,1) = 1;
        Y(i,2) = -1;
    else
        Y(i,1) = -1;
        Y(i,2) = 1;
    end
end

% Split data into training and testing portions
X_tr = X(1:train_count,:);
X_te = X(train_count+1:end,:);
Y_tr = Y(1:train_count,:);
Y_te = Y(train_count+1:end,:);

% Use sigmoid activation in hidden layers, linear activation in output layer,
% and binomial-deviance loss at output layer.
act_func = ActFunc(2);
out_func = ActFunc(1);
loss_func = LossFunc(3);
% Create the network object
net = BlockNet(act_func, out_func, loss_func);
% Setup blocky parameters
layer_bsizes = [1 5 5 5 1];
layer_bcounts = [obs_dim 15 15 15 2];

% Set up parameter struct for updates
params = struct();
params.epochs = 10000;
params.start_rate = 1.0;
params.decay_rate = 0.2^(1 / params.epochs);
params.momentum = 0.5;
params.weight_bound = 50;
params.batch_size = 100;
params.batch_rounds = 1;
params.dr_obs = 0.0;
params.do_validate = 1;
params.X_v = X_te;
params.Y_v = Y_te;






%%%%%%%%%%%%%%
% EYE BUFFER %
%%%%%%%%%%%%%%