
library(matrixStats)
library(reshape2)
library(ggplot2)
library(patchwork)
library(matconv)
library(raveio)
library(rmatio)
library(pracma)
library(fBasics)
library(MonteCarlo)
library(patchwork)
library(EnvStats)
library(gmodels)
library(boot)
library(ggformula)
library(mgcv)
library(bigsplines)
library(patchwork)
library(grid)
library(ggmap)
library(patchwork)
library(zoo)
library(dplyr)
library(wesanderson)
library(tibble)
library(dplyr)


wd <- "~/Dropbox/EC/human_niche_fig6"
setwd(wd)

exposure <- read.csv("hotexposure_27C.csv")
emissions2 <- read.csv("2018_emmissions_per_capita_percentage.csv")
emissions <- read.csv("emissions_country.csv")
emissions_con <- read.csv("emissions_world_eu.csv")


mat29 <- read.mat("mat29.mat")
mat29 <- as.data.frame(mat29)

poverty2 <- read.csv("povertydat.csv")

poverty2 <- data.frame(country=poverty2$country,
                       pov=poverty2$pov)
poverty2$pov[poverty2$pov==-Inf] <- NA
poverty2$pov <- as.numeric(poverty2$pov)

df <- merge(exposure,emissions,by="country",all=FALSE)

df3 <- merge(df,poverty2,by="country",all=FALSE)

df3 <- data.frame(country=df3$country,
                  pov = df3$pov)
df <- merge(df,df3,by="country",all=TRUE)

colnames(df) <- c("country",
                  "X9b",
                  "X11b",
                  "emissions",
                  #"X2020.co2.only",
                  "pov")

mid <- median(df$X11b[df$X11b!=0])

mid_em <- median(df$emissions[df$emissions!=0])


p <- ggplot(df,aes(x=(emissions), y=(X9b))) +
  geom_point(color="red") +
  ylab("Exposed population (millions of people)") +
  xlab("Emissions per capita (CO2eq / cap)") +
  theme_bw()
p


mid <- log10(median(df$X11b[df$X11b!=0]+1))
mid_em <- log10(median(df$emissions[df$emissions!=0]))

df2 <- df

dat <- data.frame(X9b=log10(df2$X9b+1),emissions=log10(df2$emissions))


dat2 <- data.frame(X9b=(df2$X9b),emissions=(df2$emissions))
dat2 <- scale(dat2)


exposure_quants <- data.frame(x=quantile(dat$X9b,probs = c(0.25,0.5,0.75)))
emissions_quants <- data.frame(x=quantile(dat$emissions,probs = c(0.25,0.5,0.75)))

mydata <- dat
mydata$poverty <- df$pov

pov_quant <- quantile((mydata$poverty),probs = c(0.25,0.5,0.75),na.rm=TRUE)
mydata$poverty_bin <- mydata$poverty
mydata$poverty_bin[mydata$poverty>pov_quant[1]] <- 1
mydata$poverty_bin[mydata$poverty<=pov_quant[1]] <- 4
mydata$poverty_bin[mydata$poverty>=pov_quant[1]] <- 3
mydata$poverty_bin[mydata$poverty>=pov_quant[2]] <- 2
mydata$poverty_bin[mydata$poverty>=pov_quant[3]] <- 1
mydata$poverty_bin <- as.factor(mydata$poverty_bin)

pal <- c("#D55E00", "#E69F00","#0072B2","#009E73")


p1 <- ggplot(mydata,aes(x=emissions, y=X9b, color=poverty_bin)) +
  geom_point(aes(color=poverty_bin)) +
  scale_color_manual(values=pal,
                     labels=c("75%-100%",
                              "50%-75%",
                              "25%-50%",
                              "0%-50%",
                              "No data")) + 
  geom_vline(data=emissions_quants,aes(xintercept=(x)),linetype=c("dashed","solid","dashed")) +
  geom_hline(data=exposure_quants,aes(yintercept=(x)),linetype=c("dashed","solid","dashed")) +
  ylab("Exposed population (millions of people)") +
  xlab("Emissions per capita (tCeq/cap/yr)") +
  labs(colour="Poverty rate quartile") +
  scale_y_continuous(breaks = c(log10(1e+01),log10(1e+02),log10(1e+03),log10(1e+04),log10(1e+05),log10(1e+06),log10(1e+07),log10(1e+08),log10(1e+09)),
                     labels = c((1e+01/1000000),(1e+02/1000000),(1e+03/1000000),(1e+04/1000000),(1e+05/1000000),(1e+06/1000000),(1e+07/1000000),(1e+08/1000000),(1e+09/1000000))) +
  scale_x_continuous(breaks = c(log10(0.07333333),log10(0.7333333),log10(7.333333),log10(73.333333)),
                     labels = c(0.02,0.2,2,20)) +
  coord_cartesian(ylim = c(-0.1,9), xlim = c(-0.5,2)) +
  theme_bw()
p1

