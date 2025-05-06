Run the following Commands in CloudShell
curl -LO raw.githubusercontent.com/QUICK-GCP-LAB/2-Minutes-Labs-Solutions/main/Analyzing%20Billing%20Data%20with%20BigQuery/gsp621.sh

sudo chmod +x gsp621.sh

./gsp621.sh
Go to BigQuery from here
SELECT CONCAT(service.description, ' : ',sku.description) as Line_Item FROM `billing_dataset.enterprise_billing` GROUP BY 1
SELECT CONCAT(service.description, ' : ',sku.description) as Line_Item, Count(*) as NUM FROM `billing_dataset.enterprise_billing` GROUP BY CONCAT(service.description, ' : ',sku.description)
SELECT project.id, count(*) as count from `billing_dataset.enterprise_billing` GROUP BY project.id
SELECT ROUND(SUM(cost),2) as Cost, project.name from `billing_dataset.enterprise_billing` GROUP BY project.name

Congratulations 🎉 for completing the Lab !