--优化前
select 
	count(distinct pv2.request_uri_uuid)
from
	(select 
		request_uri_uuid
	from pv
	where month=201703
	) pv1
join
	(select 
		request_uri_uuid
	from pv
	where month=201704
	) pv2 
on pv1.request_uri_uuid=pv2.request_uri_uuid
--优化后
select 
	count(1)
from
	(select request_uri_uuid
	from pv
	where month=201703 and request_uri_uuid!='-' 
	group by request_uri_uuid
	) pv1
join
	(select request_uri_uuid
	from pv
	where month=201704 and request_uri_uuid!='-' 
	group by request_uri_uuid
	) pv2 
on pv1.request_uri_uuid=pv2.request_uri_uuid
--distinct 再reduce端进行，group by 在map端进行，优化前大量的数据查询出来以后全部放到reduce端进行，影响速度。
--使用group by 在map端优化减小reduce压力，尽量去除不用数据，减小数据量