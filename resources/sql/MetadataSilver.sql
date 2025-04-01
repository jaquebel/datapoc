-- Drop the MetadataSilver table if it exists
IF OBJECT_ID('dbo.MetadataSilver', 'U') IS NOT NULL
    DROP TABLE dbo.MetadataSilver;
GO

-- Create the MetadataSilver table
CREATE TABLE dbo.MetadataSilver (
    Id INT IDENTITY(1,1) PRIMARY KEY,                -- Auto-generated primary key
    BusinessUnit VARCHAR(50) NOT NULL,               -- Business unit (e.g., Sales, Finance, HR, Marketing)
    SourceName VARCHAR(100) NOT NULL,                -- Name of the data source (e.g., table or file name without extension)
    SourceSchema VARCHAR(100) NOT NULL,              -- Schema or folder associated with the source
    executionnotebooks VARCHAR(500) NOT NULL         -- Comma-separated list of Databricks notebooks to execute for transformation
);
GO

-- Insert sample records for MetadataSilver

-- For Sales: Two records representing a Database source and a CSV source
INSERT INTO dbo.MetadataSilver (BusinessUnit, SourceName, SourceSchema, executionnotebooks)
VALUES 
    ('Sales', 'SalesTable', 'dbo', 'GenericTransformationNotebook,SalesTransformationNotebook');

INSERT INTO dbo.MetadataSilver (BusinessUnit, SourceName, SourceSchema, executionnotebooks)
VALUES 
    ('Sales', 'SalesAdditional', 'dbo', 'GenericTransformationNotebook,SalesTransformationNotebook');

-- For Finance: Single record for Finance data transformation using the generic notebook
INSERT INTO dbo.MetadataSilver (BusinessUnit, SourceName, SourceSchema, executionnotebooks)
VALUES 
    ('Finance', 'FinanceData', 'dbo', 'GenericTransformationNotebook');

-- For HR: Single record for HR data transformation using the generic notebook
INSERT INTO dbo.MetadataSilver (BusinessUnit, SourceName, SourceSchema, executionnotebooks)
VALUES 
    ('HR', 'HRData', 'dbo', 'GenericTransformationNotebook');

-- For Marketing: Single record for Marketing data transformation using the generic notebook
INSERT INTO dbo.MetadataSilver (BusinessUnit, SourceName, SourceSchema, executionnotebooks)
VALUES 
    ('Marketing', 'MarketingData', 'dbo', 'GenericTransformationNotebook');
GO
