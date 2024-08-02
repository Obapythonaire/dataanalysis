

-- C:\Users\O.BA\Videos\Data Analysis\Alex-The-Analyst-Bootcamp-main\Alex-The-Analyst-Bootcamp-main\SQL\Data-Cleaning

-- LOAD DATA local INFILE 'C:/Users/O.BA/Videos/Data Analysis/Alex-The-Analyst-Bootcamp-main/Alex-The-Analyst-Bootcamp-main/SQL/Data-Cleaning/NashvilleHousinDataforDataCleaning.csv'
-- INTO TABLE nashvillehousingdata
-- fields terminated by ','
-- enclosed by '"'
-- lines terminated by '\n'
-- ignore 1 rows;

-- SELECT count(*) 
-- FROM covidimpact.nashvillehousingdata;

-- SELECT *
-- FROM covidimpact.nashvillehousingdata;

-- standardize the sale date
-- select SaleDate, convert(date.SaleDate)
-- from covidimpact.nashvillehousingdata;

-- this works
-- SELECT SaleDate, STR_TO_DATE(SaleDate, '%Y-%m-%d') AS StandardizedSaleDate
-- FROM covidimpact.nashvillehousingdata;

-- update the table

-- ALTER TABLE covidimpact.nashvillehousingdata
-- ADD StandardizedSaleDate DATE;

-- UPDATE covidimpact.nashvillehousingdata
-- SET StandardizedSaleDate = STR_TO_DATE(SaleDate, '%Y-%m-%d');

-- check properaddress that are null

-- select *
-- from covidimpact.nashvillehousingdata
-- where PropertyAddress is null;

-- populate property address using self join
-- Set property address field as NULL if empty
-- UPDATE housing_data SET PropertyAddress=IF(PropertyAddress='',NULL,PropertyAddress);

-- SELECT *
-- FROM housing_data
-- -- WHERE PropertyAddress IS NULL
-- ORDER BY ParcelID;

-- Self Join 
-- COALESCE converts NULL values from one column to another value specified after it

-- SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress, b.PropertyAddress)
-- FROM housing_data a
-- JOIN housing_data b
-- ON a.ParcelID = b.ParcelID
-- AND a.UniqueID <> b.UniqueID
-- WHERE a.PropertyAddress IS NULL;

-- Breaking address into individual columns(address, city, state)
-- select PropertyAddress
-- from covidimpact.nashvillehousingdata

-- select
-- substring(PropertyAddress, 1, charindex(',', PropertyAddress)) as Address
-- from covidimpact.nashvillehousingdata;

-- USE SUBSTRING_INDEX instead of SUBSTRING to split the Owner Address


-- ALTER TABLE nashvillehousingdata
-- ADD COLUMN PropertySplitAddress CHAR(255);

-- UPDATE nashvillehousingdata
-- SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(",", PropertyAddress) -1);

-- ALTER TABLE nashvillehousingdata
-- ADD COLUMN PropertySplitCity CHAR(255);

-- UPDATE nashvillehousingdata
-- SET PropertySplitCity = SUBSTRING(PropertyAddress, LOCATE(",", PropertyAddress) +1, LENGTH(PropertyAddress));

-- SELECT PropertySplitAddress, PropertySplitCity 
-- FROM nashvillehousingdata;

-- Disable safe mode
-- SET SQL_SAFE_UPDATES = 0;

-- ALTER TABLE nashvillehousingdata
-- ADD COLUMN PropertySplitAddress VARCHAR(255);

-- ALTER TABLE nashvillehousingdata
-- ADD COLUMN PropertySplitCity VARCHAR(255);

-- UPDATE nashvillehousingdata
-- SET PropertySplitAddress = CASE
--     WHEN LOCATE(',', PropertyAddress) > 0 THEN SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1)
--     ELSE PropertyAddress
-- END;

-- UPDATE nashvillehousingdata
-- SET PropertySplitCity = CASE
--     WHEN LOCATE(',', PropertyAddress) > 0 THEN 
--         TRIM(SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1))
--     ELSE ''
-- END;

-- SELECT PropertySplitAddress, PropertySplitCity 
-- FROM nashvillehousingdata;

-- Splitting owner address into address, city, and state
-- This only work on sql server and not on mysql workbench
-- select
-- PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
-- ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
-- ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
-- from nashvillehousingdata

-- this worked on mysql workbench
-- SELECT 
--     SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Address,
--     TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS City,
--     TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS State
-- FROM nashvillehousingdata;

