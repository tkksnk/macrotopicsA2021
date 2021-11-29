global beta gamma alpha capital vfcn kgrid

%% *** カリブレーション ***
beta  = 0.96; % 割引因子
gamma = 1.0;  % 相対的危険回避度(異時点間の代替の弾力性の逆数)
alpha = 0.4;  % 資本分配率

% *** 離散化用のパラメータ ***
nk   = 11;    % グリッドの数
kmax =  1.0;  % 資本グリッドの最大値
kmin =  0.05; % 資本グリッドの最小値

%% グリッドポイントを計算
kgrid = linspace(kmin, kmax, nk)';

% *** 変数を定義 ***
TT   = 10;                % 無人島に滞在する期間
vfcn_mat = zeros(nk, TT); % 価値関数
pfcn_mat = zeros(nk, TT); % 政策関数
cfcn_mat = zeros(nk, TT); % 消費関数

%% 最終期(全てを消費)
pfcn_mat(:, TT) = 0; % 全て消費するので貯蓄はゼロ
cfcn_mat(:, TT) = kgrid.^alpha; % 生産=消費
vfcn_mat(:, TT) = CRRA(cfcn_mat(:, TT), gamma); % 消費から得られる効用

%% メインループ
for t = TT-1:-1:1

    fprintf('period %d: \n', t);

    for i = 1:nk

        % グローバル変数を設定
        % fminsearchで使う関数(BellmanEq)に最適化する変数"以外"の変数を渡す(グローバル変数を使わない方法もあるはず)
        capital = kgrid(i);
        vfcn = vfcn_mat(:, t+1);

        % MATLABの最適化関数(fminsearch)を使ってグリッド上で価値関数と政策関数の値を探す
        % 初期値は0.01
        [pfcn_mat(i, t), vfcn_mat(i, t)] = fminsearch(@BellmanEq, 0.01);

    end

    % 消費関数を計算(必ずしも計算する必要はない)
    cfcn_mat(:, t) = kgrid.^alpha - pfcn_mat(:, t);

    % fminsearchは最小値を探す関数なので符号を反転させる
    vfcn_mat(:, t) = -1*vfcn_mat(:, t);

end

figure;
plot(kgrid, vfcn_mat(:,TT), '-', 'linewidth', 3); hold('on');
plot(kgrid, vfcn_mat(:,9), '-.', 'linewidth', 3);
plot(kgrid, vfcn_mat(:,8), '--', 'linewidth', 3);
plot(kgrid, vfcn_mat(:,7), ':', 'linewidth', 3);
plot(kgrid, vfcn_mat(:,1), '-', 'linewidth', 3); hold('off');
%title('価値関数', 'fontsize', 16);
xlabel('資本保有量：k_{t}', 'Fontsize', 16);
ylabel('価値関数：V_{t}(k_{t})', 'Fontsize', 16);
legend('10期', '9期', '8期', '7期', '1期', 'Location', 'SouthEast');
grid on;
set(gca,'Fontsize',16);