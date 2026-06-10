@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Aging Data'
@Metadata.ignorePropagatedAnnotations: true
@Analytics.dataCategory: #CUBE
@ObjectModel.modelingPattern: #ANALYTICAL_DIMENSION
@ObjectModel.supportedCapabilities: [
#ANALYTICAL_DIMENSION,
#CDS_MODELING_ASSOCIATION_TARGET,
#SQL_DATA_SOURCE,
#CDS_MODELING_DATA_SOURCE
]
define view entity ZStock_Aging 
with parameters

    @EndUserText.label: 'Reporting Date'
    @Environment.systemField: #SYSTEM_DATE
    p_reportingdate : z_reportingdate
as select from I_MaterialDocumentItem_2 as matdocitm
left outer join I_ProductValuationBasic as product on product.Product = matdocitm.Material and matdocitm.Plant = product.ValuationArea
and matdocitm.Batch = product.ValuationType

//left outer join I_AccountingDocumentJournal( P_Language : 'E') as jeitm on matdocitm.MaterialDocument = jeitm.ReferenceDocument and jeitm.CompanyCode = matdocitm.CompanyCode

//and jeitm.Plant = matdocitm.Plant

//and jeitm.FiscalYear = matdocitm.MaterialDocumentYear

//left outer join I_JournalEntryItem as jeitm on matdocitm.MaterialDocument = jeitm.ReferenceDocument and jeitm.CompanyCode = matdocitm.CompanyCode

//and jeitm.Plant = matdocitm.Plant and jeitm.Material = matdocitm.Material

//left outer join I_JournalEntry as jehead on jeitm.AccountingDocument = jehead.AccountingDocument

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
    matdocitm.GLAccount,
    matdocitm.MaterialDocument,
    matdocitm.GoodsMovementType,
case when poitm.PurchaseOrder is not null and poitm.PurchaseOrder <> '' then poitm.PurchaseOrder else 'N/A' end as PurchaseOrder,
   poitm.BaseUnit,
    matdocitm.CompanyCode,
    matdocitm.StorageLocation,
    matdocitm.Material,
     materialname.ProductName,
    matdocitm.Plant,
 plant.PlantName,
   case when poitm.PurchaseOrderItemText is not null and poitm.PurchaseOrderItemText <> '' then poitm.PurchaseOrderItemText else 'N/A'
end as PurchaseOrderItemText,

     case when pohed.Supplier is not null and pohed.Supplier <> '' then pohed.Supplier else 'N/A' end as Supplier,

     case when supplier.SupplierName is not null and supplier.SupplierName <> '' then supplier.SupplierName else 'N/A' end as SupplierName,
     matdocitm.PostingDate,
    matdocitm.DocumentDate,
    poitm.DocumentCurrency,
    @Semantics.quantity.unitOfMeasure :'BaseUnit'
        case when matdocitm.DebitCreditCode = 'H' or matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' 
        or matdocitm.GoodsMovementType = '562'
              or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201'
               or matdocitm.GoodsMovementType = '543'
              or matdocitm.GoodsMovementType = '261'
              or matdocitm.GoodsMovementType = '161'

            then -1 * cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2))

            else cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2))
end as StockQuantity,
//cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) as StockQuantity,
    matdocitm.Batch,
 
// case when matdocitm.DebitCreditCode = 'H' or matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' 
//or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  
//or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' 
//or matdocitm.GoodsMovementType = '161' then -1 * cast(product.MovingAveragePrice as abap.dec(13,2)) 
//else cast(product.MovingAveragePrice as abap.dec(13,2)) 
//end as MovingAveragePrice,
//
//      case when matdocitm.DebitCreditCode = 'H' or matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' 
//        or matdocitm.GoodsMovementType = '562'
//              or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201'
//               or matdocitm.GoodsMovementType = '543'
//              or matdocitm.GoodsMovementType = '261'
//              or matdocitm.GoodsMovementType = '161'
//
//            then -1 * cast(product.PriceUnitQty as abap.dec(13,2))
//
//            else cast(product.PriceUnitQty as abap.dec(13,2))
//end as MovingQuantity,

 case when matdocitm.DebitCreditCode = 'H' or matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' 
or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  
or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' 
or matdocitm.GoodsMovementType = '161' then -1 * cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(13,2)) 
else cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(13,2)) 
end as StockValue,
//cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(13,2)) as StockValue,

