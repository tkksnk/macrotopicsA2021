function value = obj_two_period(a)

global w beta gamma rent

% 1���̌��p����
if w - a > 0.0
    util_y = CRRA(w - a, gamma); 
else
    % ������l�̏ꍇ�A�y�i���e�B��^���Ă��̒l���I�΂�Ȃ��悤�ɂ���
    util_y = -1000000.0;
end

% 2���̌��p����
util_o = beta*CRRA((1.0+rent)*a, gamma);

% fminbnd��fminsearch�͋���"�ŏ��l"��T�����߁A�}�C�i�X�������Ĕ��]������
value = -1.0*(util_y + util_o);