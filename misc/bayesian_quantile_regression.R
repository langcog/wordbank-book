ews <- admins %>%
  filter(language == "English (American)",
         form == "WS")

library(brms)

mod <- brm(bf(production ~ s(age), quantile = .5),
           data = ews,
           family = asym_laplace())

fitted <- fitted(mod, dpar="mu")

ews$fitted <- fitted[,"Estimate"]
ews$fitted.25 <- fitted[,"Q2.5"]
ews$fitted.975 <- fitted[,"Q97.5"]

ggplot(ews,
       aes(x = age, y = production)) +
  geom_jitter(width = .2) +
  geom_ribbon(aes(ymin = fitted.25, ymax = fitted.975), alpha = .3) +
  geom_line(aes(y = fitted))


