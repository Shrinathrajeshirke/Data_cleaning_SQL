/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [data_cleaning_sql].[dbo].[NashvilleHousing]

  /*
  Cleaning data in SQL
  */

  select * 
  from NashvilleHousing

--Standardize date format

Alter Table NashvilleHousing
Add SaleDateNew Date

Update NashvilleHousing
set SaleDateNew = CONVERT(Date,SaleDate)

select * from NashvilleHousing

--Property address

Select PropertyAddress
From NashvilleHousing
where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing as a
Join NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing as a
Join NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking an Address into Individual columns (Address, city, State)
--Select PropertyAddress
--From NashvilleHousing
Alter Table NashvilleHousing
Add Address Nvarchar(255);

Update NashvilleHousing
set Address = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add City Nvarchar(255);

Update NashvilleHousing
set City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


Select OwnerAddress
From NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select OwnerAddress, OwnerAddress, OwnerState
From NashvilleHousing

--Change Y and N to Yes and No in "SoldAsVacant" column

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
Order by 2

Select SoldAsVacant 
, CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
From NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
From NashvilleHousing
group by SoldAsVacant
Order by 2

--Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From NashvilleHousing
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From NashvilleHousing


-- Delete Unused Columns

Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerCity

