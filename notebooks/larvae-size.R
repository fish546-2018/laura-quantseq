larvae.size <- read.csv("data/2019-08_new-larvae-measurements.csv", header=T, stringsAsFactors = F)
larvae.size[c("Sample", "Population", "Temperature", "pH")] <- lapply(larvae.size[c("Sample", "Population", "Temperature", "pH")], factor)
larvae.size$DateCollected <- as.Date(larvae.size$DateCollected, format = "%m/%d/%y")

library(ggplot2)
library(dplyr)
library(car)

hist(larvae.size$MaxFeret, breaks = 100)
summary(larvae.size[c(13:17)]) 
aggregate(MaxFeret ~ Temperature+pH, larvae.size, mean)[3]*1.4
aggregate(MinFeret ~ Temperature+pH, larvae.size, mean)[3]*1.4

# Correct size data - scope was not calibrated accurately. Based on measurements of 12 known lengths, multiply lengths by 1.405669
 
larvae.size$MaxFeret.cor <- larvae.size$MaxFeret*1.405669 
larvae.size$MinFeret.cor <- larvae.size$MinFeret*1.405669 


larvae.size %>%
          group_by(Temperature, pH) %>%
          summarise(count= n_distinct(Sample))


# How many samples do I have per pop+pH+temp
print(larvae.size %>%
          group_by(Population, Temperature, pH) %>%
          summarise(count= n_distinct(Sample)))

png("plots/larval-max-min-all.png")
print(max.min.all <- ggplot(subset(larvae.size, MinFeret.cor>80), aes(x=MinFeret, y=MaxFeret)) + geom_point(size=.5, aes(color=Temperature:pH)) + theme_bw(base_size = 12) + labs(title="Larval shell size upon release", y=("Max Feret Diameter (~width), (um)"), x="Min Feret Diameter (~height),") + theme(text = element_text(size = 14))) + scale_color_manual(values=c("blue", "forestgreen", "orange", "red"))
dev.off()

png("plots/larval-max-feret-all.png")
print(max.all <- ggplot(larvae.size, aes(x=Population, y=MaxFeret)) + geom_boxplot(aes(color=Temperature:pH)) + theme_bw(base_size = 12) + labs(title="Larval shell width (Max Feret) by cohort & treatment", y=("Max. Feret Diameter (um)"), x="Cohort") + theme(text = element_text(size = 14))) + scale_color_manual(values=c("blue", "forestgreen", "orange", "red"))
dev.off()

png("plots/larval-min-feret-all.png")
print(min.all <- ggplot(larvae.size, aes(x=Population, y=MinFeret)) + geom_boxplot(aes(color=Temperature:pH)) + theme_bw(base_size = 12) + labs(title="Larval shell height (Min Feret) by cohort & treatment", y=("Min. Feret Diameter (um)"), x="Cohort") + theme(text = element_text(size = 14))) + scale_color_manual(values=c("blue", "forestgreen", "orange", "red"))
dev.off()

# Calcuate mean height and width for each sample for statistical analysis  
larvae.size.mean <- larvae.size %>%
          group_by(Population, Temperature, pH, Sample) %>%
          summarise(MaxFeret.mean=mean(MaxFeret.cor), MinFeret.mean=mean(MinFeret.cor), date=median(DateCollected))

# Explore   

print(min.mean <- ggplot(larvae.size.mean, aes(x=Temperature:pH, y=MaxFeret.mean)) + geom_boxplot() + geom_jitter(width=0.15, size=2, aes(color=Population)) + theme_bw(base_size = 14) + labs(title="Mean shell width, by treatment & cohort", y=("size (um)"), x="Treatment") + theme(text = element_text(size = 16)) + scale_color_manual(values=c("#4daf4a","#377eb8","#984ea3","#e41a1c")))

print(max.mean <- ggplot(larvae.size.mean, aes(x=Temperature:pH, y=MinFeret.mean)) + geom_boxplot() + geom_jitter(width=0.15, size=2, aes(color=Population)) + theme_bw(base_size = 14) + labs(title="Mean shell height, by treatment & cohort", y=("size (um)"), x="Treatment") + theme(text = element_text(size = 16))) + scale_color_manual(values=c("#4daf4a","#377eb8","#984ea3","#e41a1c"))

print(max.mean.cohort <- ggplot(larvae.size.mean, aes(x=Population, y=MaxFeret.mean, color=Temperature:pH)) + geom_point(shape=8, size=2, position = position_jitterdodge(jitter.width = 0.35)) + geom_boxplot() + theme_bw(base_size = 14) + labs(title="Mean shell width, by treatment & cohort", y=("size (um)"), x="Cohort") + theme(text = element_text(size = 16)) + scale_color_manual(values=c("blue", "forestgreen", "orange", "red")))

