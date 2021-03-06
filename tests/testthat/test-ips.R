context("ips.R unit tests")
library("data.table")
library("Rcpp")
nbt.ind <- which(iviRA::treatments$sname == "nbt")

# sim_iviRA --------------------------------------------------------------------
set.seed(101)
haq0 <- formals(sample_pop)$haq0_mean
das28.0 <- formals(sample_pop)$das28_mean
sdai.0 <- formals(sample_pop)$sdai_mean
cdai.0 <- formals(sample_pop)$cdai_mean
pop <- sample_pop(n = 30, type = "homog", haq0_mean = haq0,
                  das28_mean = das28.0, sdai_mean = sdai.0, 
                  cdai_mean = cdai.0)
tx.seq <- c("etnmtx", "cdmards")
input.dat <- get_input_data(pop = pop)
parsamp <- sample_pars(n = 30, input_dat = input.dat)

# Structures with length > 1
test_that("model structures with length > 1 ", {
  mod.structs <- select_model_structures(tx_ihaq = c("acr-haq", "acr-eular-haq"),
                                         tx_iswitch = c("acr-switch", "acr-eular-switch"),
                                         cdmards_haq_model = c("lcgm", "linear"),
                                         ttd_cause = c("all", "all"),
                                         ttd_dist = c("gengamma", "exponential"))
  sim.out <- sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                       model_structures = mod.structs, output = "data")
  expect_equal(length(unique(sim.out$model)), 2)
  expect_true(all(is.na(sim.out[model == 1, eular])))
  expect_true(all(sim.out[model == 2, eular] %in% seq(0, 2)))
})

# Stucture = tx_ihaq = "acr-haq", tx_iswitch = "acr-switch"
mod.structs <- select_model_structures(tx_ihaq = "acr-haq",
                                     tx_iswitch = "acr-switch")
sim.out <- sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                     model_structures = mod.structs, output = "data")
sim.out[, dhaq := ifelse(month == 6, haq - haq0,
                         haq - shift(haq)), by = c("model", "sim", "id")]

test_that("sim_iviRA ACR to HAQ ", {
  tmp.sim <- 1
  x <- sim.out[model == 1 & sim == tmp.sim & tx_cycle == 1 & tx != nbt.ind & si !=1, 
                .(id, tx, line, acr, haq, dhaq)]
  expect_equal(unique(x[acr == 0, dhaq]), 0) # acr = 0 implies dhaq = 0 because acr-switch implies switch/rebound
  expect_equal(unique(x[acr == 1, round(dhaq, 4)]), 
               as.numeric(round(parsamp$acr2haq[tmp.sim, 2], 4)))
  expect_equal(unique(x[acr == 2, round(dhaq, 4)]), 
               as.numeric(round(parsamp$acr2haq[tmp.sim, 3], 4)))
  expect_equal(unique(x[acr == 3, round(dhaq, 4)]), 
               as.numeric(round(parsamp$acr2haq[tmp.sim, 4], 4)))
})

test_that("sim_iviRA EULAR, DAS28, SDAI, and CDAI should be NA if acr-haq is chosen",{
  expect_equal(is.na(unique(sim.out$eular)), TRUE)
  expect_equal(is.na(unique(sim.out$das28)), TRUE)
  expect_equal(is.na(unique(sim.out$sdai)), TRUE)
  expect_equal(is.na(unique(sim.out$cdai)), TRUE)
})

test_that("sim_iviRA no ACR response if nbt",{
  expect_equal(unique(sim.out[tx == nbt.ind, acr]), 0)
})

