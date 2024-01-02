/*

Cleaning Data in SQL Queries

*/

Select*
From PortfolioProject.dbo.NashvilleHousing
--------------------------------------------------------------------------------
--Standardize Date Format

Select SaleDateConverted,CONVERT(Date , SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

ALTER TABLE PortfolioProject..NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject..NashvilleHousing
SET SaleDateCoverted = CONVERT(Date, SaleDate)

--------------------------------------------------------------------------------
--Populate Property Address Data

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--Where Propertyaddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------
--Breaking out Address into Individual Coloumns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--Where Propertyaddress is null
--Order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 )

ALTER TABLE PortfolioProject..NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select*
From PortfolioProject..NashvilleHousing



Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select*
From PortfolioProject..NashvilleHousing

---------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant) , COUNT(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'YES'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
From PortfolioProject..NashvilleHousing


Update PortfolioProject..NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'YES'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
---------------------------------------------------------------------------------
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

From PortfolioProject..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
ORDER BY PropertyAddress


---------------------------------------------------------------------------------
--Delete Unused Coloumns

Select*
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate, OwnerAddress, TaxDistrict, PropertyAddress

----------------------------------------------------------------------------------