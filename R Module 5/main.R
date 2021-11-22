library(dplyr)

intervals <- c(-2,2,-3,3,-4,4) %>% 
  matrix(ncol = 2,
         byrow = T)

par(mfrow=c(2,3))
for (i in 2:4){
  pnorm <- (pnorm(i) - pnorm(-i)) %>% round(4)
  print(paste(pnorm*100, "%"))
}

qnorm(.2, mean = 0, sd = 1)

qnorm(1 - .67, mean = 0, sd = 1)




z.alpha.2 <- qnorm(.85)



lb <- salary.mean - (z.alpha.2*(15000/sqrt(10)))
ub <- salary.mean + (z.alpha.2*(15000/sqrt(10)))



salary <- c(44617, 7066, 17594, 2726, 1178, 18898, 5033, 37151, 4514, 4000)
salary.mean <- mean(salary)
c.int <- c(.90, .95, .99)
for (i in 1:length(c.int)){
  z.alpha.2 = qnorm(c.int[i])
  lb = salary.mean - (z.alpha.2 * (15000/sqrt(10))) %>% round(0)
  ub = salary.mean + (z.alpha.2 * (15000/sqrt(10))) %>% round(0)
  pcnt <- c.int[i] * 100
  print(paste0("At ",pcnt,"% confidence, the interval is from ",lb," to ",ub))
}

