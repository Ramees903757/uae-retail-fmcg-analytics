# Release validation — complete before publication

**Status: final PBIX/screenshots not reviewed in this starter package.**

## Release details

- Report version/tag: [record after review]
- SQL Server engine and compatibility level: [record actual values]
- Power BI Desktop version: [record actual value]
- Final PBIX or verified download path: [add actual path]
- Dataset access or generator path: [add actual path]
- Review date: [record actual date]

## Dataset baseline from the supplied project guide

| Check | Reference result | Final report result |
|---|---:|---|
| Stores | 8 | [verify] |
| Product master | 5,000 | [verify] |
| Transactions | 100,000 | [verify] |
| Sales lines | 448,094 | [verify] |
| Revenue | AED 14,969,519.50 | [verify] |
| Gross profit | AED 4,261,315.62 | [verify] |
| Gross margin | 28.47% | [verify] |
| Average basket value | AED 149.70 | [verify] |

## Release checklist

- [ ] Six pages only: Overview, Stores, Products, Inventory, Wastage, Customers.
- [ ] Sidebar, buttons, bookmarks and hidden-page settings reviewed.
- [ ] No stale synced filters from removed pages.
- [ ] Final total and filtered KPI results agree with SQL.
- [ ] Category selections affect line-level product measures as intended.
- [ ] Inventory cards represent one selected/latest snapshot, not a sum of months.
- [ ] Monthly targets are compared with the matching store/month sales.
- [ ] Anonymous customers are not counted as one repeat customer.
- [ ] Any ABC, basket-association or other optional feature is advertised only if implemented.
- [ ] Current screenshots and the final report have been added.
- [ ] Data access/rebuild instructions work and disclose synthetic provenance.
- [ ] No real client/customer data, credentials, tokens or private connection details.
- [ ] No untested file from earlier tutorials is presented as final working code.
- [ ] README has no missing images, sample repository URL or obsolete page claims.
- [ ] LinkedIn post link opens the actual published repository.
- [ ] Draft notices are removed only after the missing assets/checks are resolved.

## Evidence used to prepare the starter copy

The baseline figures were read from `UAE_Retail_FMCG_Project_Guide.xlsx` (Project Overview and KPI Definitions), with workflow context from the user's SSMS work, Overview screenshot and page-building materials. The six-page scope reflects the user's removal of the Suppliers and Promotions pages.

This is not a new execution of the final SQL database or Power BI model. Replace or update the reference figures if the verified final dataset differs.
