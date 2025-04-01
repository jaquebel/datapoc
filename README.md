# Data Platform Solution Documentation

**All the solution code and configuration files are available on GitHub:**  
[https://github.com/jaquebel/datapoc/tree/main](https://github.com/jaquebel/datapoc/tree/main)

---

## 1. Overview

This solution implements a complete data lake architecture on Azure with three distinct data layers:

- **Bronze:** Ingestion of raw data from various sources (CSV files and SQL tables).
- **Silver:** Data transformation and cleansing, where raw data is enriched, cleaned, and stored in a structured format.
- **Gold:** Final refined data layer with advanced transformations (e.g., dynamic data masking) for secure and consumable output.

The solution leverages key Azure services:

- **Azure Data Factory (ADF)** for orchestration.
- **Azure Databricks** for executing transformation logic via parameterized notebooks.
- **Azure Key Vault** for secure credential management.
- **SQL Database** for metadata management.
- **Azure Data Lake Storage Gen2** for storing data across the layers.
- **Delta Lake** for the Gold layer, providing ACID transactions and time travel.

![resources](image.png)

## 2. Resources Deployed

- **Resource Group:** `rg-dataplatform-dev`
- **Data Factory:** `adf-datapoc-dev (V2)`
- **Azure Databricks Service:** `dbw-datapoc-dev`
- **Key Vault:** `kv-datapoc-dev`
- **SQL Database:** `sql-db-datapoc`  
  - **SQL Server:** `sql-server-datapoc`
- **Storage Account:** `stgdatapoc`

## 3. Architecture and Data Flow

### 3.1 End-to-End Orchestration

![Orchestration](image-1.png)

The orchestration is managed through ADF pipelines that coordinate the entire data flow from ingestion to final refinement. The process is metadata-driven, allowing dynamic control over which transformation notebooks are executed based on entries in the metadata tables.

- **[Ingestion (Bronze)](https://github.com/jaquebel/datapoc/blob/main/datafactory/pipeline/IngestionPipeline.json):**  

![Bronze](image-2.png)

  Raw data from CSV files and SQL sources is ingested and stored as Parquet files in the Bronze layer. The pipeline supports two different data source types by using a conditional mechanism: if the source is a CSV file, it executes the `CopyCSVToBronze` activity; if the source is a SQL table, it executes the `CopyDatabaseToBronze` activity. This conditional approach ensures that data is ingested in an optimized manner depending on its source type.

- **:[Transformation (Silver)](https://github.com/jaquebel/datapoc/blob/main/datafactory/pipeline/SilverTransformationPipeline.json):**  

![Silver](image-3.png)

  Data is cleansed and enriched. The Silver transformation leverages metadata stored in `dbo.MetadataSilver` to determine which Databricks notebooks to execute. This modular approach allows for both generic transformations (via the **GenericTransformationNotebook**) and unit-specific logic (via the **SalesTransformationNotebook**).

- **[Refinement (Gold)](https://github.com/jaquebel/datapoc/blob/main/datafactory/pipeline/RefinementPipeline.json):** 

![Gold](image-4.png) 

  Data from the Silver layer undergoes further refinement including dynamic data masking. The rules for masking are defined in `dbo.MetadataGold` and enable dynamic, conditional masking based on business rules and user permissions. The final data is written in Delta format, ready for consumption by downstream applications or analytics tools.

### 3.2 Metadata-Driven Transformation

The architecture relies on metadata to drive transformation logic:

- **MetadataSilver:**  
  Contains entries for each dataset to be transformed, specifying:
  - **BusinessUnit:** The business unit (e.g., Sales, Finance, HR).
  - **SourceName:** The name of the dataset or file.
  - **executionnotebooks:** A comma-separated list of transformation notebooks to run.

- **MetadataGold:**  
  Contains masking rules for sensitive data. For example, for Sales, it might specify that columns such as `ssn` and `email` need to be masked.

This approach minimizes hard-coding, reduces complexity, and makes scaling to new datasets straightforward by simply updating metadata entries.

## 4. Databricks Notebooks

The transformation logic is implemented in Databricks notebooks, which are structured with clear step-by-step instructions for maintainability and ease of testing.

### 4.1 Silver Notebooks

- **[GenericTransformationNotebook](https://github.com/jaquebel/datapoc/blob/main/databricks/SilverNotebooks/GenericTransformationNotebook.ipynb):**  
  **Description:**  
  This notebook performs common data transformations applicable to most datasets. It initializes parameters, reads raw data from the Bronze layer, applies generic cleaning (such as deduplication and standard data formatting), and writes the transformed data in Parquet format to the Silver layer.
  
  **Steps:**
  1. **Initialize Widgets:** Receives parameters such as `business_unit`, `source_path`, `destination_path`, and `source_name`.
  2. **Read Data:** Loads data from the Bronze layer.
  3. **Apply Transformations:** Cleanses and enriches data using generic transformation logic.
  4. **Write Data:** Saves the transformed dataset to the Silver layer in Parquet format.

- **[SalesTransformationNotebook](https://github.com/jaquebel/datapoc/blob/main/databricks/SilverNotebooks/SalesTransformationNotebook.ipynb):**  
  **Description:**  
  This notebook handles unit-specific transformation logic for the Sales business unit. In addition to the generic cleaning, it applies additional transformations (e.g., currency conversion or formatting specific to sales data) before writing the output to the Silver layer.
  
  **Steps:**  
  Similar to the GenericTransformationNotebook but includes sales-specific logic where required.

### 4.2 Gold Notebook

- **[GoldTransformationNotebook](https://github.com/jaquebel/datapoc/blob/main/databricks/GoldNotebooks/GoldTransformationNotebook.ipynb):**  
  **Description:**  
  This notebook refines the data further by applying advanced transformations, notably dynamic data masking based on user permissions and metadata rules. It reads data from the Silver layer, masks sensitive columns as defined in `dbo.MetadataGold`, and writes the final dataset in Delta format to the Gold layer.
  
  **Steps:**
  1. **Configure Storage Access:** Retrieves the storage key from Azure Key Vault using a secret scope and configures Spark.
  2. **Initialize Widgets:** Collects parameters including `business_unit`, `source_path`, `destination_path`, `source_name`, `mask_columns`, and optionally `current_user` for conditional masking.
  3. **Read Data:** Loads the dataset from the Silver layer.
  4. **Apply Data Masking:** Conditionally masks sensitive columns based on metadata rules and user permissions.
  5. **Write Data:** Saves the refined data in Delta format to the Gold layer.

## 5. Key Strengths and Design Choices

- **End-to-End Orchestration:**  
  The solution covers the complete data lifecycle—from raw ingestion (Bronze) to final consumption-ready data (Gold)—ensuring a robust and integrated data pipeline.

- **Metadata-Driven Architecture:**  
  By leveraging metadata stored in SQL (MetadataSilver and MetadataGold), the system dynamically controls transformation logic. This minimizes hard-coded dependencies and simplifies the addition of new datasets.

- **Generic Dataset Approach:**  
  Only the necessary generic datasets are created, avoiding an extensive list of individual dataset definitions. This enhances maintainability and promotes reuse across pipelines.

- **Security and Credential Management:**  
  Sensitive credentials (e.g., storage account key) are securely managed using Azure Key Vault and accessed via Databricks secret scopes, ensuring that sensitive data is protected and not exposed in code.

- **Scalability and Flexibility:**  
  Parameterized notebooks and dynamic pipeline execution enable the solution to adapt quickly to new requirements. The use of Delta Lake in the Gold layer provides advanced functionalities such as ACID transactions and time travel, ensuring data reliability.

## 6. Conclusion

This data platform solution provides a robust, scalable, and secure architecture for managing the entire data lifecycle on Azure. By combining Azure Data Factory for orchestration, Databricks for flexible, metadata-driven transformations, and secure services such as Azure Key Vault and SQL Database, the solution ensures efficient and secure data processing. The use of generic datasets and centralized metadata control significantly reduces complexity and enhances maintainability, making this a comprehensive solution ready for production and presentation.

---
