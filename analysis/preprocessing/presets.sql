/* 간편결제 가맹점 리스트 */
select distinct approval_store from payments where card_payment_type = 'PA';

/* 간편결제 비가맹점, 가맹점별 결제금액 합 상위 200 */
select approval_store, sum(approval_price) from payments where approval_store not in (select distinct approval_store from payments where card_payment_type in ('PA', 'SP')) group by approval_store order by sum(approval_price) desc limit 200;

/* 간편결제 비가맹점, 가맹점별 패널 수 상위 200 */
select approval_store, count(distinct panel_id) from payments where approval_store not in (select distinct approval_store from payments where card_payment_type in ('PA', 'SP')) group by approval_store order by count(distinct panel_id) desc limit 200;

/* 간편결제 비가맹점, 가맹점별 패널 수와 결제금액 합 (PBK 제외) */
select approval_store, count(distinct panel_id), sum(approval_price) from payments where approval_store not in (select distinct approval_store from payments where card_payment_type in ('PA', 'SP')) and card_payment_type != 'PBK' group by approval_store having count(distinct panel_id) > 30 order by count(distinct panel_id) desc;

/* 간편결제 비가맹점, 가맹점별 패널 수와 결제금액 합 (PBK 제외, 가맹점 이름에 '교통' 이 포함된 결제건 제외) */
select approval_store, count(distinct panel_id), sum(approval_price) from payments where approval_store not in (select distinct approval_store from payments where card_payment_type in ('PA', 'SP')) and card_payment_type != 'PBK' and approval_store not like '%교통%' group by approval_store having count(distinct panel_id) > 30 order by count(distinct panel_id) desc;
