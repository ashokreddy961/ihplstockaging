@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Aging data'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZStock_Aging_V2 with parameters
@EndUserText.label: 'Reporting Date'
    @Environment.systemField: #SYSTEM_DATE
    p_reportingdate : z_reportingdate
as select from I_MaterialDocumentItem_2 as matdocitm
left outer join I_PurchaseOrderItemAPI01 as po on po.PurchaseOrder = matdocitm.PurchaseOrder and po.PurchaseOrderItem = matdocitm.PurchaseOrderItem
//left outer join I_MaterialDocumentItem_2 as grn
//  on grn.PurchaseOrder      = matdocitm.PurchaseOrder
// and grn.PurchaseOrderItem  = matdocitm.PurchaseOrderItem
// and grn.DeliveryDocument   = matdocitm.DeliveryDocument
// and grn.DeliveryDocumentItem = matdocitm.DeliveryDocumentItem
// and grn.GoodsMovementType = '101'

{
    key 
    matdocitm.Material,
    matdocitm.MaterialDocument,
    matdocitm.MaterialDocumentItem,
    matdocitm.MaterialDocumentYear,
    matdocitm.Plant,
    matdocitm.StorageLocation,
    matdocitm.Batch,
    matdocitm.DocumentDate,
    matdocitm.PostingDate,
    matdocitm.GoodsMovementType,
//    case when matdocitm.DebitCreditCode = 'H' or matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' 
//        or matdocitm.GoodsMovementType = '562'
//              or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201'
//               or matdocitm.GoodsMovementType = '543'
//              or matdocitm.GoodsMovementType = '261'
//              or matdocitm.GoodsMovementType = '161' --or matdocitm.GoodsMovementType = '641'
//
//            then -1 * cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2))
//
//            else cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2))
//     end as StockQuantity,
     
     
     
case
//when matdocitm.GoodsMovementType = '641'
//   and grn.MaterialDocument is not null
//  then cast(0 as abap.dec(13,2))
when matdocitm.GoodsMovementType = '641' //and matdocitm.GoodsMovementType = '101'
     and matdocitm.DebitCreditCode = 'S'
     //and po.IsCompletelyDelivered = ''
     and matdocitm.IsCompletelyDelivered = ''
     //and matdocitm.StorageLocation = ''
     //and matdocitm.Batch = ''

    then cast( 0 as abap.dec(13,2) )



    when matdocitm.DebitCreditCode = 'H'
      or matdocitm.GoodsMovementType = '102'
      or matdocitm.GoodsMovementType = '502'
      or matdocitm.GoodsMovementType = '562'
      or matdocitm.GoodsMovementType = '601'
      or matdocitm.GoodsMovementType = '221'
      or matdocitm.GoodsMovementType = '201'
      or matdocitm.GoodsMovementType = '543'
      or matdocitm.GoodsMovementType = '261'
      or matdocitm.GoodsMovementType = '161'

    then -1 * cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2))

    else cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2))

end as StockQuantity,

//    case when matdocitm.DebitCreditCode = 'H' or matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' 
//        or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  
//        or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' 
//        or matdocitm.GoodsMovementType = '161' //or matdocitm.GoodsMovementType = '641'
//        then -1 * cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(13,2)) 
//        else cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(13,2)) 
//    end as StockValue,

case


when matdocitm.GoodsMovementType = '641'
     and matdocitm.DebitCreditCode = 'S'
    // and po.IsCompletelyDelivered = ''
      and matdocitm.IsCompletelyDelivered = ''
     //and matdocitm.StorageLocation = ''
     //and matdocitm.Batch = ''

    then cast( 0 as abap.dec(13,2) )
//    
//   when matdocitm.GoodsMovementType = '641'
//   and grn.MaterialDocument is not null
//  then cast(0 as abap.dec(13,2))


    when matdocitm.DebitCreditCode = 'H'
      or matdocitm.GoodsMovementType = '102'
      or matdocitm.GoodsMovementType = '502'
      or matdocitm.GoodsMovementType = '562'
      or matdocitm.GoodsMovementType = '601'
      or matdocitm.GoodsMovementType = '221'
      or matdocitm.GoodsMovementType = '201'
      or matdocitm.GoodsMovementType = '543'
      or matdocitm.GoodsMovementType = '261'
      or matdocitm.GoodsMovementType = '161'

    then -1 * cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(13,2))

    else cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(13,2)) 

end as StockValue,

//    
//------------------------------Total Aging Days-----------------------------------------------//
     case when dats_days_between(case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate ) < 0
        then 0
     else dats_days_between(
            case
                when matdocitm.GoodsMovementType = '561'
                then matdocitm.DocumentDate
                else matdocitm.PostingDate
            end,
            $parameters.p_reportingdate
        )
    end as TotalAgingDays
    
    
//----------------------------------Ageing days for 0-30 Bucket --------------------------------------------//

//---------------- 0-30 Bucket ----------------//

//case when case when dats_days_between(case
//                when matdocitm.GoodsMovementType = '561'
//                then matdocitm.DocumentDate
//                else matdocitm.PostingDate
//            end,
//            $parameters.p_reportingdate
//        ) < 0
//        then 0
//
//        else dats_days_between(
//            case
//                when matdocitm.GoodsMovementType = '561'
//                then matdocitm.DocumentDate
//                else matdocitm.PostingDate
//            end,
//            $parameters.p_reportingdate
//        )
//    end
//
//    between 0 and 30
//
//    then
//
//    case
//        when matdocitm.DebitCreditCode = 'H'
//          or matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' or
//          matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601'  or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType ='543'
//
//        then -1 * cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2))
//
//        else cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2))
//    end
//
//    else cast(0 as abap.dec(13,2))
//
//end as StockQuantity_0_30Days,
//    
//    case when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 0 and 30
//then cast(
//(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
//end as StockValue_0_30Days,
//
//
////--------------------------Ageing days for 30-60---------------------------------------//
//
//case when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 31 and 60
//then (case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))
//end as StockQuantity_31_60Days,
//
//case when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 31 and 60
//then cast(
//(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
//end as StockValue_31_60Days,
//
////------------------------------Ageing days for 60-90----------------------------------//
//
//case when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 61 and 90
//then (case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))
//end as StockQuantity_61_90Days,
//
//case when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 61 and 90
//then cast(
//(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
//end as StockValue_61_90Days,
//
//
//
////----------------------------Ageing days for 90-180---------------------------//
//
//case
//
//when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 91 and 180
//then
//(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))
//end as StockQuantity_91_180Days,
//
//case
//when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 91 and 180
//then cast(
//(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//*  cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
//end as StockValue_91_180Days,
//
////-------------------------Ageing days for 180-365------------------------------//
//
//case
//when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 181 and 365
//then
//(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))
//
//end as StockQuantity_181_365Days,
//
//case
//when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 181 and 365
//then cast(
// (case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
// * cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
//
//end as StockValue_181_365Days,
//
//
//
////----------------------Ageing days > 365----------------------------------------//
//
//case
//when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) > 365
//then
//(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601'  or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))
//
//end as StockQuantity_Over365Days,
//
//case
//  when dats_days_between(
//  case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) > 365
//then cast(
//(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
//
//end as StockValue_Over365Days

}where matdocitm.PostingDate <= $parameters.p_reportingdate  and matdocitm.Material <> '' 
--and matdocitm.DebitCreditCode = 'S'
