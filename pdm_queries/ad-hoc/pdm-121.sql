SELECT 
  T4.[ArtN],
  base.[ArticleID], 
  base.[K24Number], 
  base.[ManufacturerArticleNo], 
  base.[Manufacturer:Link], 
  T1.[ProductGroup:Link], 
  T2.[Designation], 
  T3.[ArticleDesignation <de>],
  T1.[ArticleStatus:Link]
 
 FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[MasterData.ProductGroups] T2 WITH (NOLOCK) ON T2.[ProductGroupNo] = [T1].[ProductGroup:Link]
  LEFT OUTER JOIN [dbo].[Article.Articles:Texts] T3 WITH (NOLOCK) ON T3.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [ji_reporting].[dbo].[pdm-121_import] T4 WITH (NOLOCK) ON CAST(T4.[ArtN] as varchar) = CAST([base].[K24Number] as varchar)

WHERE T4.[ArtN] IS NOT NULL
ORDER BY base.[Manufacturer:Link], T1.[ProductGroup:Link], base.[K24Number]