/*

Cleaning Data in SQL Queries

*/


SELECT *
FROM [Portfolio Project]..NashvilleHousing

-- Standardize Date Format

--Select SaleDate, CONVERT(Date, SaleDate) as NewSaleDate
--FROM [Portfolio Project]..NashvilleHousing

--UPDATE [Portfolio Project]..NashvilleHousing
--SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE [Portfolio Project]..NashvilleHousing
ADD SaleDateConverted Date;

UPDATE [Portfolio Project]..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT *
FROM [Portfolio Project]..NashvilleHousing

-- Populate Property Address data

SELECT *
FROM [Portfolio Project]..NashvilleHousing
--Where PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project]..NashvilleHousing a
JOIN [Portfolio Project]..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project]..NashvilleHousing a
JOIN [Portfolio Project]..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

SELECT *
FROM [Portfolio Project]..NashvilleHousing

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [Portfolio Project]..NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
FROM [Portfolio Project]..NashvilleHousing

ALTER TABLE [Portfolio Project]..NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update [Portfolio Project]..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [Portfolio Project]..NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update [Portfolio Project]..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM [Portfolio Project]..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM [Portfolio Project]..NashvilleHousing

ALTER TABLE [Portfolio Project]..NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE [Portfolio Project]..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE [Portfolio Project]..NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE [Portfolio Project]..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE [Portfolio Project]..NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE [Portfolio Project]..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
FROM [Portfolio Project]..NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT (SoldAsVacant), Count(SoldAsVacant)
FROM [Portfolio Project]..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM [Portfolio Project]..NashvilleHousing

Update [Portfolio Project]..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
				   When SoldAsVacant = 'N' THEN 'No'
	               ELSE SoldAsVacant
	               END

SELECT *
FROM [Portfolio Project]..NashvilleHousing

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
             PARTITION BY ParcelID,
		                  PropertyAddress,
			              SalePrice,
			              SaleDate,
			              LegalReference
			 ORDER BY UniqueID
			 ) AS row_num
FROM [Portfolio Project]..NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1

SELECT * 
FROM [Portfolio Project]..NashvilleHousing

-- Delete Unused Columns

ALTER TABLE [Portfolio Project]..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

SELECT*
FROM [Portfolio Project]..NashvilleHousing
