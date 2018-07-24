library(tidycensus)

census_api_key("d6ae38c07a1b52d139c729945d7c88ea266806b1", install=TRUE, overwrite=TRUE)

acs5_vars <- load_variables(2016, "acs5", cache=TRUE)
acs5_vars$dataset = 'acs5'
acs1_vars <- load_variables(2016, "acs1", cache=TRUE)
acs1_vars$dataset = 'acs1'

acs1_5_vars = rbind(acs1_vars, acs5_vars)

write.csv(acs1_5_vars, "~/Downloads/acs_vars.csv", row.names=FALSE)

VARS = c(
    pop = "B01003_001",
    # Gender. Default = female.
    male = "B01001_002",
    # Race. Default = American Indian & Alaska Native + Asian + 
    # Native Hawaiian and Other Pacific Islander + Some other race.
    white = "B02001_002",
    black = "B02001_003",
    multiracial = "B02001_008",
    # Hispanic or Latino. Default: Not Hispanic or Latino.
    hispanic_latino = "B03002_012",
    # Nativity and citizenship. Default: Born in US/PR or abroad of American parents.
    naturalized = "B05001_005",
    noncitizen = "B05001_006",
    # Poverty. Default: Ratio of income to poverty level exceeds 1.00.
    poverty = "B05010_002",
    # Age. Default: 1 to 4 years.
    age5_17 = "B07001_003",
    age18_19 = "B07001_004",
    age20_24 = "B07001_005",
    age25_29 = "B07001_006",
    age30_34 = "B07001_007",
    age35_39 = "B07001_008",
    age40_44 = "B07001_009",
    age45_49 = "B07001_010",
    age50_54 = "B07001_011",
    age55_59 = "B07001_012",
    age60_64 = "B07001_013",
    age65_69 = "B07001_014",
    age70_74 = "B07001_015",
    age75_plus = "B07001_016",
    # Movers. Default: Movers of some sort.
    # ** Not available by county. **
#     same_residence = "B07101_002",
    # Educational attainment of population 25 years and over.
    education_denom = "B15003_001",
    education_high_school = "B15003_017",
    education_ged = "B15003_018",
    education_some_college_u1y = "B15003_019",
    education_some_college_1y = "B15003_020",
    education_associate = "B15003_021",
    education_bachelor = "B15003_022",
    education_master = "B15003_023",
    education_professional = "B15003_024",
    education_doctorate = "B15003_025",
    # Employment status of population 16y+. Default: employed.
    employment_denom = "B23025_001",
    unemployed = "B23025_005",
    not_in_labor_force = "B23025_007",
    # Language for the population 5 years and over. Default: Something else.
    # ** Not available by county. **
#     language_total = "B16001_001",
#     english_only = "B16001_002",
    # Aggregate household income in the past 12 months (in 2016 inflation-adjusted dollars).
    agg_hh_income = "B19025_001"
)


counties_long <- get_acs(geography="county", year=2016, survey="acs5",
                         variables=VARS)
counties_wide <- get_acs(geography="county", year=2016, survey="acs5",
                         variables=VARS, output="wide")

# Remove PR (doesn't have all fields, and not included in the model).
counties_wide = counties_wide[substr(counties_wide$GEOID, 1, 2) != '72', ]

varmap = data.frame(variable = VARS, variable_name = names(VARS))
counties_long = merge(counties_long, varmap, by="variable")

counties_wide_e_only <- 
    counties_wide[, c("GEOID", "NAME", paste0(names(VARS), "E"))]
names(counties_wide_e_only) = c("GEOID", "NAME", names(VARS))

write.csv(counties_wide, "~/Downloads/counties_wide.csv", row.names=FALSE)
write.csv(counties_wide_e_only, "~/Downloads/counties_wide_e_only.csv", row.names=FALSE)
write.csv(counties_long, "~/Downloads/counties_long.csv", row.names=FALSE)
counties_long = counties_long[substr(counties_wide$GEOID, 1, 2) != '72', ]
