/*
  Creates a list of brands and the number of cars with related articles. For example:

  BrandName             Electric    Hybrid  Combustion  Total
  1A FIRST AUTOMOTIVE   167         1265    108734      110171

  1A has articles that fit 167 electric vehicles and 1265 hybrid vehicles. 
*/

SELECT

manu.[Name] as "BrandName",
/*
manu.[ArticleBrand:Link],
td_art.[Manufacturer:Link],
manu.[TecDoc.Link],
td_art.[DataSupplier:Link],
*/
--td_art.ArticleNo,
SUM(td_pcl.Electric) as Electric,
SUM(td_pcl.Hybrid) as Hybrid,
SUM(td_pcl.Combustion) as Combustion,
SUM(td_pcl.Total) as Total

FROM [K24Pdm].[dbo].[MasterData.Manufacturers] manu
-- Add TecDoc articles
   INNER JOIN dbo.[TecDoc.Articles.Articles] td_art ON manu.[TecDoc.Link] = td_art.[DataSupplier:Link] -- manu.[ArticleBrand:Link] = td_art.[Manufacturer:Link]

INNER JOIN (

SELECT
   td_pcl.[Article:Link],
   SUM(EV) as Electric,
   SUM(HV) as Hybrid,
   SUM(CE) as Combustion,
   COUNT(td_pcl.[Article:Link]) as "Total"

FROM dbo.[TecDoc.Linkages.PassengerCars] td_pcl 
-- Get the different vehicles by engine type
   JOIN (
       	 SELECT
            td_pc.PassengerCarNo,
            (CASE 
			   WHEN td_pc.ImportVersionNo = '20210401'
			        AND
			        td_pc.[EngineType:Link] = ('80-040')
					AND
					td_pc.[FuelType:Link] = '182-011'
			   THEN 1
			   ELSE 0
			   END) as EV,
            (CASE 
			   WHEN td_pc.ImportVersionNo = '20210401'
			        AND
					td_pc.[EngineType:Link] IN ('80-046','80-048','80-049')
			   THEN 1
			   ELSE 0
			   END) as HV,
			(CASE 
			   WHEN td_pc.ImportVersionNo = '20210401'
			        AND
					td_pc.[EngineType:Link] NOT IN ('80-040','80-046','80-048','80-049')
			   THEN 1
			   ELSE 0
			   END) as CE

            FROM dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 
			)  
        td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.PassengerCarNo

GROUP BY
   td_pcl.[Article:Link] 
/*
ORDER BY
   td_pcl.[Article:Link] 
*/
   ) td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]

WHERE
-- Use the latest dataset
   td_art.[ImportVersionNo] = '20210401'  
   AND
-- Get articles with an active status
   td_art.[State:Link] = '73-001'
-- AND manu.[IsActive <DE>] IS NOT NULL 

GROUP BY
   manu.[Name]

ORDER BY
   manu.[Name]