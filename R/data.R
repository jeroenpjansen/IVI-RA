#' Treatments
#'
#' Dataset of treatments for rheumatoid arthritis.
#'
#' @format A data.table object with 1 row for each treatment and 7 columns:
#' \describe{
#'   \item{name}{Long-form name of treatment.}
#'   \item{mname}{Medium-form name of treatment.}
#'   \item{sname}{Short-form name of treatment.}
#'   \item{biologic}{Indicator equal to 1 if a treatment is a biologic and 0 otherwise.}
#'   \item{route}{Route of administration.}
#'   \item{approval_date}{Date that treatment was approved in the US by the FDA.}
#'   \item{years_since_approval}{Years (from last update of the model) since the 
#'   treatment was approved.}
#' }
"treatments"

#' NMA estimates
#'
#' Estimates of mutually exclusive ACR response (ACR < 20, ACR 20 - <50, ACR 50 - <70, and ACR 70+), 
#' change in DAS28, and change in HAQ at 6 months for bDMARD naive patients from Bayesian
#' random effects NMAs.
#'
#' @details ACR response parameters were estimated using an ordered probit model. Parameters for
#' DAS28 and HAQ were estimated using models for continuous data with a normal likelihood and 
#' identity link. The mean and variance-covariance matrix were estimated using the sample means
#' and sample covariance matrices from the posterior distributions of the Bayesian analyses. 
#' 
#' @format Each dataset is a list with two elements
#' \describe{
#'   \item{mean}{Mean of the parameters.}
#'   \item{vcov}{Variance-covariance matrix of the parameters.}
#' }
#' @name nma
"nma.acr.naive"
#' @rdname nma
"nma.das28.naive"
#' @rdname nma
"nma.haq.naive"

#' ACR to EULAR Conversion
#'
#' Probability of EULAR response categories  (none, moderate, good) given
#'  mutually exclusive ACR response categories (ACR < 20, ACR 20 - <50, ACR 50 - <70, and ACR 70+).
#'
#' @format A matrix where each row shows the probability that a particular responder in an 
#' ACR category will have a given EULAR response. Probabilities are based on observed 
#' relationships in the VARA database.

#' @source Stevenson, Matt, et al. "Adalimumab, etanercept, infliximab, certolizumab pegol, 
#' golimumab, tocilizumab and abatacept for the treatment of rheumatoid arthritis not previously
#'  treated with disease-modifying antirheumatic drugs and after the failure of conventional 
#'  disease-modifying antirheumatic drugs only: systematic review and economic evaluation." 
#' Health Technology Assessment 20.35 (2016): 1-610.
"acr2eular"

#' HAQ change by 6-month ACR response
#'
#' Mean and standard deviation of HAQ change by mutually exclusive 6-month ACR response category 
#' (ACR < 20, ACR 20 - <50, ACR 50 - <70, and ACR 70+).
#'
#' @format A data.table with three columns. First column is ACR response category,
#' second column is mean change in HAQ at 6 months, and  third column is the standard error
#' of the mean change in HAQ.  
#' @source Carlson, Josh J., et al. "Economic evaluation of tocilizumab monotherapy compared to adalimumab monotherapy 
#' in the treatment of severe active rheumatoid arthritis." Value in Health 18.2 (2015): 173-179.
"acr2haq"