# Stucture = tx_ihaq = "acr-haq", tx_iswitch = "acr-das28" | "acr-sdai" | "acr-cdai"
sim_da <- function(da_name = c("das28", "sdai", "cdai"), da0){
  da.name <- match.arg(da_name)
  if (da.name == "das28"){
      tx.iswitch <- "acr-das28-switch"
  } else if (da.name == "sdai"){
      tx.iswitch <- "acr-sdai-switch"
  } else if (da.name == "cdai"){
      tx.iswitch <- "acr-cdai-switch"
  }
  mod.structs <- select_model_structures(tx_ihaq = "acr-haq",
                                         tx_iswitch = tx.iswitch)
  sim.out <- sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                       model_structures = mod.structs, output = "data")
  sim.out[, paste0("d", da.name) := ifelse(month == 6, get(da.name) - da0,
                                           get(da.name) - shift(get(da.name))),
          by = c("model", "sim", "id")]
  return(sim.out)
}

expect_acr2da <- function(sim, sim.num, da_name = c("das28", "sdai", "cdai")){
  da.name <- match.arg(da_name)
  dda.name <- paste0("d", da.name)
  if (da.name == "das28"){
    acr2da <- parsamp$acr2das28
  } else if (da.name == "sdai"){
    acr2da <- parsamp$acr2sdai
  } else if (da.name == "cdai"){
    acr2da <- parsamp$acr2cdai
  }
  
  
  # first 6 months
  x <- sim[model == 1 & sim == sim.num & tx_cycle == 1 & si !=1, 
               c("id", "tx", "line", "acr", da.name, dda.name),
               with = FALSE]
  x <- x[get(da.name) > 0] # da measures cannot go below 0
  expect_equal(unique(x[acr == 0, round(get(dda.name), 2)]), 
               as.numeric(round(acr2da[sim.num, 1], 2)))
  expect_equal(unique(x[acr == 1, round(get(dda.name), 2)]), 
               as.numeric(round(acr2da[sim.num, 2],2)))
  expect_equal(unique(x[acr == 2, round(get(dda.name), 2)]), 
               as.numeric(round(acr2da[sim.num, 3], 2)))
  expect_equal(unique(x[acr == 3, round(get(dda.name), 2)]), 
               as.numeric(round(acr2da[sim.num, 4], 2)))
  
  # beyond 6 months
  x <- sim.out[model == 1 & sim == sim.num & tx_cycle > 1 & si !=1, 
               c("id", "tx", "line", "acr", da.name, dda.name),
               with = FALSE]
  expect_equal(unique(x[[dda.name]]), 0)
}

## DAS28
sim.out <- sim_da(da_name = "das28", da0 = das28.0)
test_that("sim_iviRA ACR to DAS28", {
  expect_acr2da(sim = sim.out, sim.num = 3, da_name = "das28")
})
test_that("sim_iviRA SDAI and CDAI should be NA if acr-das28 is chosen",{
  expect_equal(is.na(unique(sim.out$sdai)), TRUE)
  expect_equal(is.na(unique(sim.out$cdai)), TRUE)
})

## SDAI
sim.out <- sim_da(da_name = "sdai", da0 = sdai.0)
test_that("sim_iviRA ACR to SDAI", {
  expect_acr2da(sim = sim.out, sim.num = 3, da_name = "sdai")
})
test_that("sim_iviRA DAS28 and CDAI should be NA if acr-das28 is chosen",{
  expect_equal(is.na(unique(sim.out$das28)), TRUE)
  expect_equal(is.na(unique(sim.out$cdai)), TRUE)
})

## CDAI
sim.out <- sim_da(da_name = "cdai", da0 = cdai.0)
test_that("sim_iviRA ACR to SDAI", {
  expect_acr2da(sim = sim.out, sim.num = 3, da_name = "cdai")
})
test_that("sim_iviRA DAS28 and SDAI should be NA if acr-das28 is chosen",{
  expect_equal(is.na(unique(sim.out$das28)), TRUE)
  expect_equal(is.na(unique(sim.out$sdai)), TRUE)
})

# Stucture = tx_ihaq = "acr-haq", tx_iswitch = "das28-switch"
# assuming constant impact of tx on DAS28 across patients
mod.structs <- select_model_structures(tx_ihaq = "acr-haq",
                                       tx_iswitch = "das28-switch")
