SELECT *
FROM Nashville..housing

-- sale date format
SELECT SaleDateConverted, CONVERT(DATE, SaleDate)
FROM Nashville..housing

UPDATE housing
SET SaleDate = Convert(Date, SaleDate)

ALTER TABLE housing
ADD SaleDateConverted Date;

UPDATE housing
SET SaleDateConverted = Convert(Date, SaleDate)



-- property address
SELECT *
FROM Nashville..housing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville..housing a
JOIN Nashville..housing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville..housing a
JOIN Nashville..housing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

 
-- break out address into individual columns (address, city, state) ( IMPORTANT ) using substring
SELECT PropertyAddress
FROM Nashville..housing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM housing

ALTER TABLE housing
ADD PropertySplitAddress Nvarchar(255)

UPDATE housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE housing
ADD PropertySplitCity Nvarchar(255)

UPDATE housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


-- Now same thing with owner address but using parcename ( MUCH EASIER )

SELECT OwnerAddress
FROM Nashville..housing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM housing

ALTER TABLE housing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE housing
ADD OwnerSplitCity Nvarchar(255)

UPDATE housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE housing
ADD OwnerSplitState Nvarchar(255)

UPDATE housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM housing


-- change y and n to yes and no in sold as vacant
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM housing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM housing

UPDATE housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- drop useless columns
SELECT *
FROM housing

ALTER TABLE housing
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate