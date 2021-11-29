function resid = resid_projection(coef)

global grid_w beta gamma rent

% 係数thetaを使って政策関数を計算
a = coef(1) + coef(2)*grid_w;

% 各wにおける1期の消費水準を計算
c1 = grid_w - a;

[r,c] = size(c1);
ng    = max(r,c);

% 1期における限界効用
mu1 = zeros(ng,1);
for i = 1:ng
    if c1(i) > 0.0
        mu1(i) = mu_CRRA(c1(i), gamma);
    else
        % 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
        mu1(i) = 10000.0;
    end
end

% 2期の消費水準
c2 = (1.0+rent).*a;

% 2期における限界効用
mu2 = zeros(ng,1);
for i = 1:ng
    if c2(i) > 0.0
        mu2(i) = mu_CRRA(c2(i), gamma);
    else
        mu2(i) = 10000.0;
    end
end

% 残差
resid = beta*(1.0+rent)*(mu2./mu1) - 1.0;
% （残差の絶対値の総和を最小化）
resid = sum(abs(resid));