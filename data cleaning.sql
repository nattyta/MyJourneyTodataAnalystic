
-----------------------------------------------------------------------------------------------
-- data cleaning using sql


select SaleDateConverted
from NashvillHousing


---------------------------------------------------------------------------------------------------------------------------------------------------
-- standardalizing date



update NashvillHousing
set [SaleDate] =CONVERT(date,SaleDate)

alter table NashvillHousing
add SaleDateConverted date;

update NashvillHousing
set  SaleDateConverted=CONVERT(date,SaleDate)


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- populate prorperty adress data



select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from NashvillHousing a
join NashvillHousing b
on a.PropertyAddress=b.PropertyAddress
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set a.PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from NashvillHousing a
join NashvillHousing b
on a.PropertyAddress=b.PropertyAddress
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--breaking out the adress into individual column ( adress,city,state)



select PropertyAddress
from NashvillHousing


select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as adress ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as adress
from NashvillHousing

alter table NashvillHousing
add PropertySplitAddress nvarchar(255);

update NashvillHousing
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


alter table NashvillHousing
add PropertySplitCity nvarchar(255);

update NashvillHousing
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


select *
from NashvillHousing


select
PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from NashvillHousing


alter table NashvillHousing
add ownerSplitadress nvarchar(255);

update NashvillHousing
set ownerSplitadress=PARSENAME(replace(owneraddress,',','.'),3)


alter table NashvillHousing
add ownerSplitCity nvarchar(255);

update NashvillHousing
set ownerSplitCity=PARSENAME(replace(owneraddress,',','.'),2)



alter table NashvillHousing
add ownerSplitState nvarchar(255);

update NashvillHousing
set ownerSplitState=PARSENAME(replace(owneraddress,',','.'),1)



--------------------------------------------------------------------------------------------------------------
-- change 'y' and 'n' to 'yes' and 'no''

select SoldAsVacant,
case 
when SoldAsVacant = 'y' then 'yes'
when SoldAsVacant = 'n' then 'no'
else SoldAsVacant
end
from NashvillHousing


update NashvillHousing
set SoldAsVacant =case 
when SoldAsVacant = 'y' then 'yes'
when SoldAsVacant = 'n' then 'no'
else SoldAsVacant
end


-----------------------------------------------------------------------------------------------------------------------------------------------------

-- remove duplicates

with rownumCTE as (
select *,
row_number() over(
partition by parcelid,
propertyaddress,
saleprice,
saledate,
legalreference
order by uniqueId) row_num

from NashvillHousing
)
select * 
from rownumCTE
where row_num > 1
order by propertyaddress 


------------------------------------------------------------------------------------------------------------------------------

-- delete unused colunm

alter table NashvillHousing
drop column  propertyaddress,owneraddress,SaleDate,taxdistrict
