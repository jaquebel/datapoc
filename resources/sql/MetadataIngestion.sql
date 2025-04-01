-- Drop the MetadataIngestion table if it exists
IF OBJECT_ID('dbo.MetadataIngestion', 'U') IS NOT NULL
    DROP TABLE dbo.MetadataIngestion;
GO

-- Create the MetadataIngestion table
CREATE TABLE dbo.MetadataIngestion (
    Id INT IDENTITY(1,1) PRIMARY KEY,           -- Auto-generated primary key
    BusinessUnit VARCHAR(50) NOT NULL,           -- Business unit (e.g., Sales, Finance, HR, Operations)
    SourceType VARCHAR(20) NOT NULL,             -- Data source type: 'CSV' or 'Database'
    SourceName VARCHAR(100) NOT NULL,            -- Name of the data source (e.g., table name or file name without extension)
    FilePath VARCHAR(255) NOT NULL,              -- File path or file name used in the ingestion process
    SourceSchema VARCHAR(100) NOT NULL,          -- Schema or folder from which data is sourced (e.g., 'sales', 'raw-zone')
    Description VARCHAR(500),                    -- Description of the data source
    CreatedDate DATETIME2 NOT NULL,              -- Record creation date
    PartitionColumn VARCHAR(100)                -- Column used for partitioning (e.g., 'IngestionDate')
);
GO

-- Insert sample records

-- Record 6: Sales, Database source
INSERT INTO dbo.MetadataIngestion 
    (BusinessUnit, SourceType, SourceName, FilePath, SourceSchema, Description, CreatedDate, PartitionColumn)
VALUES 
    ('Sales', 'Database', 'SalesTable', 'Sales', 'sales', 'Sales data from the database for Sales', '2025-03-31T22:16:17.3730000', 'IngestionDate');

-- Record 7: Sales, CSV source
INSERT INTO dbo.MetadataIngestion 
    (BusinessUnit, SourceType, SourceName, FilePath, SourceSchema, Description, CreatedDate, PartitionColumn)
VALUES 
    ('Sales', 'CSV', 'SalesAdditional', 'sales_additional.csv', 'raw-zone', 'Additional sales data in CSV for Sales', '2025-03-31T22:16:17.3730000', 'IngestionDate');

-- Record 8: Finance, CSV source
INSERT INTO dbo.MetadataIngestion 
    (BusinessUnit, SourceType, SourceName, FilePath, SourceSchema, Description, CreatedDate, PartitionColumn)
VALUES 
    ('Finance', 'CSV', 'FinanceData', 'finance_data.csv', 'raw-zone', 'Financial data in CSV', '2025-03-31T22:16:17.3730000', 'IngestionDate');

-- Record 9: HR, Database source
INSERT INTO dbo.MetadataIngestion 
    (BusinessUnit, SourceType, SourceName, FilePath, SourceSchema, Description, CreatedDate, PartitionColumn)
VALUES 
    ('HR', 'Database', 'HRTable', 'HR', 'hr', 'Human resources data from the database', '2025-03-31T22:16:17.3730000', 'IngestionDate');

-- Record 10: Operations, CSV source
INSERT INTO dbo.MetadataIngestion 
    (BusinessUnit, SourceType, SourceName, FilePath, SourceSchema, Description, CreatedDate, PartitionColumn)
VALUES 
    ('Operations', 'CSV', 'OperationsData', 'operations_data.csv', 'raw-zone', 'Operational data in CSV', '2025-03-31T22:16:17.3730000', 'IngestionDate');
GO