label_dat <- mydata
label_dat$country <- df$country
label_dat <- rbind(subset(label_dat,country=="India"),
                   subset(label_dat,country=="United States"),
                   subset(label_dat,country=="Qatar"),
                   subset(label_dat,country=="Nigeria"),
                   subset(label_dat,country=="Rwanda"))
label_dat$emissions_label <- label_dat$emissions
label_dat$X9b_label <- label_dat$X9b
label_dat$emissions_label[label_dat$country=="India"] <- label_dat$emissions_label[label_dat$country=="India"] + 0.14
label_dat$emissions_label[label_dat$country=="United States"] <- label_dat$emissions_label[label_dat$country=="United States"] + 0.35
label_dat$X9b_label[label_dat$country=="India"] <- label_dat$X9b_label[label_dat$country=="India"] + 0.5
label_dat$X9b_label[label_dat$country=="United States"] <- label_dat$X9b_label[label_dat$country=="United States"] - 0.6
label_dat$emissions_label[label_dat$country=="Qatar"] <- label_dat$emissions_label[label_dat$country=="Qatar"] + 0.15
label_dat$emissions_label[label_dat$country=="Nigeria"] <- label_dat$emissions_label[label_dat$country=="Nigeria"] - 0.3
label_dat$X9b_label[label_dat$country=="Qatar"] <- label_dat$X9b_label[label_dat$country=="Qatar"] + 0.6
label_dat$X9b_label[label_dat$country=="Nigeria"] <- label_dat$X9b_label[label_dat$country=="Nigeria"] + 0.6
label_dat$emissions_label[label_dat$country=="Rwanda"] <- label_dat$emissions_label[label_dat$country=="Rwanda"] + 0.3
label_dat$X9b_label[label_dat$country=="Rwanda"] <- label_dat$X9b_label[label_dat$country=="Rwanda"] + 0.8

emissions_con$y <- 0
emissions_con <- subset(emissions_con,Country=="EU27")
emissions_con$poverty <- NA
emissions_con$poverty_bin <- NA

add_eu <- data.frame("X9b" = 0,
                     "emissions" = log10(emissions_con$X2018+1),
                     "poverty" = NA,
                     "poverty_bin" = NA,
                     "country" = "EU",
                     "emissions_label" = log10(emissions_con$X2018+1)+0.2,
                     "X9b_label" = 0+0.7)

p <- p1 + geom_point(data=emissions_con,aes(x=log10(X2018+1),y=y),size=3)
p

label_dat <- rbind(label_dat,add_eu)
arrows <-
  tibble(
    x1 = c(0.55, 0.13, 2.0, 1.4),
    x2 = c(0.47, 0.3, 1.86, 1.29),
    y1 = c(9.15, 9.1, 6.85, 2.3),
    y2 = c(8.8, 8.65, 6.45, 2.70)
  )
arrows2 <-
  tibble(
    x1 = c(-0.12,1.13),
    x2 = c(-0.26,1),
    y1 = c(0.8,0.7),
    y2 = c(0.15,0.15)
  )
g_text <-
  p +
  geom_point(data=label_dat,aes(x=emissions, y=X9b), 
             size=3) +
  geom_text(data=label_dat,aes(x=emissions_label, y=X9b_label,label=country),
            color="black") +
  geom_curve(
    data = arrows, 
    aes(x = x1, y = y1, xend = x2, yend = y2),
    arrow = arrow(length = unit(0.07, "inch")), size = 0.6,
    color = c("#E69F00","#D55E00","grey50","#0072B2"), 
    curvature = -0.3
  ) +
  geom_curve(
    data = arrows2, 
    aes(x = x1, y = y1, xend = x2, yend = y2),
    arrow = arrow(length = unit(0.07, "inch")), size = 0.6,
    color = c("#D55E00","grey50"), 
    curvature = 0.3
  )


g_text

mydata$pov_half <- mydata$poverty_bin

mydata2 <- mydata[complete.cases(mydata),]

p_hist <- ggplot(mydata2,aes(x=emissions, fill=pov_half)) +
  geom_density(color=NA,alpha=0.5) +
  coord_cartesian(xlim = c(-0.5,2)) +
  scale_x_continuous(breaks = c(log10(0.07333333),log10(0.7333333),log10(7.333333),log10(73.333333)),
                     labels = c(0.02,0.2,2,20)) +
  theme_minimal() +
  xlab("Emissions per capita (tCeq/cap/yr)") +
  theme(axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position="none",
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank())

p_hist


p2 <- g_text + theme(legend.position="bottom",
                     panel.grid.minor = element_blank())

p_out <- p2 + theme(legend.position="bottom",
                   panel.grid.minor = element_blank(),
                   axis.title.x = element_blank()) +
  p_hist + scale_fill_manual(values=pal,
                              labels=c("75%-100%",
                                       "50%-75%",
                                       "25%-50%",
                                       "0%-50%")) + 
  plot_layout(ncol=1, nrow=2, guides='collect', heights=c(8,0.5)) & theme(legend.position = 'bottom') 


p_out


ggsave(filename = "Figure6.png",
       plot = p_out,
       height = 6.3,
       width = 6.3,
       dpi = 600)

  




