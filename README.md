# Designing a Scalable Data Infrastructure for Global Fashion Retail
This project simulate two years of transactional data for a multinational fashion retailer with 
- **4+ million sales records**
- **35 Stores** accross 7 countries: 
🇺🇸 United States | 🇨🇳 China | 🇩🇪 Germany | 🇬🇧 United Kingdom | 🇫🇷 France | 🇪🇸 Spain | 🇵🇹 Portugal 

#### Specifications
- **Data Sources**: Import data to cloud storage service system. e,g; AWS, Azure blob storage, GCP Google Cloud Storage.
- **ELT/ETL development**: Extracting data from source systems and ingesting it into Snowflake, Performing data transformations and Presenting data to downstream consumers for analytics, reporting etc
- **Cost Control**: Monitor warehouse consumption and find use findings to strike a good balance between improving performance and controlling cost.
- **Optimization**: Optimize query performance by micro-partition pruning, utlize data caching and reduce data spiling.
- **Data Governance and access control**: Snowflake role-based access control (RBAC) model, where access privileges are assigned to roles that are granted to users.
- **CI/CD**: organize the data pipeline code in a Git repository, integrate it with Snowflake, and implement continuous integration and delivery.
- **Augment data with LLM**: Use Cortex LLM to interpret unstructured data.
- **Best Practices**: Design and implement data engineering solutions following best practices.

---
### Team
The project also simulate team of Data Engineer and Analyst to design and develop the scalable
data infrasture.

* gfr_pm - the project manager user
* gfr_dev_lead - the data enginer team lead
* gfr_ba_lead - the business analyst team lead
* gfr_ba_us - the analyst for United State region
* gfr_ba_cn - the analyst for China region
* gfr_ba_de - the analyst for Germany region
* gfr_ba_gb - the analyst for United Kingdom region
* gfr_ba_fr - the analyst for France region
* gfr_ba_es - the analyst for Spain region
* gfr_ba_pt - the analyst for Portugal region






## 📂 Repository Structure
The project structure uses a folder-by-data structure instead of folder-by-schema
```
global_fashion_retail_dwh_snowflake/
│
├── datasets/                             # Raw datasets used for the project (ERP, CRM data)
│
├── docs/                                 # Project documentation and architecture details
│   ├── data_architecture.png             # Shows the project's architecture
│   ├── data_catalog.md                   # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                  # Draw.io file for the data flow diagram
│   ├── data_models.drawio                # Draw.io file for data models (star schema)
│   ├── naming-conventions.md             # Consistent naming guidelines for tables, columns, and files
│
├── csv_file_splitter/                    # Python script to split large csv file size into chunks
│
├── scripts/                              # SQL scripts for ETL and transformations
│   ├── snowflake_objects/
│       ├── /stores/
│           ├── ext/                      # Scripts for extracting and loading stores data using EXT schema
│           ├── stg/                      # Scripts for cleaning and transforming stores data using STG schema
│           ├── dwh/                      # Scripts that normalizes the stores data from the STG using DWH schema   
│           ├── rpt/                      # Scripts for creating analytical reports using RPT schema
│           ├── tasks/                    # Scripts for automating pipelines
│  
│       ├── /transactions/
│           ├── ext/                      # Scripts for extracting and loading stores data using EXT schema
│           ├── stg/                      # Scripts for cleaning and transforming stores data using STG schema
│           ├── dwh/                      # Scripts that normalizes the stores data from the STG using DWH schema   
│           ├── rpt/                      # Scripts for creating analytical reports using RPT schema
│           ├── tasks/                    # Scripts for automating pipelines 
│       ├── /...
│
│       ├── /orchestrations/
│           ├── tasks/                    # Scripts for automating pipelines
│
│   ├── access_control.sql/               # Script for Granting Privileges and Role access control
│   ├── setup.sq/                         # Script for creating project team roles, users and assign role privileges.
│   ├── dwh_init.sql                      # Script for creating virtual warehouses, databases and schemas . 
│
├── tests/                                # Test scripts and quality files
│
├── README.md                             # Project overview and instructions
├── LICENSE                               # License information for the repository
├── .gitignore                            # Files and directories to be ignored by Git
└── requirements.txt                      # Dependencies and requirements for the project
```
---
## Running Python Code
```
- **Install Environment**: In Terminal:
    cd csv_file_splitter
    run python -m venv venv
- **Activate Envr (windows)**: run venv\Scripts\Activate 
- **Run code**: python split_by_date.py
```