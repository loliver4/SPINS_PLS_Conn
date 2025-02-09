### 10-fold cross validation for PLSC ###
### Author: Ju-Chi Yu
### Date: Nov. 30th, 2023
### Modified to use by Lindsay: Sept, 2024
##---------------------------------------

## Reading packages ----
library(TExPosition) # to run PLSC
library(purrr) # used in the kfold function

## Read needed functions ----
source("/projects/loliver/SPINS_PLS_Conn/notebooks/ProjectSupplementaryData4PLS.R")
source("/projects/loliver/SPINS_PLS_Conn/notebooks/PLS.kFoldCV.R")

## Read in data for EA PLSC ----
data1 <- conn
data2 <- beh
pls.res <- rs_plsc

## Run PLSC ----
#pls.res <- tepPLS(data1,data2, graphs = FALSE)

## Perform 10-fold validation (after running PLSC in RS script)
pls.cv <- PLS.kFoldCV(data1, data2, pls.res, k = 10)

## plot
plot(pls.res$TExPosition.Data$lx[,1], pls.cv$cross.validation.res$lx.hat[,1])
plot(pls.res$TExPosition.Data$ly[,1], pls.cv$cross.validation.res$ly.hat[,1])

plot(pls.res$TExPosition.Data$lx[,2], pls.cv$cross.validation.res$lx.hat[,2])
plot(pls.res$TExPosition.Data$ly[,2], pls.cv$cross.validation.res$ly.hat[,2])

# correlations to report (check latent variables)
pls.cv$cross.validation.res$lxly.cor

library(tidyr)
library(dplyr)

# Dim 1
cor.test(pls.res$TExPosition.Data$lx[,1], pls.cv$cross.validation.res$lx.hat[,1])
cor.test(pls.res$TExPosition.Data$ly[,1], pls.cv$cross.validation.res$ly.hat[,1])

## check loadings for conn on Dim 1
cv.p <- lapply(pls.cv$cross.validation.res$p, function(x) x[,1]) %>% simplify2array()
cv.p.long <- pivot_longer(data.frame(variable = rownames(cv.p), cv.p), 
                          cols = starts_with("Fold"),
                          names_to = "Fold",
                          names_prefix = "Fold",
                          values_to = "value")

### get means and sds of loadings across the 10 folds
cv.p.summary <- cv.p.long %>% group_by(variable) %>%
  summarize(value = list(value)) %>%
  group_by(variable) %>%
  mutate(mean = mean(unlist(value)),
         sd = sd(unlist(value)))

### compute correlation between the original loadings and the mean of estimated loadings from the 10 folds
p.cor2fold <- lapply(pls.cv$cross.validation.res$p, function(x) cor(x[,1],pls.res$TExPosition.Data$pdq$p[rownames(x),1])) %>% simplify2array()

range(p.cor2fold)
mean(p.cor2fold)
sd(p.cor2fold)

## check loadings for beh on Dim 1
cv.q <- lapply(pls.cv$cross.validation.res$q, function(x) x[,1]) %>% simplify2array()
cv.q.long <- pivot_longer(data.frame(variable = rownames(cv.q), cv.q), 
                          cols = starts_with("Fold"),
                          names_to = "Fold",
                          names_prefix = "Fold",
                          values_to = "value")

### get means and sds of loadings across the 10 folds
cv.q.summary <- cv.q.long %>% group_by(variable) %>%
  summarize(value = list(value)) %>%
  group_by(variable) %>%
  mutate(mean = mean(unlist(value)),
         sd = sd(unlist(value)))

### compute correlation between the original loadings and the mean of estimated loadings from the 10 folds
q.cor2fold <- lapply(pls.cv$cross.validation.res$q, function(x) cor(x[,1],pls.res$TExPosition.Data$pdq$q[rownames(x),1])) %>% simplify2array()

range(q.cor2fold)
mean(q.cor2fold)
sd(q.cor2fold)

## check explained variance
cv.t <- lapply(pls.cv$cross.validation.res$eig, function(x) x[1]/sum(x)) %>% simplify2array
range(cv.t)
sd(cv.t)
mean(cv.t)

