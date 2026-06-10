@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Aging Data'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZStock_Aging_V3 with parameters
    p_reportingdate : z_reportingdate as select from ZStock_Aging_V2(
    p_reportingdate : $parameters.p_reportingdate
) as base
{
    key base.Material,
       min( base.MaterialDocument) as MaterialDocument,
        min(base.Plant) as Plant,
        min(base.StorageLocation) as StorageLocation,
        min(base.GoodsMovementType) as GoodsMovementType,
        base.Batch as Batch,
       max( base.DocumentDate) as DocumentDate,
        max(base.PostingDate) as PostingDate,
       sum( base.StockQuantity) as StockQuantity,
       sum( base.StockValue) as StockValue,
       min( base.TotalAgingDays) as TotalAgingDays,
 //---------------------------------0-30--------------------------------//      
        case when min(base.TotalAgingDays) between 0 and 30 then sum(base.StockQuantity) else 0
        end as StockQuantity_0_30Days,
        
        case when min(base.TotalAgingDays) between 0 and 30 then sum(base.StockValue) else cast(0 as abap.dec(17,2))
        end as StockValue_0_30Days,
        
 //--------------------------------31-60------------------------------//
        case when min(base.TotalAgingDays) between 31 and 60 then sum(base.StockQuantity) else 0 
        end as StockQuantity_31_60Days,
        
        case when min(base.TotalAgingDays) between 31 and 60 then sum(base.StockValue) else cast(0 as abap.dec(17,2))
        end as StockValue_31_60Days,
 //------------------------------61-90--------------------------------//
        case when min(base.TotalAgingDays) between 61 and 90 then sum(base.StockQuantity) else 0
        end as StockQuantity_61_90Days,
        
        case  when min(base.TotalAgingDays) between 61 and 90 then sum(base.StockValue) else cast(0 as abap.dec(17,2))
        end as StockValue_61_90Days,
 //--------------------------91-180-----------------------------------//
        case when min(base.TotalAgingDays) between 91 and 180 then sum(base.StockQuantity) else 0
        end as StockQuantity_91_180Days,

        case  when min(base.TotalAgingDays) between 91 and 180 then sum(base.StockValue) else cast(0 as abap.dec(17,2))
        end as StockValue_91_180Days,
 //-------------------------181-365-----------------------------------//
        case when min(base.TotalAgingDays) between 181 and 365 then sum(base.StockQuantity) else 0
        end as StockQuantity_181_365Days,
        
        case when min(base.TotalAgingDays) between 181 and 365 then sum(base.StockValue) else cast(0 as abap.dec(17,2))
        end as StockValue_181_365Days,
//-------------------------->365--------------------------------------//
        case when min(base.TotalAgingDays) > 365 then sum(base.StockQuantity) else 0
        end as StockQuantity_Over365Days,
        
        case when min(base.TotalAgingDays) > 365 then sum(base.StockValue) else cast(0 as abap.dec(17,2))
        end as StockValue_Over365Days
//       sum( base.StockQuantity_0_30Days) as StockQuantity_0_30Days,
//       sum( base.StockValue_0_30Days) as StockValue_0_30Days,
//       sum( base.StockQuantity_31_60Days) as StockQuantity_31_60Days,
//       sum( base.StockValue_31_60Days) as StockValue_31_60Days,
//       sum(base.StockQuantity_61_90Days) as StockQuantity_61_90Days,
//        sum(base.StockValue_61_90Days) as StockValue_61_90Days ,
//        sum(base.StockQuantity_91_180Days) as StockQuantity_91_180Days,
//        sum(base.StockValue_91_180Days) as StockValue_91_180Days,
//        sum(base.StockQuantity_181_365Days) as StockQuantity_181_365Days,
//        sum(base.StockValue_181_365Days) as StockValue_181_365Days,
//        sum(base.StockQuantity_Over365Days) as StockQuantity_Over365Days,
//        sum(base.StockValue_Over365Days) as StockValue_Over365Days
    
}//where base.PostingDate <= $parameters.p_reportingdate  and base.Material <> ''
group by
    base.Material,
  // base.MaterialDocument,
    //base.Plant,
     //base.StorageLocation,
    // base.GoodsMovementType,
    base.Batch

having sum( base.StockQuantity ) > 0