#' Change in SDAI by 6-month ACR response
#'
#' Mean of change in SDAI by 6-month mutually exclusive ACR response category 
#' (ACR < 20, ACR 20 - <50, ACR 50 - <70, and ACR 70+).
#'
#' @format A list of two data.tables each with four columns. Column 1 is ACR response category,
#'  column 2 is the point estimate for the mean change in SDAI at 6 months, and columns 3/4 are 
#'  lower/upper bounds on the mean change in SDAI. Current default is to set bounds to +/-20% of the
#'   mean. The first list corresponds to evidence from the leflunomide dataset and the second list 
#'   to evidence from an inception cohort. 
#' @source Aletaha, Daniel, and Josef S. Smolen. "The simplified disease activity index (SDAI) and 
#' clinical disease activity index (CDAI) to monitor patients in standard clinical care." 
#' Best practice & research Clinical rheumatology 21.4 (2007): 663-675.
#' 
#' Smolen, J. S., et al. "A simplified disease activity index for rheumatoid arthritis for use in 
#' clinical practice." Rheumatology 42.2 (2003): 244-257.
#' 
#' Aletaha, Daniel, et al. "Acute phase reactants add little to composite disease activity indices
#' for rheumatoid arthritis: validation of a clinical activity score." Arthritis research & 
#' therapy 7.4 (2005): R796.
"acr2sdai"

#' Change in CDAI by 6-month ACR response
#'
#' Mean of change in CDAI by 6-month mutually exclusive ACR response category 
#' (ACR < 20, ACR 20 - <50, ACR 50 - <70, and ACR 70+).
#'
#' @format A list of one data.tables with four columns. Column 1 is ACR response category,
#'  column 2 is the point estimate for the mean change in CDAI at 6 months, and columns 3/4 are 
#'  lower/upper bounds on the mean change in CDAI. Current default is to set bounds to +/-20% of
#'  the mean. Format is a list to facilitate inclusion of evidence from additional data sources 
#'  with different patient populations.
#' @source Aletaha, Daniel, and Josef S. Smolen. "The simplified disease activity index (SDAI) and 
#' clinical disease activity index (CDAI) to monitor patients in standard clinical care." 
#' Best practice & research Clinical rheumatology 21.4 (2007): 663-675.
#' 
#' Aletaha, Daniel, et al. "Acute phase reactants add little to composite disease activity indices
#' for rheumatoid arthritis: validation of a clinical activity score." Arthritis research & 
#' therapy 7.4 (2005): R796.
"acr2cdai"

#' Change in DAS28 by 6-month ACR response
#'
#' Mean of change in DAS28 by 6-month mutually exclusive ACR response category 
#' (ACR < 20, ACR 20 - <50, ACR 50 - <70, and ACR 70+).
#'
#' @format A list of one data.table with four columns. Column 1 is ACR response category,
#'  column 2 is the point estimate for the mean change in DAS28 at 6 months, and columns 3/4 are 
#'  lower/upper bounds on the mean change in DAS28. Format is a list to facilitate inclusion of
#'   evidence from additional data sources with different patient populations.  
#' @source Aletaha, Daniel, and Josef S. Smolen. "The simplified disease activity index (SDAI) and 
#' clinical disease activity index (CDAI) to monitor patients in standard clinical care." 
#' Best practice & research Clinical rheumatology 21.4 (2007): 663-675.
#' 
#' Aletaha, Daniel, et al. "Acute phase reactants add little to composite disease activity indices
#' for rheumatoid arthritis: validation of a clinical activity score." Arthritis research & 
#' therapy 7.4 (2005): R796.
"acr2das28"

#' HAQ change by 6-month EULAR Response
#'
#' Mean and standard deviation of HAQ change by 6-month EULAR response category 
#' (none, moderate, good).
#'
#' @format A matrix with rows as EULAR response categories. First column is mean and second 
#' column is standard deviation.
#' @source Stevenson, Matt, et al. "Adalimumab, etanercept, infliximab, certolizumab pegol, 
#' golimumab, tocilizumab and abatacept for the treatment of rheumatoid arthritis not previously
#'  treated with disease-modifying antirheumatic drugs and after the failure of conventional 
#'  disease-modifying antirheumatic drugs only: systematic review and economic evaluation." 
#' Health Technology Assessment 20.35 (2016): 1-610.
"eular2haq"


