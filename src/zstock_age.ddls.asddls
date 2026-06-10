@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Aging Data'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSTOCK_AGE as select from I_BillingDocument
{
  key BillingDocument   
}
