
library(reshape)
library(psych)
library(robustbase)
library(ggplot2)
library(car)
library(lavaan)

# read in spins soc cog data needed for factor score generation
spins_behav_ea_conn <- read.csv("/projects/loliver/SPINS_PLS_Conn/data/processed/spins_behav_ea_conn_04-29-2021.csv")

# ZHP_0110 and ZHP_0172 did not complete soc cog tasks - exclude these participants
spins_behav_ea_conn <- spins_behav_ea_conn[spins_behav_ea_conn$record_id!="SPN01_ZHP_0110" & spins_behav_ea_conn$record_id!="SPN01_ZHP_0172",]

spins_soc_cog <- spins_behav_ea_conn[,c("record_id","scog_rmet_total","scog_er40_total","mean_ea",
                 "scog_tasit2_simpsar","scog_tasit2_parsar","scog_tasit3_lie","scog_tasit3_sar")]
colnames(spins_soc_cog) <- c("record_id","rmet_total","er40_tot","allvids_origmeanEA","tasit_2_simsar","tasit_2_parsar",
                             "tasit_3_lie","tasit_3_sar")

# check out dists
spins_soc_cog_long <- melt(spins_soc_cog)

ggplot(data = spins_soc_cog_long, mapping = aes(x = value)) + 
  geom_histogram(bins = 10) + facet_wrap(~variable, scales = 'free_x')


# identify adj boxplot outliers for each column of interest - just removing those that performed at ceiling essentially, so skip

outlist <- list()

for (i in colnames(spins_soc_cog[c(2:8)])) {  
  outlist[[i]] <-
    as.vector(spins_soc_cog[(spins_soc_cog[[i]] %in% (adjboxStats(spins_soc_cog[[i]], coef = 1.5, a = -4, b = 3, do.conf = TRUE, do.out = TRUE)$out)),1]) #i
}


# remove outliers with adjusted boxplot criteria - can decide whether or not to do this

#spins_soc_cog_out <- spins_soc_cog

#for (i in names(outlist)) {
#  spins_soc_cog_out[spins_soc_cog_out$record_id %in% outlist[[i]], i] <- NA
#}


# Power transform variables to normalize distributions
# yeo johnson family transformation - can handle negative values (EA) - box-cox cannot

get_pT_yj <- function(x) {
  pT <- x^powerTransform(x,family="yjPower")$lambda
  return(pT)
}

# done for all variables other than demographic variables
spins_soc_cog_yj <- data.frame(apply(spins_soc_cog[,c(2:8)],2,get_pT_yj))
spins_soc_cog_yj <- cbind(spins_soc_cog$record_id,spins_soc_cog_yj)
colnames(spins_soc_cog_yj)[1] <- "record_id"

# check out dists
spins_soc_cog_yj_long <- melt(spins_soc_cog_yj)

ggplot(data = spins_soc_cog_yj_long, mapping = aes(x = value)) + 
  geom_histogram(bins = 10) + facet_wrap(~variable, scales = 'free_x')

# write.csv(spins_soc_cog_yj, file="/projects/loliver/.csv", row.names = F)


spins_soc_cog_yj_z <- apply(spins_soc_cog_yj[,2:8],2, as.numeric)

# z score
spins_soc_cog_yj_z <- data.frame(apply(spins_soc_cog_yj_z,2, scale, center = TRUE, scale = TRUE))
spins_soc_cog_yj_z$record_id <- spins_soc_cog_yj$record_id

# run old models for use in factor score generation for new sample
# must do this as you will apply the model to the 'new' data to get the scores
spins_behav_out_FA_pT <- read.csv(file="/projects/loliver/SPINS_Documentation/spins_behav_out_FA_pT_yj_2017-12-04.csv")

spins_behav_out_FA_pT_z <- apply(spins_behav_out_FA_pT,2, as.numeric)

spins_behav_out_FA_pT_z <- data.frame(apply(spins_behav_out_FA_pT_z,2, scale, center = TRUE, scale = TRUE))


# model with power transformed then standardized variables - without TASIT 1
# soc cog correlated 2 factor model - including all potential task-based soc cog measures we have (other than RAD/Managing Emo, TASIT 1)

soccog_CFA_model1 <- 'simulation =~ er40_tot + rmet_total + allvids_origmeanEA + tasit_3_lie
mentalizing =~ tasit_2_simsar + tasit_2_parsar + tasit_3_sar '

soccog_CFA_model1_fit <- cfa(soccog_CFA_model1, data = spins_behav_out_FA_pT_z, std.lv=TRUE,estimator = "MLR", missing = "ml")

summary(soccog_CFA_model1_fit, fit.measures = TRUE, modindices = TRUE, standardized=TRUE, rsquare=TRUE)

# predict factor scores for new data based on 2 factor model
conn_factor_scores <- data.frame(predict(soccog_CFA_model1_fit, newdata = spins_soc_cog_yj_z))

conn_factor_scores$record_id <- spins_soc_cog_yj$record_id
conn_factor_scores$diagnostic_group <- spins_behav_ea_conn$diagnostic_group
conn_factor_scores <- conn_factor_scores[,c(3,4,1:2)]


# soc cog 1 factor model -  can also get scores for this if wanted - skipped for now

soccog_CFA_model4 <- 'soccog =~ er40_tot + rmet_total + allvids_origmeanEA + tasit_3_lie + tasit_2_simsar + tasit_2_parsar + tasit_3_sar'

soccog_CFA_model4_fit <- cfa(soccog_CFA_model4, data = spins_behav_out_FA_pT_z, std.lv = TRUE, estimator = "MLR", missing = "ml")

summary(soccog_CFA_model4_fit, fit.measures = TRUE, modindices = TRUE, standardized=TRUE, rsquare=TRUE)

# predict factor scores for conn data for 1 factor model
conn_factor_scores$soccog1fac <- predict(soccog_CFA_model4_fit, newdata = spins_soc_cog_yj_z)


# list factor score outliers - just to have a look
outlist <- list()

for (i in colnames(conn_factor_scores[3:4])) {  
  outlist[[i]] <-
    as.vector(conn_factor_scores[(conn_factor_scores[[i]] %in% (adjboxStats(conn_factor_scores[[i]], coef = 1.5, a = -4, b = 3, do.conf = TRUE, do.out = TRUE)$out)),1])
}

# remove outliers with adjusted boxplot criteria - skipped but your choice

#conn_factor_scores_out <- data.frame(spins_behav_conn_out_yj$record_id)
#colnames(conn_factor_scores_out) <- "record_id"

#for (i in names(outlist)) {  
#  conn_factor_scores_out[[i]] <- conn_factor_scores[[i]]
#  conn_factor_scores_out[conn_factor_scores_out$record_id %in% outlist[[i]], i] <- NA
#}

write.csv(conn_factor_scores, file="/projects/loliver/SPINS_PLS_Conn/data/processed/soc_cog_factor_scores_05-06-2021.csv", row.names=F)


