--月留存，1月再2、3、4......月份的留存，2月在3、4、5......月份的留存......
--方法：两次相同的查询，取出月份和留存项，join关联，两次查询的月份相减（第几月的留存）
select
	months_between(t_post.create_at,t_post_keep.create_at) as differ,	
	t_post_keep.create_at,
	t_post.create_at,
	count(t_post.company_id)	
from
	(select 
		from_unixtime(create_at,'yyyy-MM-01') as create_at,
		company_id
	from ods.ods_jz_post_hourly
	where source in (0,6,42,43,44,1000) and from_unixtime(create_at,'yyyyMM')>=201510
	group by from_unixtime(create_at,'yyyy-MM-01'),company_id
	)t_post
join 
	(select 
		from_unixtime(create_at,'yyyy-MM-01') as create_at,
		company_id
	from ods.ods_jz_post_hourly
	where source in (0,6,42,43,44,1000) and from_unixtime(create_at,'yyyyMM')>=201510
	group by from_unixtime(create_at,'yyyy-MM-01'),company_id
	)t_post_keep
on t_post_keep.company_id=t_post.company_id
group by t_post_keep.create_at,t_post.create_at,months_between(t_post.create_at,t_post_keep.create_at)
having differ>=0
order by months_between(t_post.create_at,t_post_keep.create_at) asc 