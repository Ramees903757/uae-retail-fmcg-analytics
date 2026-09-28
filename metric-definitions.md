# Metric definitions and interpretation

These definitions are carried forward from the project materials. Compare them with the final DAX before release.

| Metric | Meaning | Important distinction |
|---|---|---|
| Revenue | Sum of `Sales[net_sales_aed]` | After line discounts, before VAT; returns are separate records |
| Item revenue | Sum of `Sales_Items[net_sales_aed]` | Product/category-level reporting |
| Gross profit | Net sales less the recorded product cost | Not profit after rent, payroll and other operating costs |
| Gross margin | Gross profit divided by revenue | Use the ratio of totals, not an unweighted average of row margins |
| Transactions | Distinct sales/bill identifiers | Different from the number of product lines |
| Average basket value | Bill-level revenue divided by bill count | Not selected-product revenue per bill containing that product |
| Target achievement | Actual sales divided by matching store/month target | Do not invent daily/category/channel allocations |
| Inventory value | Cost-valued stock at the intended snapshot | Do not add monthly balances into one current-stock card |
| OOS positions | Zero-stock store/product positions at the snapshot | Not necessarily distinct company-wide products |
| Wastage value | Recorded waste cost | Not lost selling price or all forms of shrinkage |
| Active identified customers | Distinct nonblank customer IDs with purchases in scope | Not the full customer master |
| Repeat customers | Identified customers with at least two transactions in the chosen scope | Not cohort retention or lifetime value |

A count of 100,000 bills and 448,094 lines does not mean 548,094 separate customer purchases. Anonymous bills remain in revenue but cannot be resolved into repeat individuals.

Month-end inventory and sales must use compatible time scopes in any comparison. Do not create YoY growth from one year of sales data.