#' Linear HAQ progression rates
#'
#' Constant annual rate of HAQ progression by age and treatment.
#'
#' @format A list with two elements.
#' \describe{
#' \item{tx}{A matrix with 5 columns (sname, est, se, lower, upper) for the name of the treatment,
#' the annual progression rate for that treatment, the standard error of the progression,
#' the .025\% quantile of the progression rate and the 97.5\% quantile of the progression rate,
#' respectively.}
#' \item{diff.age}{A matrix with 5 columns (age, est, se, lower, upper) for the 
#' age range (\eqn{age < 40}, \eqn{40 \le age < 65}, \eqn{ age \ge 65}),
#' the difference between progression rate for a given age range and the overall rate,
#' the standard error of the progression rate difference, the .025\% quantile of the progression
#' rate difference, and the 97.5\% quantile of the progression rate difference, respectively. }
#' } 
#' 
#' @source Michaud, Kaleb, Gene Wallenstein, and Frederick Wolfe. "Treatment and nontreatment
#'  predictors of health assessment questionnaire disability progression in 
#'  rheumatoid arthritis: a longitudinal study of 18,485 patients." 
#'  Arthritis care & research 63.3 (2011): 366-372.
#'  
#' Wolfe, Frederick, and Kaleb Michaud. "The loss of health status in rheumatoid 
#' arthritis and the effect of biologic therapy: a longitudinal observational study." 
#' Arthritis research & therapy 12.2 (2010): 1.
"haq.lprog"

#' Latent Class Growth Model (LCGM) for HAQ progression
#'
#' Parameters for Norton (2014) LCGM used to simulate non-linear HAQ trajectories for
#' 4 latent classes.
#'
#' @format List containing coefficients (point estimates and parameter names)
#'  and variance-covariance matrix.
#' @source Norton, Sam, et al. "Health Assessment Questionnaire disability progression in early
#'  rheumatoid arthritis: systematic review and analysis of two inception cohorts." 
#'  Seminars in arthritis and rheumatism. Vol. 44. No. 2. WB Saunders, 2014.
"haq.lcgm"

#' Time to treatment discontinuation parameters
#'
#' \code{ttd.all}, \code{ttd.da}, and \code{ttd.eular} are lists of lists containing parameters 
#' from statistical models of time to treatment discontinuation. \code{ttd.all} contains 
#' parameters representative of all patients, \code{ttd.da} contains covariates for disease 
#' activity level (moderate, high), and \code{ttd.eular} is stratified by EULAR response 
#' (moderate, good).
#' 
#' @details 
#' Models were fit using \emph{flexsurv}.
#' Survival curves are based on analyses of reconstructed individual patient data. 
#'
#' @format A list as described in \link{sample_pars}
#'
#' @source Stevenson, Matt, et al. "Adalimumab, etanercept, infliximab, certolizumab pegol, 
#' golimumab, tocilizumab and abatacept for the treatment of rheumatoid arthritis not previously
#'  treated with disease-modifying antirheumatic drugs and after the failure of conventional 
#'  disease-modifying antirheumatic drugs only: systematic review and economic evaluation." 
#' Health Technology Assessment 20.35 (2016): 1-610.
#' 
#' Zhang, Jie, et al. "Thresholds in disease activity for switching biologics in rheumatoid 
#' arthritis patients: experience from a large US cohort." 
#' Arthritis care & research 63.12 (2011): 1672-1679.
#' 
#' Guyot, Patricia, et al. "Enhanced secondary analysis of survival data: reconstructing the data
#'  from published Kaplan-Meier survival curves." BMC medical research 
#'  methodology 12.1 (2012): 9.
#' @name ttd
"ttd.eular"
#' @rdname ttd
"ttd.da"
#' @rdname ttd
"ttd.all"

#' Time to serious infection parameters
#'
#' Parameters for sampling serious infections using an exponential distribution.
#' @format A data.table with three columns:
#' \describe{
#' \item{sname}{Short name of treatment.}
#' \item{lograte}{Log of serious infection rate.}
#' \item{lograte_se}{Standard error of log of serious infection rate.}
#' }
#' @source Singh, Jasvinder A., et al. "Adverse effects of biologics: a network meta-analysis 
#' and Cochrane overview." Cochrane Database of Systematic Reviews 2 (2010).
"ttsi"

