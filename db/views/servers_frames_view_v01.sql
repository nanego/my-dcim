select id, name, 'Server' as record_type from servers
union all
select id, name, 'Frame' as record_type from frames