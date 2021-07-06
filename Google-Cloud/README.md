# Working with Google Cloud

The [STAnford Research Repository (STARR)](https://med.stanford.edu/starr-tools.html)
is the School of Medicine's project that supports all sorts of clinical 
research projects. There are lots of ways to get access to and use the data; the
best way for us is to use the R [BigQuery](https://cloud.google.com/bigquery/)
API. Our collaborator [Jonathon Chen](http://healthrexlab.com/) was kind enough
to add you to his IRB and give us access to Google Cloud Project.

We will be using a mix of [SQL](https://en.wikipedia.org/wiki/SQL) and R to
query STARR for deidentified EHR (and no PHI) to build a cohort of patients who
are likely to identify as trans* or non-binary. Then we can start summarizing
the trans* patient population seen at Stanford Health Systems *for the first
time (that I know of)!* We can also explore some ML clustering algorithms and
potentially expand our cohort, do some [propensity score
matching](https://en.wikipedia.org/wiki/Propensity_score_matching), and explore
issues of health equity for this community. These queries and cohort will be
essential for developing more inclusive data models for Sex and Gender as well
as algorithms that can label EHR with it to enable robust research that will
inform health policy.

## Contents

- [Perquisites](#perquisites)
- [STARR](#starr)

## Perquisites
If you don't already have a Google Cloud account, go to:
https://console.cloud.google.com/ and sign with any GSuite account and start a
free trial. Then follow the instructions 
[here](https://cloud.google.com/sdk/docs/install). You'll need Python, which 
shouldn't be a problem since it's nearly ubiquitous. Then click [this
link](https://console.cloud.google.com/apis/library/bigquery.googleapis.com?_ga=2.48078567.1138561114.1625088035-509917660.1611616658) 
and **enable** the BigQuery API.

Next we need to create an authentication key for Google Cloud. Call this next 
line of code from your terminal/command line.

```bash
gcloud auth application-default login
```
After you run the above line you should see something like `Credentials saved 
to file: [path/to/auth-key.json]` we'll need to use this later R can connect to
BigQuery.

Alright now were ready to start using the R BigQuery API in R. The features we
need are still in development so we'll install the API using the `devtools`
package (this might take a while if don't already have `devtools` installed). We
will also need to use the `tidyverse` packages, which is the sliced bread of 
data science IMHO.

```r
install.packages("tidyverse")
install.packages("devtools")
devtools::install_github("rstats-db/bigrquery")
```

Now lets do a quick check with a public dataset to make sure everything is
working before we get started with STARR.

The basic steps for using `bigrquery` are to:

0. Import the library
0. Declare Google Cloud Project ID and authentication key
0. Declare your SQL query as a string in R
0. Call execute your query and store it as a table

```r
## Step 0
library("tidyverse")
library("bigrquery")
```
Easy enough! 

Next we need our Project IDs, which we can find on the home page of 
http://console.cloud.google.com Project info.

![project id](imgs/project-id-sc.png)

```r
## Step 1
projectId <- "whatever-your-project-id-is"
authKey   <- "path/to/auth-key.json"
bq_auth(authPath)
```

For the next two steps were gonna use the [Iowa Liquor
Sales](https://data.iowa.gov/Sales-Distribution/Iowa-Liquor-Sales/m3tr-qhgy)
data set. It's just one table with about 3 million rows, which is pretty easy
to work with just with R, so BigQuery is a bit overkill for this task. STARR,
on the other hand, is a rather complicated [relational
database](https://en.wikipedia.org/wiki/Relational_database) with decades of
patient encounters, diagnostic tests, procedures, etc. and it's impossible to
work with it without SQL.

Now say we want to look at yearly trends in the revenue generated from alcohol
sales in each county. To do that, we `SELECT` the county, year, and `SUM` the
sales revenue variables and `GROUP BY` county and year. We can also tell SQL to
`ORDER BY` the new total revenue variable from high to low: `DESC` (descending
order).
```r
## Step 2
query <- "SELECT 
		county, EXTRACT(YEAR FROM date) AS year, SUM(sale_dollars) AS total_revenue
	  FROM
		`bigquery-public-data.iowa_liquor_sales.sales`
	  GROUP BY
		county, year
	  ORDER BY
		total_revenue DESC"

## Step 3
tb <- bq_project_query(projectId, query)
tb <- bq_table_download(tb)
tb
```

We have our table! It might be a little messy still but it'll be easier to
clean up using `tidyverse` tools than to do with our original SQL call. Try
making a line plot showing the trend of `total_revenue` over the years with a
line for each `county`. I'd suggest using `ggplot`. Make a pull request to push
your code in this directory and edit this file to add your plot on this page
(or you can use the Google Doc).

![Yearly Revenue: Alvin](imgs/yearly-revenue-alvin.png)

Sweet, hopefully that was painless. Now we can get started using STARR!

## STARR
*(Coming soon!)*
