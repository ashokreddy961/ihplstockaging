@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Aging Data'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZStock_Aging_V1 with parameters

    @EndUserText.label: 'Reporting Date'
    @Environment.systemField: #SYSTEM_DATE
    p_reportingdate : z_reportingdate
as select from I_MaterialDocumentItem_2 as matdocitm
left outer join I_ProductValuationBasic as product on product.Product = matdocitm.Material and matdocitm.Plant = product.ValuationArea
and matdocitm.Batch = product.ValuationType
left outer join I_PurchaseOrderItemAPI01 as poitm on poitm.PurchaseOrder = matdocitm.PurchaseOrder
and poitm.PurchaseOrderItem = matdocitm.PurchaseOrderItem
//left outer join I_StockQuantityCurrentValue_2( P_DisplayCurrency : 'INR' ) as stockvalue on stockvalue.Product = matdocitm.Material
//and stockvalue.Batch = matdocitm.Batch and stockvalue.Plant = matdocitm.Plant and stockvalue.StorageLocation = matdocitm.StorageLocation and stockvalue.ValuationAreaType = '1'
left outer join I_ProductText as materialname on materialname.Product = matdocitm.Material and materialname.Language = 'E'
left outer join I_PurchaseOrderAPI01 as pohed on pohed.PurchaseOrder = poitm.PurchaseOrder
left outer join I_Supplier as supplier on supplier.Supplier = pohed.Supplier
left outer join I_Plant as plant on plant.Plant = matdocitm.Plant
//left outer join I_SerialNumberMaterialDoc_2 as serialnum on serialnum.MaterialDocument = matdocitm.MaterialDocument
//and serialnum.MaterialDocumentItem = matdocitm.MaterialDocumentItem and serialnum.MaterialDocumentYear = matdocitm.MaterialDocumentYear
{
    key 
    matdocitm.Material,
    max(matdocitm.MaterialDocument) as MaterialDocument,
    max( matdocitm.StorageLocation) as StorageLocation,
    matdocitm.Plant,
    max( matdocitm.Batch) as Batch,
   // matdocitm.MaterialDocument,
 sum( case when matdocitm.DebitCreditCode = 'H' or matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' 
        or matdocitm.GoodsMovementType = '562'
              or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201'
               or matdocitm.GoodsMovementType = '543'
              or matdocitm.GoodsMovementType = '261'
              or matdocitm.GoodsMovementType = '161'

            then -1 * cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2))

            else cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2))
end ) as StockQuantity,
sum( case when matdocitm.DebitCreditCode = 'H' or matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' 
or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  
or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' 
or matdocitm.GoodsMovementType = '161' then -1 * cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(13,2)) 
else cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(13,2)) 
end) as StockValue

//case when dats_days_between(case when max(matdocitm.GoodsMovementType) = '561' then max(matdocitm.DocumentDate) else max(matdocitm.PostingDate) end, $parameters.p_reportingdate) < 0
//then 0
//else dats_days_between(case when max(matdocitm.GoodsMovementType) = '561' then max(matdocitm.DocumentDate) else max(matdocitm.PostingDate) end, $parameters.p_reportingdate)
//end as TotalAgingDays,
//
//case when dats_days_between(
//
//case when matdocitm.GoodsMovementType = '561' then  matdocitm.DocumentDate else  matdocitm.PostingDate end, $parameters.p_reportingdate) between 0 and 30
//
//  then (case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))
//end as StockQuantity_0_30Days,
//
//
//case when dats_days_between(
//case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 0 and 30
//then cast(
//(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
//* cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
//end as StockValue_0_30Days

}
where matdocitm.PostingDate <= $parameters.p_reportingdate  and matdocitm.Material <> ''
//and (
//      (
//        case
//            when matdocitm.DebitCreditCode = 'H'
//              or matdocitm.GoodsMovementType = '102'
//              or matdocitm.GoodsMovementType = '502'
//              or matdocitm.GoodsMovementType = '562'
//              or matdocitm.GoodsMovementType = '601'
//              or matdocitm.GoodsMovementType = '221'
//              or matdocitm.GoodsMovementType = '201'
//              or matdocitm.GoodsMovementType = '543'
//              or matdocitm.GoodsMovementType = '261'
//              or matdocitm.GoodsMovementType = '161'
//
//            then -1 * cast( matdocitm.QuantityInEntryUnit as abap.dec(13,2) )
//
//            else cast( matdocitm.QuantityInEntryUnit as abap.dec(13,2) )
//        end ) > 0
//    )



//and matdocitm.GoodsMovementType <> '102'
//and matdocitm.GoodsMovementType <> '502'
//and matdocitm.GoodsMovementType <> '562'
////and matdocitm.GoodsMovementType <> '312'
////and matdocitm.GoodsMovementType <> '641'
//and matdocitm.GoodsMovementType <> '601'
//and matdocitm.GoodsMovementType <> '221'
//and matdocitm.GoodsMovementType <> '201'
//and matdocitm.GoodsMovementType <> '543'
//and matdocitm.GoodsMovementType <> '261'
//and matdocitm.GoodsMovementType <> '161'
//and matdocitm.DebitCreditCode <> 'H'
group by matdocitm.Material,
//matdocitm.StorageLocation,
matdocitm.Plant
//matdocitm.Batch
having
    sum(
        case
            when matdocitm.DebitCreditCode = 'H'
              or matdocitm.GoodsMovementType = '102'
              or matdocitm.GoodsMovementType = '502'
//              or matdocitm.GoodsMovementType = '312'
//              or matdocitm.GoodsMovementType = '641'
              or matdocitm.GoodsMovementType = '562'
              or matdocitm.GoodsMovementType = '601'
              or matdocitm.GoodsMovementType = '221'
              or matdocitm.GoodsMovementType = '201'
              or matdocitm.GoodsMovementType = '543'
              or matdocitm.GoodsMovementType = '261'
              or matdocitm.GoodsMovementType = '161'
            then
                -1 * matdocitm.QuantityInEntryUnit
            else
                matdocitm.QuantityInEntryUnit
        end
    ) > 0
//

