with unified_ads as (
    select
        ad_date,
        url_parameters,
        coalesce(spend, 0) as spend,
        coalesce(impressions, 0) as impressions,
        coalesce(reach, 0) as reach,
        coalesce(clicks, 0) as clicks,
        coalesce(leads, 0) as leads,
        coalesce(value, 0) as value
    from facebook_ads_basic_daily
    union all
    select
        ad_date,
        url_parameters,
        coalesce(spend, 0),
        coalesce(impressions, 0),
        coalesce(reach, 0),
        coalesce(clicks, 0),
        coalesce(leads, 0),
        coalesce(value, 0)
    from google_ads_basic_daily
),
prepared as (
    select
        ad_date,
        url_parameters,
        case
            when url_parameters is null then null
            when not (url_parameters ~ 'utm_campaign=') then null
            else nullif(lower(split_part(split_part(url_parameters, 'utm_campaign=', 2), '&', 1)), 'nan')
        end as utm_campaign,
        spend,
        impressions,
        clicks,
        value
    from unified_ads
),
monthly as (
    select
        date_trunc('month', ad_date)::date as ad_month,
        utm_campaign,
        sum(spend)       as total_cost,
        sum(impressions) as number_of_impressions,
        sum(clicks)      as number_of_clicks,
        sum(value)       as conversion_value,
        case
            when sum(impressions) = 0 then null
            else (sum(clicks)::numeric * 100) / sum(impressions)::numeric
        end as ctr,
        case
            when sum(clicks) = 0 then null
            else sum(spend)::numeric / sum(clicks)::numeric
        end as cpc,

        case
            when sum(impressions) = 0 then null
            else (sum(spend)::numeric * 1000) / sum(impressions)::numeric
        end as cpm,
        case
            when sum(spend) = 0 then null
            else ((sum(value)::numeric - sum(spend)::numeric) * 100)
                 / sum(spend)::numeric
        end as romi
    from prepared
    group by 1, 2
)
select
    ad_month,
    utm_campaign,
    total_cost,
    number_of_impressions,
    number_of_clicks,
    conversion_value,
    ctr,
    cpc,
    cpm,
    romi,
    ((cpm - lag(cpm) over (partition by utm_campaign order by ad_month)) * 100) / nullif(lag(cpm) over (partition by utm_campaign order by ad_month), 0) as cpm_per_diff,
    ((ctr - lag(ctr) over (partition by utm_campaign order by ad_month)) * 100) / nullif(lag(ctr) over (partition by utm_campaign order by ad_month), 0) as ctr_per_diff,
    ((romi - lag(romi) over (partition by utm_campaign order by ad_month)) * 100) / nullif(lag(romi) over (partition by utm_campaign order by ad_month), 0) as romi_per_diff
from monthly
order by ad_month desc, utm_campaign;