#' US Lifetables 2011
#'
#' Life tables by single-year of age from National Vital Statistics Reports
#' Volume 64, Number 11.
#'
#' @format A data frame with 101 rows and 7 variables:
#' \describe{
#'   \item{age}{Age in years.}
#'   \item{qx}{Probability of dying between ages x and x + 1.}
#'   \item{lx}{Number surviving to age x.}
#'   \item{dx}{Number dying between ages x and x + 1.}
#'   \item{L}{Person-years lived between ages x and x + 1.}
#'   \item{Tx}{Total number of person-years lived above age x.}
#'   \item{ex}{Expectation of life at age x.}
#'
#' }
#' @source \url{http://www.cdc.gov/nchs/data/nvsr/nvsr64/nvsr64_11.pdf}
#' @name lifetable
"lifetable.female"
#' @rdname lifetable
"lifetable.male"

#' Mortality odds ratios by patient characteristics
#'
#' Impact of HAQ on odds ratio for mortality from table 4 in Wolfe et al (2003).
#'
#' @format A data frame with 1 row and 9 columns:
#' \describe{
#'   \item{var}{Name of variable}
#'   \item{or}{Odds ratio without radiographic data}
#'   \item{or_se}{Standard error of odds ratio without radiographic data}
#'   \item{or_lower}{Lower bound of 95 percent CI of odds ratio without radiographic data}
#'   \item{or_upper}{Upper bound of 95 percent CI of odds ratio without radiographic data}
#'   \item{logor}{Log odds ratio without radiographic data}
#'   \item{logor_lower}{Lower bound of 95 percent CI of log odds ratio without radiographic data}
#'   \item{logor_upper}{Upper bound of 95 percent CI of log odds ratio without radiographic data}
#'   \item{logor_se}{Standard error of log odds ratio without radiographic data}
#' }
#' 
#' @details The standard errors of the log odds ratios are derived from the 95 percent confidence 
#' interval for the log odds ratio, which is, in turn, calculated by taking the log of the lower and upper
#' bounds of the 95 perent confidence interval for the odds ratio. 
#' 
#' @source {Wolfe, Frederick, et al. "Predicting mortality in patients with rheumatoid arthritis." 
#' Arthritis & Rheumatism 48.6 (2003): 1530-1542.}
"mort.or"

#' Mortality hazard ratio for change in HAQ score
#'
#' Impact of change in HAQ on for mortality from Table 3 in Michaud et al (2012).
#'
#' @format A data frame with 5 rows and 8 variables. Key variables are month, log of hazard ratio, 
#' and standard error of log of hazard ratio.
#' \describe{
#'   \item{month}{Month of reported hazard ratio (\eqn{month \le 6}, \eqn{6 > month \le 12}, 
#'   \eqn{12 < month \le 24}, \eqn{24 < month \le 36}, \eqn{month > 36}).}
#'   \item{loghr}{Log of hazard ratio for impact of .25 unit HAQ increase on mortality}
#'   \item{loghr_se}{Standard error of log of hazard ratio for impact of .25 unit HAQ increase on mortality}
#' }
#' @source {Michaud, Kaleb, Montserrat Vera-Llonch, and Gerry Oster. "Mortality risk by functional status and health-related quality of life in patients with rheumatoid arthritis." 
#' The Journal of rheumatology 39.1 (2012): 54-59.}
"mort.hr.haqdif"

