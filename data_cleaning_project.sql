use portfolioproject;

select * from NashvilleHousing;

--Standardize Date format

select saledate from NashvilleHousing;

update nashvillehousing
set saledate = convert(date,saledate);

alter table nashvillehousing
add saledateconverted date;

update nashvillehousing
set saledateconverted = convert(date,saledate);

select saledateconverted from nashvillehousing


-- Populate property address data
select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress, ISNULL(a.propertyaddress,b.propertyaddress) 
from nashvillehousing a inner join nashvillehousing b
on a.parcelid = b.parcelid
and a.uniqueid != b.uniqueid
where a.propertyaddress is null

update a
set a.propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress) 
from nashvillehousing a inner join nashvillehousing b
on a.parcelid = b.parcelid
and a.uniqueid != b.uniqueid
where a.propertyaddress is null



--breaking out address into individual columns(address,city,state)
select propertyaddress from nashvillehousing
order by parcelid

select 
SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) as Address1,
SUBSTRING(propertyaddress,charindex(',',propertyaddress)+2,len(propertyaddress)) as Address2
from nashvillehousing

alter table nashvillehousing
add PropertySplitAddress nvarchar(255);

alter table nashvillehousing
add PropertySplitCity nvarchar(255);

update nashvillehousing
set PropertySplitAddress = SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)
from nashvillehousing

update nashvillehousing
set PropertySplitCity = SUBSTRING(propertyaddress,charindex(',',propertyaddress)+2,len(propertyaddress))
from nashvillehousing

select PropertySplitAddress,PropertySplitCity from nashvillehousing
order by parcelid


Select 
parsename(replace(ownerAddress,',','.'),3),
parsename(replace(ownerAddress,',','.'),2), 
parsename(replace(ownerAddress,',','.'),1) 
from nashvillehousing;

alter table nashvillehousing
add OwnerSplitAddress nvarchar(255);

alter table nashvillehousing
add OwnerSplitCity nvarchar(255);

alter table nashvillehousing
add OwnerSplitState nvarchar(255);

update nashvillehousing
set ownersplitaddress = parsename(replace(ownerAddress,',','.'),3)

update nashvillehousing
set ownersplitcity = parsename(replace(ownerAddress,',','.'),2)

update nashvillehousing
set ownersplitstate = parsename(replace(ownerAddress,',','.'),1)

select distinct(soldasvacant) from nashvillehousing


-- replace y and n as YES and NOin soldasVacant
update nashvillehousing
set soldasvacant = 'Yes'
where soldasvacant = 'Y'

update nashvillehousing
set soldasvacant = 'No'
where soldasvacant = 'N'


-- remove duplicates
with rownum_cte as (select *, ROW_NUMBER() 
			over(partition by parcelid,
				propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by 
				uniqueid) row_num
from nashvillehousing)
--order by parcelid)

delete
from rownum_cte
where row_num>1


-- delete unused column
Alter table nashvillehousing
drop column propertyaddress,owneraddress;

Alter table nashvillehousing
drop column saledate;







