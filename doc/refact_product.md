# Refactor products

## goal

We want to isolate products, varieties, aspects, packagings and attached products
 for be able to provide a service 'ProductsService' backed with mongodb 
 (witch suits well with embedded documents, 1-n relations...)

## constraints to achieve the goal

The chalenge in here is to decouple the offers, orders, tenders and bids
(responses to tender) from the id of products, varieties...

The two databases (products versus alphawholesale) have to ignore each other,
be unaward of the inner of the other.