#' Treatment costs
#'
#' Acquisition and administration costs for medications used to treat rheumatoid
#' arthritis. 
#'
#' @format A list with two elements: \code{cost} and \code{lookup}. The element
#' \code{cost} is a data table of variables needed to calculate acquisition and
#'  administration costs. Each row denotes a unique treatment. There are 17 variables:
#' \describe{
#'   \item{name}{Long-form name of treatment.}
#'   \item{sname}{Short-form name of treatment.}
#'   \item{dosage}{FDA approved dosage.}
#'   \item{strength_dosage_form}{Strength and dosage form of treatment}
#'   \item{init_dose_val}{Numeric value of dose approved by FDA during the first 6 months of
#'   treatment.}
#'   \item{ann_dose_val}{Numeric value of dose approved by FDA beyond the first 6 months.}
#'   \item{dose_unit}{Unit of FDA approved dose.}
#'   \item{init_num_doses}{Number of doses based on FDA used during the first 6 months.}
#'   \item{ann_num_doses}{Annual number of doses based on FDA beyond the first 6 months.}
#'   \item{strength_val}{Numeric value of strength of treatment.}
#'   \item{strength_unit}{Unit of treatment.}
#'   \item{price_per_unit}{Price per unit of treatment. By default, wholesale acquisition costs 
#'   (WACs) are used.}
#'   \item{discount_lower}{Discounts and rebates negotiated with manufacturers typically decrease
#'   prices paid by patients. Specificy a lower bound for this discount as a proportion of
#'   \code{price_per_unit}.}
#'   \item{discount_upper}{An upper bound for the discount as a proportion of 
#'   \code{price_per_unit}.}
#'   \item{infusion_cost}{Cost per infusion.}
#'   \item{loading_dose}{Equal to 1 if a loading dose is used and 0 otherwise. If a loading 
#'   dose is used, then the infusion cost is only applied to the first dose.}
#'   \item{weight_based}{If \code{weight_based} is equal to 1, then dosing is based on each 
#'   patient's weight (i.e., as sampled by \link{sample_pop}).}
#' }
#' 
#' The element \code{lookup} is a data table with 3 variables. The first variable, \code{sname},
#' is the short-form name of a treatment (e.g., corresponding to \code{sname} in 
#' \code{iviRA::treatments}). All remaining columns are the unique agents making up a given
#' treatment. For example, abatecept IV + methotrexate consists of abatecept IV and 
#' methotrexate.
"tx.cost"

#' Hospitalization costs
#'
#' Hospitalization costs due to RA.
#'
#' @format A data table with 5 variables.
#' \describe{
#'   \item{haq}{HAQ score range.}
#'   \item{days_mean}{Mean number of days in the hospital per year for a given HAQ score range.}
#'   \item{days_se}{Standard error of number of days in the hospital for a given HAQ score range.}
#'   \item{cost_pday_mean}{Mean number of costs per day in the hospital for a given HAQ score range.}
#'   \item{cost_pday_se}{Standard error of costs per day in the hospital for a given HAQ score range.}
#' }
#' @source Carlson, Josh J., et al. "Economic evaluation of tocilizumab monotherapy compared to adalimumab monotherapy 
#' in the treatment of severe active rheumatoid arthritis." Value in Health 18.2 (2015): 173-179.
"hosp.cost"

#' Cost of general management of RA
#'
#' Cost of general management of RA.
#'
#' @format A data table with 4 variables.
#' \describe{
#'   \item{service}{Medical service performed}
#'   \item{est}{Point estimate for cost}
#'   \item{lower}{Lower range for cost}
#'   \item{upper}{Upper range for cost}
#' }
#' @source {Claxton, Lindsay, et al. "An Economic Evaluation of Tofacitinib Treatment in Rheumatoid 
#' Arthritis: Modeling the Cost of Treatment Strategies in the United States." Journal of managed
#'care & specialty pharmacy 22.9 (2016): 1088-1102.}
"mgmt.cost"

#' Productivity loss 
#'
#' Annual earnings loss from a 1-unit change in the HAQ score.
#'
#' @format A data table with 2 variables.
#' \describe{
#'   \item{est}{Estimate of the impact of 1-unit change in HAQ on annual lost earnings.}
#'   \item{se}{Standard error of point estimate of lost earnings.}
#' }
#' @source {Wolfe, Frederick, et al. "Household income and earnings losses among 6,396 persons
#'  with rheumatoid arthritis." The Journal of Rheumatology 32.10 (2005): 1875-1883.}
"prod.loss"

