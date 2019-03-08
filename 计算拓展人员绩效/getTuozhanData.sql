CREATE DEFINER=`admintf`@`%` PROCEDURE `getTuozhanData`(
in client_name nvarchar(255),
in mobile varchar(255),
in start_time datetime,
in end_time datetime
)
BEGIN
-- 注册人数
	declare registerCount int;
	declare certificateCount int;
	declare depositCount int;
	declare orderCount int;
	
	select count(*)
	from re_client_invite ci
	left join re_client c on ci.client_code = c.client_code
	where c.mobile = mobile
	and ci.create_time >= start_time
	and ci.create_time <= end_time
  into registerCount;

-- 上传证件人数
select count(*)
	from
	(
	select ci.*
	from re_client_invite ci
	left join re_client c on ci.client_code = c.client_code
	where c.mobile = mobile
	and ci.create_time >= start_time
	and ci.create_time <= end_time
	) a left join re_client b on a.invite_client_code = b.client_code
	where (b.auditing_status <> 0 || b.card_auditing_status <> 0)
into certificateCount;

-- 交押金人数
select count(*)
	from
	(
	select ci.*
	from re_client_invite ci
	left join re_client c on ci.client_code = c.client_code
	where c.mobile = mobile
	and ci.create_time >= start_time
	and ci.create_time <= end_time
	) a left join re_client b on a.invite_client_code = b.client_code
	where (b.auditing_status <> 0 || b.card_auditing_status <> 0)
	and b.deposit_sta = 1
into depositCount;

-- 下订单人数
		select count(*)
	from
	(
	select ci.*
	from re_client_invite ci
	left join re_client c on ci.client_code = c.client_code
	where c.mobile = mobile
	and ci.create_time >= start_time
	and ci.create_time <= end_time
	) a left join re_client b on a.invite_client_code = b.client_code
	where (b.auditing_status <> 0 || b.card_auditing_status <> 0)
	and b.deposit_sta = 1
	and b.client_code in(select client_code from re_order where order_status <> 2)
into orderCount;

insert into an_tuozhan_performance(name,mobile,register_count,certificate_count,deposit_count,order_count,start_time,end_time) values(client_name,mobile,registerCount,certificateCount,depositCount,orderCount,start_time,end_time);

END