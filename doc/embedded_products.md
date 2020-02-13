# embedded products

Variety, aspect, size, packaging and calibre don't exist outside of product.
We puts all these embedded in product.
And we keep it in mongodb.
So offers, orders, requests and bids are no more attached to product (via
 belongs to).
It is now to attached_products that they must be link.
Therefor the attached_products must live in the same database as offers,...
Products provides only the embedded documents where live varieties, aspects, ...
