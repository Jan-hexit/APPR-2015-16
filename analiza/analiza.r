# 4. faza: Analiza podatkov
source("lib/libraries.r", encoding = "UTF-8")
profit<-data.frame(profit)
graf<-lm(data = profit, Electronic.Gaming ~ American.Roulette + I(American.Roulette^2))
g <- ggplot(profit, aes(x=profit$Electronic.Gaming, y=profit$American.Roulette)) + geom_point()
g <- g + geom_smooth(method = "lm", formula = y ~ x + I(x^2))
print(g)


