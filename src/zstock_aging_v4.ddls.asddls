@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Aging Data'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZStock_Aging_V4 as select from I_MaterialStock_2 as mat
{
    key mat.Material,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    sum(mat.MatlWrhsStkQtyInMatlBaseUnit) as StockValue,
    mat.MaterialBaseUnit,
    mat.Batch,
    mat.Plant,
    mat.StorageLocation
}group by mat.Material,
mat.MaterialBaseUnit,
mat.Batch,
    mat.Plant,
    mat.StorageLocation
