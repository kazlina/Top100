select all_gpms_and_rayting.gpm_id, all_gpms_and_rayting.rayting from
(
	-- select all gpms and it's raiting
		select last_profiles.gpm_id as gpm_id, rayting/count_posts as rayting from
		(
		-- select profiles which were updated last
			SELECT gpm as gpm_id, count(gpm) as count_posts
			FROM post 
			group by post.gpm
		) last_profiles
		left join
		-- select gpm id and his post-weight
		(
			select post.gpm as gpm_id, (sum(nPlusOne)*1 + sum(nComment)*5 + sum(nResharers)*20) as rayting 
			from post
			group by post.gpm
		) as post_rayting
		on last_profiles.gpm_id = post_rayting.gpm_id
		order by rayting desc
) as all_gpms_and_rayting
left join blacklist
on blacklist.id = all_gpms_and_rayting.gpm_id -- select thouse gpms, who are not in black list
where blacklist.id is null
limit 100;