sim.out <- sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                     model_structures = mod.structs, output = "data")
sim.out[, ddas28 := ifelse(month == 6, das28 - das28.0,
                         das28 - shift(das28)), by = c("model", "sim", "id")]

test_that("sim_iviRA impact of tx on change in DAS28 at 6 months",{
  sim.num <- 2
  x <- sim.out[model == 1 & sim == sim.num & tx_cycle == 1 & tx != nbt.ind, 
               .(id, tx, line, das28, ddas28)]
  tx.inds <- unique(x$tx)
  ddas28 <- parsamp$das28$A[sim.num] + parsamp$das28$d[sim.num,, tx.inds]
  expect_equal(unique(round(x[tx == tx.inds[1], ddas28], 4)),
               as.numeric(round(ddas28[1], 4)))
  expect_equal(unique(round(x[tx == tx.inds[2], ddas28], 4)),
               as.numeric(round(parsamp$das28$k[sim.num] * ddas28[2], 4)))
})

# Stucture = tx_ihaq = "acr-eular-haq", tx_iswitch = "acr-switch"
mod.structs <- select_model_structures(tx_ihaq = "acr-eular-haq",
                                       tx_iswitch = "acr-switch")
sim.out <- sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                     model_structures = mod.structs, output = "data")
sim.out[, dhaq := ifelse(month == 6, haq - haq0,
                         haq - shift(haq)), by = c("model", "sim", "id")]
sim.out[, N := .N, by = c("model", "sim", "id", "tx")]

test_that("sim_iviRA EULAR to HAQ", {
  sim.num <- 4
  x <- sim.out[model == 1 & sim == sim.num & tx_cycle == 1 & tx != nbt.ind, 
               .(id, tx, line, N, acr, eular, haq, dhaq)]
  expect_equal(unique(x[eular == 0, round(dhaq, 4)]), 
               as.numeric(round(parsamp$eular2haq[sim.num, 1], 4)))
  expect_equal(unique(x[eular == 1 & N > 1, round(dhaq, 4)]), 
               as.numeric(round(parsamp$eular2haq[sim.num, 2], 4)))
  expect_equal(unique(x[eular == 2 & N > 1, round(dhaq, 4)]), 
               as.numeric(round(parsamp$eular2haq[sim.num, 3], 4)))
  expect_equal(unique(x[acr == 0, dhaq]), 0) # acr = 0 implies dhaq = 0 because acr-switch implies switch/rebound
})

test_that("sim_iviRA DAS28, SDAI, and CDAI should be NA if acr-eular-haq is chosen",{
  expect_equal(is.na(unique(sim.out$das28)), TRUE)
  expect_equal(is.na(unique(sim.out$sdai)), TRUE)
  expect_equal(is.na(unique(sim.out$cdai)), TRUE)
})

test_that("sim_iviRA no EULAR response if nbt",{
  expect_equal(unique(sim.out[tx == nbt.ind, eular]), 0)
})

# Structure: tx_ihaq = "haq" with no switching (i.e. das28 = 0) and 
# constant d across patients
pop <- sample_pop(n = 30, type = "homog", das28_mean = 0)
input.dat <- get_input_data(pop = pop)
mod.structs <- select_model_structures(tx_ihaq = "haq",
                                       tx_iswitch = "das28-switch")
parsamp <- sample_pars(n = 30, input_dat = input.dat)
sim.out <- sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                     model_structures = mod.structs,
                     output = "data")
sim.out[, dhaq := ifelse(month == 6, haq - haq0,
                         haq - shift(haq)), by = c("model", "sim", "id")]
sim.out[, N := .N,  by = c("model", "sim", "id", "tx")]


test_that("sim_iviRA direct effect of tx on HAQ", {
  sim.num <- 4
  x <- sim.out[model == 1 & sim == sim.num & tx_cycle == 1 & tx != nbt.ind & N > 1, 
               .(id, tx, line, haq, dhaq)]
  tx.inds <- unique(x$tx)
  dhaq <- parsamp$haq$A[sim.num] + parsamp$haq$d[sim.num, , tx.inds]
  expect_equal(as.numeric(round(dhaq[1], 4)), 
               unique(round(x[tx == tx.inds[1], dhaq], 4)))
  expect_equal(as.numeric(round(parsamp$haq$k[sim.num] * dhaq[2], 4)), 
               unique(round(x[tx == tx.inds[2], dhaq], 4)))
})

