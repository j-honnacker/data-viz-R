
# 1. Intro ----

library(readxl)
library(magrittr)   # for the pipe
library(data.table)

# set working directory
'setwd("/Users/jhonnacker/data-viz-R")'

# Load data into a DataFrame
ames <- read_excel("data_stg0/AmesHousing.xls")

# Turn DataFrame into a DataTable
ames <- data.table(ames)


# 2. Preparing data ----

## Author's suggestions ----

plot(x=ames$'Gr Liv Area', y=ames$'SalePrice')

ames <- ames[`Gr Liv Area` <= 4000,]




## 2.1 Categorical variables ----

### 2.1.1 Nominal variables ----

# Vector of the names of all nominal variables
nominal_cols = c('MS SubClass', 'MS Zoning', 'Street', 'Alley', 'Land Contour', 'Lot Config',
                'Neighborhood', 'Condition 1', 'Condition 2', 'Bldg Type', 'House Style',
                'Roof Style', 'Roof Matl', 'Exterior 1st', 'Exterior 2nd', 'Mas Vnr Type', 'Foundation',
                'Heating', 'Central Air', 'Garage Type', 'Misc Feature', 'Sale Type', 'Sale Condition')


# Make sure the data type of the nominal variables is 'factor'
ames[,(nominal_cols) := lapply(.SD, as.factor), .SDcols=nominal_cols]

# Display first 5 rows of all nominal variables
head( ames[,nominal_cols, with=FALSE] )

# Verify data type
str( ames[,nominal_cols, with=FALSE] )



### 2.1.2 Ordinal variables with standard categories ----

# Vector of the names of the ordinal variables that share a common set of categories
stndrd_cat = c('NA', 'Po', 'Fa', 'TA', 'Gd', 'Ex')

# Vector of the "standard" categories
stndrd_cat_cols = c('Exter Qual', 'Exter Cond',
                   'Garage Qual', 'Garage Cond',
                   'Bsmt Qual', 'Bsmt Cond',
                   'Heating QC', 'Kitchen Qual')

# Assign "standard" categories to "standard" ordinal variables
ames[,(stndrd_cat_cols) := lapply(.SD, factor, levels=stndrd_cat, ordered=TRUE), .SDcols=stndrd_cat_cols]

# Display first 5 rows of all ordinal variables with "standard" categories
head( ames[,stndrd_cat_cols, with=FALSE] )

# Verify data type
str( ames[,stndrd_cat_cols, with=FALSE] )



### 2.1.3 Ordinal variables with individual categories ----

ames[, `Bsmt Exposure` := factor(`Bsmt Exposure`, levels=c('No', 'Mn', 'Av', 'Gd'), ordered=TRUE)]


BsmtFinType_cols = c('BsmtFin Type 1', 'BsmtFin Type 2')

ames[, (BsmtFinType_cols):= lapply(.SD, factor,
                                   levels  = c('Unf', 'LwQ', 'Rec', 'BLQ', 'ALQ', 'GLQ'),
                                   ordered = TRUE
                                   ),
     .SDcols = BsmtFinType_cols]


ames[, Functional := factor(Functional,
                            levels=c('Sal', 'Sev', 'Maj2', 'Maj1', 'Mod', 'Min2', 'Min1', 'Typ'),
                            ordered=TRUE)]


ames[, `Garage Finish` := factor(`Garage Finish`,
                                 levels=c('Unf', 'RFn', 'Fin'), ordered=TRUE)]

# Display first 5 rows
head( ames[, c('Bsmt Exposure', BsmtFinType_cols, 'Functional', 'Garage Finish'), with=FALSE] )

# Verify data type
str( ames[, c('Bsmt Exposure', BsmtFinType_cols, 'Functional', 'Garage Finish'), with=FALSE] )


### 2.2 Continuous variables ----

continuous_cols = c('SalePrice',
                    'Lot Frontage', 'Lot Area',
                    'Mas Vnr Area',
                    'BsmtFin SF 1', 'BsmtFin SF 2', 'Bsmt Unf SF', 'Total Bsmt SF',
                    '1st Flr SF', '2nd Flr SF', 'Low Qual Fin SF', 'Gr Liv Area',
                    'Garage Area', 'Wood Deck SF',
                    'Open Porch SF', 'Enclosed Porch', '3Ssn Porch', 'Screen Porch', 'Pool Area', 'Misc Val')

# Display first 5 rows
head( ames[, continuous_cols, with=FALSE] )

# Verify data type
str( ames[, continuous_cols, with=FALSE] )

# 3. Storing prepared data ----
# Save data.table to CSV
fwrite(ames, file = "data_stg1/ames.csv")
