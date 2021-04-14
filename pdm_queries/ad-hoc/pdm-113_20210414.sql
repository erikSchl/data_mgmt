SELECT -- TOP 1000
      base.[GenericArticleNo] as "Genart-Nr", 
      base.[Designation <de>] as "Genart-DE", 
      base.[Designation <en>] as "Genart-EN", 
       T2.[Designation] as "Subcategory", 
       T3.[Description <de>] as "Std-Desc", 
       T4.[Designation <de>] as "AssemblyGroup-DE", 
       T4.[Designation <en>] as "AssemblyGroup-EN", 
       base.[IsUniversalGenericArticle], 
       T1.[IsDangerousGoods], 
       T1.[IsHazardousSubstance]
 FROM [dbo].[MasterData.GenericArticles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[MasterData.GenericArticles:MasterData] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[MasterData.SubCategories] T2 WITH (NOLOCK) ON T2.[SubCategoryNo] = [T1].[SubCategory:Link]
  LEFT OUTER JOIN [dbo].[MasterData.StandardizedArticleDescriptions] T3 WITH (NOLOCK) ON T3.[StandardizedArticleDescriptionNo] = [base].[StandardizedArticleDescription:Link]
  LEFT OUTER JOIN [dbo].[MasterData.AssemblyGroups] T4 WITH (NOLOCK) ON T4.[AssemblyGroupNo] = [base].[AssemblyGroup:Link]
 WHERE (((base.[TecDoc.Version] = 20210401)))
 ORDER BY base.[Designation <de>], T3.[Description <de>]