# Structure: cdmards_haq_model = "linear"
sim.out <- sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                     model_structures = select_model_structures(cdmards_haq_model = "linear"),
                     output = "data")
sim.out[, dhaq := ifelse(month == 6, haq - haq0,
                         haq - shift(haq)), by = c("model", "sim", "id")]
sim.out[, N := .N, by = c("model", "sim", "id", "tx")]

test_that("sim_iviRA change in maintenance HAQ with linear progression",{
  sim.num <- 4
  x <- sim.out[model == 1 & sim == sim.num & tx_cycle > 1 & 
                 age >= 40 & age < 65 & tx_cycle != N, 
               .(id, tx, line, age, haq, dhaq)]
  tx.inds <- unique(x$tx)
  dhaq.tx <- parsamp$haq.lprog.tx[sim.num, tx.inds]
  dhaq.age <- parsamp$haq.lprog.age[sim.num, 2] 
  expect_equal(unique(round(x[tx == tx.inds[1], dhaq], 4)),
               as.numeric(round((dhaq.tx[1] + dhaq.age[1])/2, 4)))
  expect_equal(unique(round(x[tx == tx.inds[2], dhaq], 4)),
               as.numeric(round((dhaq.tx[2] + dhaq.age[1])/2, 4)))
})

# Stucture: ttd_cause = "all"
sim.out <- sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                     model_structures = select_model_structures(ttd_cause = "all"),
                     output = "data")

## Serious infections
test_that("sim_iviRA serious infections",{
  expect_equal(unique(sim.out[(ttd <= 0 & ttsi < 0) & (ttsi < ttd) , si]), 1)
  expect_equal(unique(sim.out[month == 6 & ttsi < 0 , si]), 1) # SI during first 6 months 
})

# Structure: any
sim.out <- sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                     model_structures = select_model_structures(),
                     output = "data")
## Costs
test_that("sim_iviRA hospital costs", {
  x <- sim.out[model == 1 & sim == 1 & haq >= 1.5 & haq < 2 , 
               .(haq, hosp_days, hosp_cost)][1, ]
  hc <- parsamp$hosp.cost
  hc.days <- ifelse(is.na(x$hosp_days), NA, hc$hosp.days[1, 4])
  hc.cost <- hc.days * ifelse(is.na(x$hosp_cost), NA, hc$cost.pday[1, 4])
  expect_equal(as.numeric(hc.days/2), x$hosp_days)
  expect_equal(as.numeric(hc.cost/2), x$hosp_cost)
})

test_that("sim_iviRA general management costs",{
  sim.num <- 5
  x <- sim.out[model == 1 & sim == sim.num , 
               .(mgmt_cost)][1, ]
  mgmt.cost <- sum(parsamp$mgmt.cost[sim.num, ])
  expect_equal(as.numeric(mgmt.cost/2), x$mgmt_cost)
})

test_that("sim_iviRA productivity losses",{
  sim.num <- 7
  x <- sim.out[model == 1 & sim == sim.num , 
               .(haq, prod_loss)]
  prod.loss <- parsamp$prod.loss[sim.num] * x$haq
  expect_equal(as.numeric(prod.loss/2), x$prod_loss)
})

test_that("sim_iviRA runs when n = 1", {
  tx.seq <- c("etnmtx", "cdmards")
  input.dat <- get_input_data(pop = sample_pop(n = 1))
  parsamp <- sample_pars(n = 1, input_dat = input.dat)
  expect_error(sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                         model_structures = select_model_structures(), output = "data"),
               NA)
})

