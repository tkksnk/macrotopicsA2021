function resid = resid_two_period(a)

global w beta gamma rent

% 1���̌��E���p
if w - a > 0.0
    mu1 = mu_CRRA(w - a, gamma);
else
    % ������l�̏ꍇ�A�y�i���e�B��^���Ă��̒l���I�΂�Ȃ��悤�ɂ���
    mu1 = 10000.0;
end

% 2���̌��E���p
mu2 = mu_CRRA((1.0+rent)*a, gamma);

% �c��
resid = beta*(1.0+rent)*(mu2/mu1) - 1.0;