%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load and "preprocess" MNIST digit data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('mnist_data.mat');
X = X_mnist;
Y = Y_mnist;
X = X((Y==2)|(Y==4)|(Y==1),:);
Y = Y((Y==2)|(Y==4)|(Y==1),:);
X = ZMUV(double(X));
Y_vals = unique(Y);
Ym = -ones(size(X,1),numel(Y_vals));
for i=1:size(X,1),
    for j=1:numel(Y_vals),
        if (Y(i) == Y_vals(j))
            Ym(i,j) = 1;
        end
    end
end
Y = Ym;

obs_dim = size(X,2);
out_dim = size(Y,2);
obs_count = size(X,1);
train_count = round(obs_count * 0.5);

% Split data into training and testing portions
tr_idx = randsample(obs_count,train_count,false);
te_idx = setdiff(1:obs_count,tr_idx);
X_tr = X(tr_idx,:);
X_te = X(te_idx,:);
Y_tr = Y(tr_idx,:);
Y_te = Y(te_idx,:);

% Use sigmoid activation in hidden layers, linear activation in output layer,
% and binomial-deviance loss at output layer.
act_func = ActFunc(2);
out_func = ActFunc(1);
loss_func = LossFunc(3);
layer_sizes = [obs_dim 2*obs_dim 2*obs_dim out_dim];

% Generate a SimpleNet instance
net = SimpleNet(layer_sizes, act_func, out_func, loss_func);
net.init_weights(0.1);

% Set up parameter struct for updates
params = struct();
params.epochs = 5000;
params.start_rate = 1.0;
params.decay_rate = 0.1^(1 / params.epochs);
params.momentum = 0.5;
params.weight_bound = 10;
params.batch_size = 100;
params.batch_rounds = 1;
params.dr_obs = 0.0;
params.dr_node = 0.5;
params.do_validate = 1;
params.X_v = X_te;
params.Y_v = Y_te;






%%%%%%%%%%%%%%
% EYE BUFFER %
%%%%%%%%%%%%%%