# Law of large numbers testing
pop <- sample_pop(n = 1000, type = "homog")
tx <- c("etnmtx")
input.dat <- get_input_data(pop = pop)
parsamp <- sample_pars(n = 100, input_dat = input.dat)
mod.structs <- select_model_structures(tx_ihaq = "acr-haq",
                                       tx_iswitch = "acr-switch",
                                       ttd_dist = "weibull")
sim.out <- sim_iviRA(tx_seqs = tx, input_data = input.dat, pars = parsamp,
                     model_structures = mod.structs, max_months = 6,
                     output = "data")

test_that("sim_iviRA law of large numbers: ACR response", {
  sim.acr <- prop.table(table((sim.out$acr)))
  nma.acr <- nma_acrprob(A = iviRA::nma.acr.naive$mean["A"],
                         z2 = iviRA::nma.acr.naive$mean["z2"],
                         z3 = iviRA::nma.acr.naive$mean["z3"],
                         d = iviRA::nma.acr.naive$mean["d_etnmtx"])
  expect_equal(as.numeric(sim.acr),
               as.numeric(nma.acr$non.overlap),
               tolerance = .01)
})

test_that("sim_iviRA law of large numbers: time to treatment discontinuation", {
  sim.ttd.median.yrs <- median(sim.out[ttd > 0, ttd]/2)
  weibull.est <- iviRA::ttd.all$weibull$est
  weibull.sample.yrs <- rweibull(10000, shape = exp(weibull.est["shape"]), 
                             scale = exp(weibull.est["scale"]))/12
  expect_equal(sim.ttd.median.yrs,
              median(weibull.sample.yrs),
              tolerance = .1)
})

test_that("sim_iviRA law of large numbers: time to serious infection", {
  sim.ttsi.mean.yrs <- mean(sim.out$ttsi/2 + .5)
  exponential.mean.yrs <- 1/exp(iviRA::ttsi[sname == tx, lograte])
  expect_equal(sim.ttsi.mean.yrs, exponential.mean.yrs,
               tolerance = .1)
})

# output = "data" vs. output = "summary"
pop <- sample_pop(n = 10, type = "homog")
tx <- c("etnmtx")
input.dat <- get_input_data(pop = pop)
parsamp <- sample_pars(n = 10, input_dat = input.dat)
mod.structs <- select_model_structures()
set.seed(102)
sim1.out <- sim_iviRA(tx_seqs = tx, input_data = input.dat, pars = parsamp,
                      model_structures = mod.structs, max_months = 12,
                      output = "data")
sim1.out <- cbind(sim1.out, 
      iviRA::treatments[sim1.out$tx, .(route, years_since_approval)])
set.seed(102)
sim2.out <- sim_iviRA(tx_seqs = tx, input_data = input.dat, pars = parsamp,
                      model_structures = mod.structs, max_months = 12,
                      output = "summary")

test_that("sim_iviRA years since approval range", {
  expect_true(max(sim2.out$means$yrs_since_approval) <=
                max(iviRA::treatments$years_since_approval))
  expect_true(min(sim2.out$means$yrs_since_approval) >= 0)
  expect_true(min(iviRA::treatments$years_since_approval) >= 0)
})

test_that("sim_iviRA mean data equal to summary means", {
  sim1.means <- sim1.out[, lapply(.SD, function(x) sum(x)/input.dat$n),
                         by = c("model", "sim"),
                         .SDcols = c("qalys", "tx_cost")]
  expect_equal(mean(sim1.means$qalys), mean(sim2.out$means$qalys))
  expect_equal(mean(sim1.means$tx_cost), mean(sim2.out$means$tx_cost))
})

test_that("sim_iviRA time means data equal to summary time.means", {
  sim1.tmeans <- sim1.out[, lapply(.SD, mean), by = c("model", "sim", "month"),
                          .SDcols = c("haq", "qalys")]
  expect_equal(sim1.tmeans$haq, sim2.out$time.means$haq)
  expect_equal(sim1.tmeans$qalys, sim2.out$time.means$qalys)
})