print(max.mean.date <- ggplot(larvae.size.mean, aes(x=date, y=MaxFeret.mean)) + geom_jitter(width=0.15, size=2, aes(color=Temperature:pH)) + theme_bw(base_size = 14) + labs(title="Mean shell width, by collection date and treatment", y=("size (um)"), x="Date collected") + theme(text = element_text(size = 16)) + scale_color_manual(values=c("blue", "forestgreen", "orange", "red")))


png("plots/larval-max-feret-mean.png")
min.mean
dev.off()

png("plots/larval-min-feret-mean.png")
max.mean
dev.off()

png("plots/larval-max-feret-mean-cohort.png")
max.mean.cohort
dev.off()

png("plots/larval-max-feret-mean-date.png")
max.mean.date
dev.off()

# Test sign. diff among temp, pH treats 
# NOTE: unbalanced design, so need to use either Type II or Type III SS.
# See https://www.r-bloggers.com/anova-%E2%80%93-type-iiiiii-ss-explained/

# Max. Feret Diameter (best estimate for larval width)
hist(larvae.size.mean$MaxFeret.mean)
shapiro.test(larvae.size.mean$MaxFeret.mean)
bartlett.test(MaxFeret.mean ~ pH, data=larvae.size.mean)
bartlett.test(MaxFeret.mean ~ Temperature, data=larvae.size.mean)

anova(lm(MaxFeret.mean ~ Temperature + pH + Temperature:pH, data=larvae.size.mean)) #no interaction. Assess using type II sums of squares, where I look at effects of pH and temperature after controlling for the other factor 
Anova(lm(MaxFeret.mean ~ Temperature*pH, data=larvae.size.mean), type=2) #both sign. 
summary(lm(MaxFeret.mean ~ Temperature+pH, data=larvae.size.mean)) # Fit not great, though 

# Try mixed effect model, with Population as random effect
library(arm)
display(lmer(MaxFeret.mean ~ Temperature*pH + (1|Population), data=larvae.size.mean))
Anova(lmer(MaxFeret.mean ~ Temperature*pH + (1|Population), data=larvae.size.mean), type=2)

display(lmer(MaxFeret.mean ~ Temperature+pH+ (1|Population), data=larvae.size.mean)) 
Anova(lmer(MaxFeret.mean ~ Temperature+pH + (1|Population), data=larvae.size.mean), type=2) #with Pop as random effect and using type II SS, still sign. influence of temp and pH 

# Min. Feret Diameter (best estimate for larval height)
hist(larvae.size.mean$MinFeret.mean)
shapiro.test(larvae.size.mean$MinFeret.mean)
bartlett.test(MinFeret.mean ~ pH, data=larvae.size.mean)
bartlett.test(MinFeret.mean ~ Temperature, data=larvae.size.mean)
anova(lm(MinFeret.mean ~ Temperature + pH + Temperature:pH, data=larvae.size.mean)) #no interaction. Assess using type II sums of squares, where I look at effects of pH and temperature after controlling for the other factor 
Anova(lm(MinFeret.mean ~ Temperature*pH, data=larvae.size.mean), type=2) #both sign. 
summary(lm(MinFeret.mean ~ Temperature+pH, data=larvae.size.mean)) # Fit not great, though 

# Try mixed effect model, with Population as random effect
display(lmer(MinFeret.mean ~ Temperature*pH + (1|Population), data=larvae.size.mean))
Anova(lmer(MinFeret.mean ~ Temperature*pH + (1|Population), data=larvae.size.mean), type=2)
display(lmer(MinFeret.mean ~ Temperature+pH+ (1|Population), data=larvae.size.mean)) 
Anova(lmer(MinFeret.mean ~ Temperature+pH + (1|Population), data=larvae.size.mean), type=2) #with Pop as random effect and using type II SS, still sign. influence of temp and pH 

# Test sign. diff among cohorts only 
summary(aov(MinFeret.mean ~ Population, data=larvae.size.mean)) #no 
summary(aov(MaxFeret.mean ~ Population, data=larvae.size.mean)) #no 

# Check out larval sizes for samples I already sequenced last year - size difference? 
quant2018 <-  as.factor(c(41, 26, 32, 10, 48, 77))
quant2018 <- larvae.size[larvae.size$Sample %in% quant2018,]
hist(quant2018$MaxFeret)
shapiro.test(log(quant2018$MaxFeret))
ggplot(quant2018, aes(x=Temperature:pH, y=MaxFeret)) + geom_boxplot() + geom_jitter() + theme_bw(base_size = 14) + labs(title="Larval shell  by treatment", y=("size (um)"), x="Treatment") + theme(text = element_text(size = 16)) 
kruskal.test(quant2018$MaxFeret, g = quant2018$pH) #sign. different - 10-low larger.  
