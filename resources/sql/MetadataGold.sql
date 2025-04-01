-- Drop the MetadataGold table if it exists
IF OBJECT_ID('dbo.MetadataGold', 'U') IS NOT NULL
    DROP TABLE dbo.MetadataGold;
GO

-- Create the MetadataGold table
CREATE TABLE dbo.MetadataGold (
    Id INT IDENTITY(1,1) PRIMARY KEY,               -- Auto-generated primary key
    BusinessUnit VARCHAR(50) NOT NULL,              -- Business unit (e.g., Sales, Finance, HR, Marketing)
    SourceName VARCHAR(100) NOT NULL,               -- Name of the data source (table or file name without extension)
    mask_columns VARCHAR(500) NULL                  -- Comma-separated list of columns to mask in the final Gold layer; if empty, no masking is applied
);
GO

-- Insert sample records for MetadataGold

-- For Sales: Two records with masking configuration for both the Database and CSV sources
INSERT INTO dbo.MetadataGold (BusinessUnit, SourceName, mask_columns)
VALUES ('Sales', 'SalesTable', 'ssn,email');

INSERT INTO dbo.MetadataGold (BusinessUnit, SourceName, mask_columns)
VALUES ('Sales', 'SalesAdditional', 'ssn,email');

-- For Finance: Single record with no masking required (empty string)
INSERT INTO dbo.MetadataGold (BusinessUnit, SourceName, mask_columns)
VALUES ('Finance', 'FinanceData', '');

-- For HR: Single record with masking for the 'ssn' column
INSERT INTO dbo.MetadataGold (BusinessUnit, SourceName, mask_columns)
VALUES ('HR', 'HRData', 'ssn');

-- For Marketing: Single record with no masking required (empty string)
INSERT INTO dbo.MetadataGold (BusinessUnit, SourceName, mask_columns)
VALUES ('Marketing', 'MarketingData', '');
GO