-- Again, below only work with sql server
-- alter table nashvillehousingdata
-- add ownersplitaddress nvarchar(255);

-- update nashvillehousingdata
-- set OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Address

-- but this worked with mysql to update the colum for each address, city and state
-- Add the new column OwnerSplitAddress
-- ALTER TABLE nashvillehousingdata
-- ADD COLUMN OwnerSplitAddress VARCHAR(255);

-- -- Update the new column with the extracted address part
-- SET SQL_SAFE_UPDATES = 0;  -- This is done to enable safe update
-- SET GLOBAL net_read_timeout = 600;  -- This and the next 2 qqueries to solve the proble of 'lost connection to mysql server during query', though i ran 3ce in most cases
-- SET GLOBAL net_write_timeout = 600;
-- SET GLOBAL wait_timeout = 600;

-- UPDATE nashvillehousingdata
-- SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

-- -- Add the new column for OwnerSplitCity
-- ALTER TABLE nashvillehousingdata
-- ADD COLUMN OwnerSplitCity VARCHAR(255);
-- -- Update the new column with the extracted city part
-- SET SQL_SAFE_UPDATES = 0;
-- SET GLOBAL net_read_timeout = 600;
-- SET GLOBAL net_write_timeout = 600;
-- SET GLOBAL wait_timeout = 600;

-- UPDATE nashvillehousingdata
-- SET OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1));

-- -- Add the new column for OwnerSplitState
-- ALTER TABLE nashvillehousingdata
-- ADD COLUMN OwnerSplitState VARCHAR(255);
-- -- Update the new column with the extracted state part
-- SET SQL_SAFE_UPDATES = 0;
-- SET GLOBAL net_read_timeout = 600;
-- SET GLOBAL net_write_timeout = 600;
-- SET GLOBAL wait_timeout = 600;

-- UPDATE nashvillehousingdata
-- SET OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));


-- Change Y and N to Yes and No in "Sold as Vacant" field
-- first let's check the SoldAsVacant column

-- select distinct(SoldAsVacant), count(SoldAsVacant)
-- from nashvillehousingdata
-- group by SoldAsVacant

-- Now let's rename all to yes or no
-- select SoldAsVacant,
-- 	case when SoldAsVacant = 'Y' Then 'Yes'
--     when SoldAsVacant = 'N' Then 'No'
--     Else SoldAsVacant
--     End SoldAsVacantLabel
-- from nashvillehousingdata;

-- -- update the yes and no columns
-- UPDATE nashvillehousingdata
-- SET SoldasVacant = 'Yes'
-- WHERE SoldasVacant = 'Y';

-- UPDATE nashvillehousingdata
-- SET SoldasVacant = 'No'
-- WHERE SoldasVacant = 'N';
    
-- Remove duplicates

-- PARTITION BY values that should be unique, where ROW_NUMBER returns the row_num 
-- Gives error 1288, saying target CTE of the DELETE is not updatable 

-- this didnt work
-- WITH Row_Num_CTE AS (
-- SELECT *,
-- 	ROW_NUMBER() OVER (
--     PARTITION BY ParcelID,
-- 				 PropertyAddress,
--                  SalePrice,
--                  SaleDate,
--                  LegalReference
--                  ORDER BY 
-- 					UniqueID
--                     ) AS row_num
-- FROM nashvillehousingdata)
-- DELETE
-- FROM Row_Num_CTE
-- WHERE row_num > 1;

-- But this work

-- DELETE FROM nashvillehousingdata
-- WHERE UniqueID NOT IN (
--     SELECT UniqueID FROM (
--         SELECT UniqueID,
--         ROW_NUMBER() OVER (
--             PARTITION BY ParcelID,
--                         PropertyAddress,
--                         SalePrice,
--                         SaleDate,
--                         LegalReference
--             ORDER BY UniqueID
--         ) AS row_num
--         FROM nashvillehousingdata
--     ) subquery
--     WHERE row_num = 1
-- );

-- Delete Unused Columns

ALTER TABLE nashvillehousingdata
DROP COLUMN OwnerAddress, 
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;

-- Check final data cleaning results
SELECT count(*)
FROM nashvillehousingdata;

-- SELECT SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Address,
-- SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,',',2), ',', -1) AS City,
-- SUBSTRING_INDEX(OwnerAddress, ',', -1) AS State
-- FROM nashvillehousingdata;