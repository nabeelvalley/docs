<a href="https://cognitiveclass.ai"><img src = "https://ibm.box.com/shared/static/9gegpsmnsoo25ikkbl4qzlvlyjbgxs5x.png" width = 400> </a>

<h1 align=center><font size = 5>From Understanding to Preparation</font></h1>

## Introduction

In this lab, we will continue learning about the data science methodology, and focus on the **Data Understanding** and the **Data Preparation** stages.

## Table of Contents

<div class="alert alert-block alert-info" style="margin-top: 20px">
1. [Recap](#0)<br>
2. [Data Understanding](#2)<br>
3. [Data Preparation](#4)<br>
</div>
<hr>

# Recap <a id="0"></a>

In Lab **From Requirements to Collection**, we learned that the data we need to answer the question developed in the business understanding stage, namely *can we automate the process of determining the cuisine of a given recipe?*, is readily available. A researcher named Yong-Yeol Ahn scraped tens of thousands of food recipes (cuisines and ingredients) from three different websites, namely:

<img src = "https://ibm.box.com/shared/static/4fruwan7wmjov3gywiz3swlojw0srv54.png" width=500>

www.allrecipes.com

<img src = "https://ibm.box.com/shared/static/cebfdbr22fjxa47lltp0bs533r103g0z.png" width=500>

www.epicurious.com

<img src = "https://ibm.box.com/shared/static/epk727njg7xrz49pbkpkzd05cm5ywqmu.png" width=500>

www.menupan.com

For more information on Yong-Yeol Ahn and his research, you can read his paper on [Flavor Network and the Principles of Food Pairing](http://yongyeol.com/papers/ahn-flavornet-2011.pdf).

We also collected the data and placed it on an IBM server for your convenience.

------------

# Data Understanding <a id="2"></a>

<img src="https://ibm.box.com/shared/static/89geb3m0ge1z73s92hl8o8wdcpcrggtz.png" width=500>

<strong>Important note:</strong> Please note that you are not expected to know how to program in R. The following code is meant to illustrate the stages of data understanding and data preparation, so it is totally fine if you do not understand the individual lines of code. We have a full course on programming in R, <a href="http://cocl.us/RP0101EN_DS0103EN_LAB3_R">R101</a>, so please feel free to complete the course if you are interested in learning how to program in R.

### Using this notebook:

To run any of the following cells of code, you can type **Shift + Enter** to excute the code in a cell.

Get the version of R installed.

```py
# check R version
R.Version()$version.string
```


Download the data from the IBM server.

```py
# click here and press Shift + Enter
download.file("https://ibm.box.com/shared/static/5wah9atr5o1akuuavl2z9tkjzdinr1lv.csv",
              destfile = "/resources/data/recipes.csv", quiet = TRUE)

recipes <- read.csv("/resources/data/recipes.csv") # takes 30 seconds
```


Show the first few rows.

```py
head(recipes)
```


Get the dimensions of the dataframe.

```py
nrow(recipes)
```


```py
ncol(recipes)
```


So our dataset consists of 57,691 recipes. Each row represents a recipe, and for each recipe, the corresponding cuisine is documented as well as whether 384 ingredients exist in the recipe or not beginning with almond and ending with zucchini.

We know that a basic sushi recipe includes the ingredients:
* rice
* soy sauce
* wasabi
* some fish/vegetables

Let's check that these ingredients exist in our dataframe:

```py
grep("rice", names(recipes), value = TRUE) # yes as rice
grep("wasabi", names(recipes), value = TRUE) # yes
grep("soy", names(recipes), value = TRUE) # yes as soy_sauce
```


Yes, they do!

* rice exists as rice.
* wasabi exists as wasabi.
* soy exists as soy_sauce.

So maybe if a recipe contains all three ingredients: rice, wasabi, and soy_sauce, then we can confidently say that the recipe is a **Japanese** cuisine! Let's keep this in mind!

----------------

# Data Preparation <a id="4"></a>

<img src="https://ibm.box.com/shared/static/lqc2j3r0ndhokh77mubohwjqybzf8dhk.png" width=500>

In this section, we will prepare the data for the next stage in the data science methodology, which is modeling. This stage involves exploring the data further and making sure that it is in the right format for the machine learning algorithm that we selected in the analytic approach stage, which is decision trees.

First, look at the data to see if it needs cleaning.

```py
base::table(recipes$country) # frequency table
```


By looking at the above table, we can make the following observations:

1. Cuisine column is labeled as Country, which is inaccurate.
2. Cuisine names are not consistent as not all of them start with an uppercase first letter.
3. Some cuisines are duplicated as variation of the country name, such as Vietnam and Vietnamese.
4. Some cuisines have very few recipes.

#### Let's fixes these problems.

Fix the name of the column showing the cuisine.

```py
colnames(recipes)[1] = "cuisine"
```


Make all the cuisine names lowercase.

```py
recipes$cuisine <- tolower(as.character(recipes$cuisine))

recipes
```


Make the cuisine names consistent.

```py
recipes$cuisine[recipes$cuisine == "austria"] <- "austrian"
recipes$cuisine[recipes$cuisine == "belgium"] <- "belgian"
recipes$cuisine[recipes$cuisine == "china"] <- "chinese"
recipes$cuisine[recipes$cuisine == "canada"] <- "canadian"
recipes$cuisine[recipes$cuisine == "netherlands"] <- "dutch"
recipes$cuisine[recipes$cuisine == "france"] <- "french"
recipes$cuisine[recipes$cuisine == "germany"] <- "german"
recipes$cuisine[recipes$cuisine == "india"] <- "indian"
recipes$cuisine[recipes$cuisine == "indonesia"] <- "indonesian"
recipes$cuisine[recipes$cuisine == "iran"] <- "iranian"
recipes$cuisine[recipes$cuisine == "israel"] <- "jewish"
recipes$cuisine[recipes$cuisine == "italy"] <- "italian"
recipes$cuisine[recipes$cuisine == "japan"] <- "japanese"
recipes$cuisine[recipes$cuisine == "korea"] <- "korean"
recipes$cuisine[recipes$cuisine == "lebanon"] <- "lebanese"
recipes$cuisine[recipes$cuisine == "malaysia"] <- "malaysian"
recipes$cuisine[recipes$cuisine == "mexico"] <- "mexican"
recipes$cuisine[recipes$cuisine == "pakistan"] <- "pakistani"
recipes$cuisine[recipes$cuisine == "philippines"] <- "philippine"
recipes$cuisine[recipes$cuisine == "scandinavia"] <- "scandinavian"
recipes$cuisine[recipes$cuisine == "spain"] <- "spanish_portuguese"
recipes$cuisine[recipes$cuisine == "portugal"] <- "spanish_portuguese"
recipes$cuisine[recipes$cuisine == "switzerland"] <- "swiss"
recipes$cuisine[recipes$cuisine == "thailand"] <- "thai"
recipes$cuisine[recipes$cuisine == "turkey"] <- "turkish"
recipes$cuisine[recipes$cuisine == "irish"] <- "uk-and-irish"
recipes$cuisine[recipes$cuisine == "uk-and-ireland"] <- "uk-and-irish"
recipes$cuisine[recipes$cuisine == "vietnam"] <- "vietnamese"

recipes
```


Remove cuisines with < 50 recipes:

```py
# sort the table of cuisines by descending order
t <- sort(base::table(recipes$cuisine), decreasing = T)

t
```


```py
# get cuisines with >= 50 recipes
filter_list <- names(t[t >= 50])

filter_list
```


```py
before <- nrow(recipes) # number of rows of original dataframe
print(paste0("Number of rows of original dataframe is ", before))

recipes <- recipes[recipes$cuisine %in% filter_list,]

after <- nrow(recipes)
print(paste0("Number of rows of processed dataframe is ", after))

print(paste0(before - after, " rows removed!"))
```


Convert all of the columns into factors. This is to run the classification model later.

```py
recipes[,names(recipes)] <- lapply(recipes[,names(recipes)], as.factor)

recipes
```


In R, you can check the structure of your data using the **str** function. Let's check the structure of our dataframe **recipes**.

```py
str(recipes)
```


#### Let's analyze the data a little more in order to learn the data better and note any interesting preliminary observations.

Run the following cell to get the recipes that contain **rice** *and* **soy** *and* **wasabi** *and* **seaweed**.

```py
check_recipes <- recipes[
    recipes$rice == "Yes" &
    recipes$soy_sauce == "Yes" &
    recipes$wasabi == "Yes" &
    recipes$seaweed == "Yes",
]

check_recipes
```


Based on the results of the above code, can we classify all recipes that contain **rice** *and* **soy** *and* **wasabi** *and* **seaweed** as **Japanese** recipes? Why?



Double-click __here__ for the solution.
<!-- The correct answer is:
No, because other recipes such as Asian and East_Asian recipes also contain these ingredients.
-->

Let's count the ingredients across all recipes.

```py
# sum the row count when the value of the row in a column is equal to "Yes" (value of 2)
ingred <- unlist(
            lapply( recipes[, names(recipes)], function(x) sum(as.integer(x) == 2))
            )

# transpose the dataframe so that each row is an ingredient
ingred <- as.data.frame( t( as.data.frame(ingred) ))
                
ing_df <- data.frame("ingredient" = names(ingred), 
                     "count" = as.numeric(ingred[1,])
                    )[-1,]
                
ing_df
```


Now we have a dataframe of ingredients and their total counts across all recipes. Let's sort this dataframe in descending order.

```py
ing_df_sort <- ing_df[order(ing_df$count, decreasing = TRUE),]
rownames(ing_df_sort) <- 1:nrow(ing_df_sort)

ing_df_sort
```


#### What are the 3 most popular ingredients?



Double-click __here__ for the solution.
<!-- The correct answer is:
// 1. Egg with 21,025 occurrences. 
// 2. Wheat with 20,781 occurrences. 
// 3. Butter with 20,719 occurrences.
-->

However, note that there is a problem with the above table. There are ~40,000 American recipes in our dataset, which means that the data is biased towards American ingredients.

**Therefore**, let's compute a more objective summary of the ingredients by looking at the ingredients per cuisine.

#### Let's create a *profile* for each cuisine.

In other words, let's try to find out what ingredients Chinese people typically use, and what is **Canadian** food for example.

```py
# create a dataframe of the counts of ingredients by cuisine, normalized by the number of 
# recipes pertaining to that cuisine
by_cuisine_norm <- aggregate(recipes, 
                        by = list(recipes$cuisine), 
                        FUN = function(x) round(sum(as.integer(x) == 2)/
                                                length(as.integer(x)),4))
# remove the unnecessary column "cuisine"
by_cuisine_norm <- by_cuisine_norm[,-2]

# rename the first column into "cuisine"
names(by_cuisine_norm)[1] <- "cuisine"
                            
head(by_cuisine_norm)
```


As shown above, we have just created a dataframe where each row is a cuisine and each column (except for the first column) is an ingredient, and the row values represent the percentage of each ingredient in the corresponding cuisine.

**For example**:

* *almond* is present across 15.65% of all of the **African** recipes.
* *butter* is present across 38.11% of all of the **Canadian** recipes.

Let's print out the profile for each cuisine by displaying the top four ingredients in each cuisine.

```py
for(nation in by_cuisine_norm$cuisine){
    x <- sort(by_cuisine_norm[by_cuisine_norm$cuisine == nation,][-1], decreasing = TRUE)
    cat(c(toupper(nation)))
    cat("\n")
    cat(paste0(names(x)[1:4], " (", round(x[1:4]*100,0), "%) "))
    cat("\n")
    cat("\n")
}
```


At this point, we feel that we have understood the data well and the data is ready and is in the right format for modeling!

-----------

### Thank you for completing this lab!

This notebook was created by [Polong Lin](https://ca.linkedin.com/in/polonglin) and revised by [Alex Aklson](https://www.linkedin.com/in/aklson/). We hope you found this lab session interesting. Feel free to contact us if you have any questions!

This notebook is part of the free course on **Cognitive Class** called *Data Science Methodology*. If you accessed this notebook outside the course, you can take this free self-paced course, online by clicking [here](http://cocl.us/DS0103EN_LAB3_R).

<hr>
Copyright &copy; 2018 [Cognitive Class](https://cognitiveclass.ai/?utm_source=bducopyrightlink&utm_medium=dswb&utm_campaign=bdu). This notebook and its source code are released under the terms of the [MIT License](https://bigdatauniversity.com/mit-license/).