#' Mixture model utility mapping
#'
#' Coefficients and variance-covariance matrix from the Alava (2013) mixture model
#' used to map HAQ score to utilities.
#'
#' @format List containing coefficient vector (point estimates and parameter names) and 
#' variance-covariance matrix, and indices for parameters.
#'
#' @source Alava, Monica Hernandez, et al. "The relationship between EQ-5D, 
#'  HAQ and pain in patients with rheumatoid arthritis." Rheumatology 52.5 (2013): 944-950.
"utility.mixture"

#' Wailoo (2006) utility mapping
#'
#' Coefficients and standard errors from Wailoo (2006) logistic regression equation
#'  used to map HAQ score to utilities.
#'
#' @format A data.table containing the following columns.
#' \describe{
#'   \item{var}{Name of the variable.}
#'   \item{est}{Point estimate on the log odds scale.}
#'   \item{se}{Standard error of the point estimate.}
#' } 
#'
#' @source Wailoo, A., et al. "Modeling the cost effectiveness of etanercept, adalimumab and 
#' anakinra compared to infliximab in the treatment of patients with rheumatoid arthritis in the
#'  Medicare program." Rockville, MD: Agency for Healthcare Research and Quality (2006).
"utility.wailoo"

#' Correlation between HAQ and pain
#'
# Correlation between HAQ and pain as meausred on the visual analog scale (VAS).
#'
#' @format List containing mean and variance of HAQ and pain scores, as well as the 
#' correlation between pain and HAQ.
#'
#' @source Sarzi-Puttini, Piercarlo, et al. "Correlation of the score for subjective pain with
#'  physical disability, clinical and radiographic scores in recent onset rheumatoid arthritis."
#'  BMC musculoskeletal disorders 3.1 (2002): 1..
"pain"

#' Treatment attributes
#'
#' Impact of treatment attributes other than safety and efficacy on utility.
#'
#' @format A list with two elements. 
#' \describe{
#'   \item{x}{A matrix where each column is a treatment attribute and each row corresponds
#'   to a treatment.}
#'   \item{coef}{A matrix with three columns, \code{var}, \code{lower} and \code{upper}.  
#'   \code{var} is the name of the variable; \code{lower} and \code{upper} are
#'    the lower and upper bounds of the utility \emph{gain} associated with each treatment 
#'    attribute in the \code{x} matrix respectively.}
#' } 
#'
#' @details In \link{sample_pars}, the value of the coefficient is randomly sampled from a 
#' uniform distribution with lower bound equal to \code{lower} and upper bound equal to 
#' \code{upper}. The impact of treatment attributes for a given treatment on utility in 
#' \link{sim_iviRA} is given by multiplying the sampled coefficient vectors from 
#' \link{sample_pars} by the row of the matrix \code{x} corresponding to the treatment being
#' simulated by the model. 
#' 
#' @source None. Currently determined by the user. 
"utility.tx.attr"

#' Incidence
#'
#' Incidence of rheumatoid arthritis in the United States.
#'
#' @format A data frame with 86 rows and 4 variables:
#' \describe{
#'   \item{age}{Age in years.}
#'   \item{events}{Number of events occuring between ages x and x + 1.}
#'   \item{person_years}{Number of person years between ages x and x + 1.}
#'   \item{incidence_rate}{Incidence rate between ages x and x + 1.}
#'
#' }
#' 
#' @details The incidence rate for each age is derived from Table 2 in Myasoedova et al. (2010), which
#' was a study conducted in Olmsted County, Minnesota for residents age 18 years of age and older
#' between 1995 and 2007.
#' 
#' @source Myasoedova, Elena, et al. "Is the incidence of rheumatoid arthritis rising? Results from
#' Olmsted Country, Minnesota, 1995-2007." Arthritis & Rheumatology 62.6 (2010): 1576-1582.
#' 
#' 
#' @name incidence
"incidence.female"
#' @rdname incidence
"incidence.male"