case when dats_days_between(case when matdocitm.GoodsMovementType='561' then matdocitm.DocumentDate else matdocitm.PostingDate end,$parameters.p_reportingdate ) < 0
then 0
else dats_days_between( case when matdocitm.GoodsMovementType='561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate )
end as TotalAgingDays,

@Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'


//---------------------Ageing days for 0-30-----------------------------------------//

case when dats_days_between(

case when matdocitm.GoodsMovementType = '561' then  matdocitm.DocumentDate else  matdocitm.PostingDate end, $parameters.p_reportingdate) between 0 and 30

  then (case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))
end as StockQuantity_0_30Days,

matdocitm.MaterialBaseUnit,


case when dats_days_between(
case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 0 and 30
then cast(
(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
* cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
end as StockValue_0_30Days,

//--------------------------Ageing days for 30-60---------------------------------------//

case when dats_days_between(
case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 30 and 60
then (case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))
end as StockQuantity_30_60Days,

case when dats_days_between(
case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 30 and 60
then cast(
(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
* cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
end as StockValue_30_60Days,

//------------------------------Ageing days for 60-90----------------------------------//

case when dats_days_between(
case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 60 and 90
then (case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))
end as StockQuantity_60_90Days,

case when dats_days_between(
case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 60 and 90
then cast(
(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
* cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
end as StockValue_60_90Days0,



//----------------------------Ageing days for 90-180---------------------------//

case

when dats_days_between(
case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 90 and 180
then
(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))
end as StockQuantity_90_180Days,

case
when dats_days_between(
case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 90 and 180
then cast(
(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221' or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
*  cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))
end as StockValue_90_180Days,

//-------------------------Ageing days for 180-365------------------------------//

case
when dats_days_between(
case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 180 and 365
then
(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))

end as StockQuantity_180_365Days,

case
when dats_days_between(
case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) between 180 and 365
then cast(
 (case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
 * cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))

end as StockValue_180_365Days,



//----------------------Ageing days > 365----------------------------------------//

case
when dats_days_between(
case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) > 365
then
(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601'  or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
* cast(matdocitm.QuantityInEntryUnit as abap.dec(13,2)) else cast(0 as abap.dec(13,2))

end as StockQuantity_Over365Days,

case
  when dats_days_between(
  case when matdocitm.GoodsMovementType = '561' then matdocitm.DocumentDate else matdocitm.PostingDate end, $parameters.p_reportingdate) > 365
then cast(
(case when matdocitm.GoodsMovementType = '102' or matdocitm.GoodsMovementType = '502' or matdocitm.GoodsMovementType = '562' or matdocitm.GoodsMovementType = '601' or matdocitm.GoodsMovementType = '221'  or matdocitm.GoodsMovementType = '201' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '261' or matdocitm.GoodsMovementType = '161' then -1 else 1 end)
* cast(matdocitm.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2)) as abap.dec(17,2)) else cast(0 as abap.dec(17,2))

end as StockValue_Over365Days

}
where matdocitm.PostingDate <= $parameters.p_reportingdate
//and matdocitm.GoodsMovementType <> '102'
//and matdocitm.GoodsMovementType <> '502'
//and matdocitm.GoodsMovementType <> '562'
//and matdocitm.GoodsMovementType <> '601'
//and matdocitm.GoodsMovementType <> '221'
//and matdocitm.GoodsMovementType <> '201'
//and matdocitm.GoodsMovementType <> '543'
//and matdocitm.GoodsMovementType <> '261'
//and matdocitm.GoodsMovementType <> '161'
//
//and matdocitm.DebitCreditCode <> 'H'
//jeitm.DebitCreditCode = 'S' and jeitm.SourceLedger = '0L' and //and jeitm.LedgerGLLineItem = '000001' // and matdocitm.MaterialDocument = '4900000355' //and matdocitm.GoodsMovementType = '562'

//(matdocitm.GoodsMovementType = '101'  or  matdocitm.GoodsMovementType = '561' or matdocitm.GoodsMovementType = '501' or matdocitm.GoodsMovementType = '311' or matdocitm.GoodsMovementType = '312' or matdocitm.GoodsMovementType = '541' or matdocitm.GoodsMovementType = '543' or matdocitm.GoodsMovementType = '415' or matdocitm.GoodsMovementType = '261' or)// or  matdocitm.GoodsMovementType = '102' or  matdocitm.GoodsMovementType = '562' or  matdocitm.GoodsMovementType = '502' )

//and jeitm.AccountingDocument = '5000000031' and jeitm.CompanyCode = '1000'



