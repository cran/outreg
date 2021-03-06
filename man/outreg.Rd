% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/outreg.R
\name{outreg}
\alias{outreg}
\title{Generate Regression Table}
\usage{
outreg(fitlist, digits = 3L, alpha = c(0.1, 0.05, 0.01),
  bracket = c("se"), starred = c("coef"), robust = FALSE, small = TRUE,
  constlast = FALSE, norepeat = TRUE, displayed = list(), ...)
}
\arguments{
\item{fitlist}{list of regression outcomes}

\item{digits}{number of dicimal places for real numbers}

\item{alpha}{vector of significance levels to star}

\item{bracket}{stats to be in brackets}

\item{starred}{stats to put stars on}

\item{robust}{if TRUE, robust standard error is used}

\item{small}{if TRUE, small sample parameter distribution is used}

\item{constlast}{if TRUE, intercept is moved to the end of
coefficient list}

\item{norepeat}{if TRUE, repeated variable names are replaced by a empty string}

\item{displayed}{a list of named logicals to customize the stats to display}

\item{...}{alternative way to specify which stats to display}
}
\value{
regression table in \code{data.frame} format
}
\description{
Generate a regression table in \code{data.frame}
format from a set of model fit objects.
Currently supports \code{lm}, \code{glm}, \code{survreg}, and \code{ivreg}
model outcomes.
}
\details{
Use \code{\link{outreg_stat_list}} to see the available stats
names.  The stats names are to be used for specifying
\code{bracket}, \code{starred}, and \code{displayed} options.

Statistics to include can be chosen by \code{displayed} option or
by \code{`...`}.
For example, \code{outreg(fitlist, displayed = list(pv = TRUE))} is
identical with \code{outreg(fitlist pv = TRUE)}, and
p values of coefficients are displayed.
}
\examples{
fitlist <- list(lm(mpg ~ cyl, data = mtcars),
                lm(mpg ~ cyl + wt + hp, data = mtcars),
                lm(mpg ~ cyl + wt + hp + drat, data = mtcars))
outreg(fitlist)

# with custom regression names
outreg(setNames(fitlist, c('small', 'medium', 'large')))

# star on standard errors, instead of estimate
outreg(fitlist, starred = 'se')

# include other stats
outreg(fitlist, pv = TRUE, tv = TRUE, se = FALSE)


# poisson regression
counts <- c(18,17,15,20,10,20,25,13,12)
outcome <- gl(3,1,9)
treatment <- gl(3,3)
fitlist2 <- list(glm(counts ~ outcome, family = poisson()),
                 glm(counts ~ outcome + treatment, family = poisson()))
outreg(fitlist2)


# logistic regression
fitlist3 <- list(glm(cbind(ncases, ncontrols) ~ agegp,
                     data = esoph, family = binomial()),
                 glm(cbind(ncases, ncontrols) ~ agegp + tobgp + alcgp,
                     data = esoph, family = binomial()),
                 glm(cbind(ncases, ncontrols) ~ agegp + tobgp * alcgp,
                     data = esoph, family = binomial()))
outreg(fitlist3)


# survival regression
library(survival)
fitlist4 <- list(survreg(Surv(time, status) ~ ph.ecog + age,
                         data = lung),
                 survreg(Surv(time, status) ~ ph.ecog + age + strata(sex),
                         data = lung))
outreg(fitlist4)


# tobit regression
fitlist5 <- list(survreg(Surv(durable, durable>0, type='left') ~ 1,
                 data=tobin, dist='gaussian'),
                 survreg(Surv(durable, durable>0, type='left') ~ age + quant,
                 data=tobin, dist='gaussian'))
outreg(fitlist5)


# instrumental variable regression
library(AER)
data("CigarettesSW", package = "AER")
CigarettesSW$rprice <- with(CigarettesSW, price/cpi)
CigarettesSW$rincome <- with(CigarettesSW, income/population/cpi)
CigarettesSW$tdiff <- with(CigarettesSW, (taxs - tax)/cpi)

fitlist6 <- list(OLS = lm(log(packs) ~ log(rprice) + log(rincome),
                          data = CigarettesSW, subset = year == "1995"),
                 IV1 = ivreg(log(packs) ~ log(rprice) + log(rincome) |
                             log(rincome) + tdiff + I(tax/cpi),
                             data = CigarettesSW, subset = year == "1995"),
                 IV2 = ivreg(log(packs) ~ log(rprice) + log(rincome) |
                             log(population) + tdiff + I(tax/cpi),
                             data = CigarettesSW, subset = year == "1995"))
outreg(fitlist6)

}

