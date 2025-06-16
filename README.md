# global_fashion_retail_dwh_snowflake
A multinational fashion retailer with 35 stores across 7 countries. 


## 📂 Repository Structure
```
global_fashion_retail_dwh_snowflake/
│
├── datasets/                           # Raw datasets used for the project (ERP, CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── data_architecture.png           # Shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── extract/                        # Scripts for extracting and loading raw data
│   ├── transform/                      # Scripts for cleaning and transforming data
│   ├── presentation/                   # Scripts for creating analytical models
│   ├── dwh_init.sql                    # Script for data warehouse & database initialization. Schema Creation and Grant Privilege
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
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