test_that("sim_iviRA annualized outcomes", {
  maxt <- (100 - unique(pop[, "age"])) * 2
  sim1.out[, dqalys := (1/(1 + .03))^(month/12) * qalys]
  sim.dqalys.id <- sim1.out[, .(dqalys = sum(dqalys)), 
                           by = c("model", "sim", "id")]
  r <- 1/(1 + .03)^.5
  sim.dqalys.id[, dqalys_ann := dqalys * (1 - r)/(r * (1 - r^maxt))]
  sim.dqalys <- sim.dqalys.id[, .(dqalys_ann = mean(dqalys_ann)), 
                            by = c("model", "sim")]
  expect_equal(sim.dqalys$dqalys_ann * 2, sim2.out$means$dqalys_ann)
})

# sim_qalys --------------------------------------------------------------------
n <- 10
pop <- sample_pop(n = 10)
input.dat <- get_input_data(pop)
parsamp <- sample_pars(n = 5, input_data = input.dat)
x.attr <- iviRA::utility.tx.attr$x
simhaq <- data.table(yrlen = rep(.5, n), sim = rep(seq(1, 5), each = n/5),
                     tx = which(iviRA::treatments$sname == "tof"),
                     si = rbinom(n, 1, .1))
utility <- runif(n, 0, 1)
tx.attr.coef <- parsamp$utility.tx.attr
tx.attr.coef[, 1] <- 0.1

test_that("sim_qalys", {
  sim.qalys <- sim_qalys(simhaq = simhaq, utility = utility,
                         si_ul = parsamp$si.ul, x_attr = x.attr, 
                         tx_attr_coef = tx.attr.coef)
  sim.qalys1 <- simhaq$yrlen[1] * (utility[1] - simhaq$si[1] * parsamp$si.ul[1]/12 +
                                     x.attr[simhaq$tx[1],, drop = FALSE] %*% t(tx.attr.coef[1,, drop = FALSE]))
  expect_equal(sim.qalys[1], sim.qalys1[1])
  
  utility[1] <- 2
  sim.qalys <- sim_qalys(simhaq = simhaq, utility = utility,
                         si_ul = parsamp$si.ul, x_attr = x.attr, 
                         tx_attr_coef = tx.attr.coef)
  expect_equal(sim.qalys[1], 0.5)
})

# sim_utility_mixture ----------------------------------------------------------
test_that("sim_utility_mixture", {
  pop <- sample_pop(n = 10)
  tx.seq <- c("adamtx", "cdmards")
  mod.structs <- select_model_structures(utility_model = "wailoo")
  input.dat <- get_input_data(pop = pop)
  parsamp <- sample_pars(n = 10, input_dat = input.dat)
  sim.out <- sim_iviRA(tx_seqs = tx.seq, input_data = input.dat, pars = parsamp,
                       model_structures = mod.structs, output = "data")
  utility.mix <- sim_utility_mixture(simhaq = sim.out, male = pop[, "male"],
                                     pars = parsamp$utility.mixture)
  expect_equal(length(utility.mix), nrow(sim.out))
  expect_true(all(utility.mix <= 1))
})


# sim_dhaq6 --------------------------------------------------------------------
test_that("sim_dhaq6", {
  input.dat <- get_input_data(pop = sample_pop(n = 10))

  # HAQ directly
  parsamp <- sample_pars(n = 10, input_data = input.dat)
  sim <- sim_dhaq6(treatments = c("cdmards"), input_data = input.dat,
                   pars = parsamp, tx_ihaq = c("haq"))
  expect_equal(sim$dhaq[1], sim$dhaq[2])
  expect_equal(sim$dhaq[1], parsamp$haq$A[1])
  expect_equal(sim[sim == 2, dhaq][1], parsamp$haq$A[2])
  
  # response with NA
  sim <- sim_dhaq6(treatments = c("gol"), input_data = input.dat,
                   pars = parsamp, tx_ihaq = c("haq"))
  expect_true(all(is.na(sim$dhaq)))
})



